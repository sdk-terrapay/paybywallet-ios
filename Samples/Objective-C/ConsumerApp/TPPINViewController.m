//
//  TPPINViewController.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//

#import "TPPINViewController.h"

// SDK / Project headers (adjust to your actual module names and headers)
#import "TerraPayWalletSDK/TerraPayWalletSDK-Swift.h"
#import "TPOTPFieldView.h"

// If you have UIFont+Custom, include it and replace system font usage accordingly.
// #import "UIFont+Custom.h"

// If you use named colors via assets or custom categories, make sure the selectors exist:
// e.g., UIColor.primarycolor / UIColor.placeholderText

@interface TPPINViewController () <OTPFieldViewDelegate>

@property (nonatomic, strong, nullable) NSString *enteredPINString;
@property (nonatomic, assign) BOOL hasEnteredAll;

@end

@implementation TPPINViewController

+ (NSString *)identifier {
    return @"TPPINViewController";
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUIView];
    [self setupOTPView];
}

#pragma mark - UI Setup

- (void)setupUIView {
    // Set keypad font
    // UIFont *bold20 = [UIFont custom:TPFontWeightBold size:20.0];
    UIFont *bold20 = [UIFont boldSystemFontOfSize:20.0];
    for (UIButton *btn in self.keyPadButtons) {
        btn.titleLabel.font = bold20;
    }

    self.viewWarning.hidden = YES;

    // Merchant + amount labels
    NSString *merchantName = self.merchantInfo.merchantName ?: @"";
    NSString *currency = self.merchantInfo.subscriberCurrency ?: @"";
    NSString *amount = self.merchantInfo.subscriberAmount ?: @"";

    if (merchantName.length > 0) {
        self.lblMerchantName.text = merchantName;
    }
    if (currency.length > 0 || amount.length > 0) {
        self.lblAmount.text = [NSString stringWithFormat:@"%@ %@", currency, amount];
    }

    self.viewSender.layer.cornerRadius = 8.0;
    self.viewSender.layer.masksToBounds = YES;

    self.viewWarning.hidden = YES;

    [self handleButtonProceedUIWithEnabled:NO];
}

- (void)setupOTPView {
    // Configure OTPFieldView similar to Swift
    if ([UIColor respondsToSelector:@selector(primarycolor)]) {
        self.pinFieldView.fieldTextColor = [UIColor performSelector:@selector(primarycolor)];
    } else {
        self.pinFieldView.fieldTextColor = [UIColor blackColor];
    }

    if ([UIColor respondsToSelector:@selector(placeholderText)]) {
        self.pinFieldView.placeHolderColor = [UIColor performSelector:@selector(placeholderText)];
    } else {
        if (@available(iOS 13.0, *)) {
            self.pinFieldView.placeHolderColor = [UIColor placeholderTextColor];
        } else {
            self.pinFieldView.placeHolderColor = [UIColor lightGrayColor];
        }
    }

    self.pinFieldView.defaultBackgroundColor = UIColor.whiteColor;
    self.pinFieldView.fieldSize = 15;
    self.pinFieldView.separatorSpace = 30;
    self.pinFieldView.shouldAllowIntermediateEditing = NO;
    self.pinFieldView.delegate = self;
    [self.pinFieldView initializeUI];
}

- (void)handleButtonProceedUIWithEnabled:(BOOL)enabled {
    UIColor *tint = nil;
    if (enabled && [UIColor respondsToSelector:@selector(primarycolor)]) {
        tint = [UIColor performSelector:@selector(primarycolor)];
    } else if (enabled) {
        tint = [UIColor systemBlueColor];
    } else {
        tint = [UIColor darkGrayColor];
    }
    self.imgProceed.tintColor = tint;
}

#pragma mark - Actions

// Connect all keypad buttons (0–9) to this IBAction
- (IBAction)handleNumberPadClicked:(UIButton *)sender {
    // Assumes button.tag is digit 0–9
    [self.pinFieldView setTextWithTag:sender.tag];
}

// If you need delete/backspace button handling, add an IBAction and call a proper API from OTPFieldView, e.g.:
// - (IBAction)handleDeletePressed:(id)sender {
//     [self.pinFieldView deleteLastDigit]; // replace with your OTPFieldView’s actual method
// }

#pragma mark - Helpers

- (NSString *)generateOrderId {
    // "TP" + 12 random digits, uppercased
    static NSString * const digits = @"0123456789";
    NSMutableString *randomPart = [NSMutableString stringWithCapacity:12];
    for (NSInteger i = 0; i < 12; i++) {
        uint32_t idx = arc4random_uniform((uint32_t)digits.length);
        unichar c = [digits characterAtIndex:idx];
        [randomPart appendFormat:@"%C", c];
    }
    NSString *orderId = [NSString stringWithFormat:@"TP%@", randomPart];
    return orderId.uppercaseString;
}

#pragma mark - OTPFieldViewDelegate

- (void)enteredOTP:(NSString *)otp {
    self.enteredPINString = otp;
    // Trigger payment with generated transactionId
    NSString *txnId = [self generateOrderId];
    [[TerraPayWalletClient shared] processPaymentWithController:self transactionId:txnId];
}

- (void)hasEnteredAllOTP:(BOOL)hasEnteredAll {
    self.hasEnteredAll = hasEnteredAll;
    [self handleButtonProceedUIWithEnabled:hasEnteredAll];
}

@end
