//
//  ViewController.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//
#import "ViewController.h"
#import "NSString+TPSize.h"
#import "TPNetworkManager.h"
#import "TerraPayWalletSDK/TerraPayWalletSDK-Swift.h"
#import "TPPINViewController.h"
#import "UIView+Extension.h"

#pragma mark - UIViewController Toast

@interface UIViewController (TPToast)
- (void)showToastWithMessage:(NSString *)message;
@end

@implementation UIViewController (TPToast)

- (void)showToastWithMessage:(NSString *)message {
//     UIFont *font = [UIFont custom:TPFontWeightRegular size:13.0]; // Example if you have custom font method
    UIFont *font = [UIFont systemFontOfSize:13.0];

    CGSize msgSize = [message tp_sizeForViewWithFont:font
                                               width:CGFLOAT_MAX
                                              height:35.0];
    
    
    CGFloat maxWidth = UIScreen.mainScreen.bounds.size.width - 40.0;
    CGFloat toastWidth = MIN(msgSize.width + 20.0, maxWidth);

    CGFloat x = (self.view.frame.size.width - toastWidth) / 2.0;
    CGFloat y = self.view.frame.size.height - 100.0;

    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, toastWidth, 35.0)];
    toastLabel.backgroundColor = [UIColor darkGrayColor];

    UIColor *fg = [UIColor colorNamed:@"buttonFG"];
    toastLabel.textColor = fg ?: [UIColor whiteColor];

    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.font = font;
    toastLabel.text = message;
    toastLabel.alpha = 1.0;
    toastLabel.layer.cornerRadius = 10.0;
    toastLabel.clipsToBounds = YES;

    [self.view addSubview:toastLabel];

    [UIView animateWithDuration:4.0
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        toastLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [toastLabel removeFromSuperview];
    }];
}

@end


@implementation ViewController: UIViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize constants (equivalent to Swift lets)
    self.subscriberName = @"TerraPay User";
    self.msisdn = @"766901491";
    self.dialCode = @"+256";
    self.balance = @"100000";
    self.currencyCode = @"KES";
    self.countryCode = @"KE";
    self.countryName = @"KENYA";

    [self setUpUIElements];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Re-apply corner rounding mask since layer mask depends on bounds
    [self.viewHeader tp_roundCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) radius:14.0];
}

#pragma mark - Private

- (void)setUpUIElements {
    [self.viewHeader tp_roundCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) radius:14.0];
    [self.viewContainer tp_setRadiusWithShadow];
    [self displayUserInfo];
}

- (void)displayUserInfo {
    self.lblNameCustomer.text = self.subscriberName;
    self.lblNameShort.text = @"TU";
    self.lblMobileNum.text = [NSString stringWithFormat:@"%@%@", self.dialCode, self.msisdn];
    self.lblBalance.text = [NSString stringWithFormat:@"%@ %@", self.currencyCode, self.balance];
}

#pragma mark - Actions

- (IBAction)handleViewTransactionsClicked:(id)sender {
    if (TPNetworkManager.networkStatus != TPNetworkStatusSatisfied) {
        [[TPNetworkManager shared] showNoInternetAlertWithParent:self];
        return;
    }

    // TODO: push/present your transactions screen when network is available.
}

- (IBAction)handleMerchantPaymentsClicked:(id)sender {
  
    TerraPayWalletSDKConfig *config =
        [[TerraPayWalletSDKConfig alloc] initWithController:self
                                          subscriberDialCode:@"+256"
                                          subscriberCountry:@"UG"
                                     subscriberCountryName:@"UGANDA"
                                            subscriberName:@"MTN MoMo"
                                         subscriberMSISDN:@"766901491"
                                       subscriberCurrency:@"UGX"
                                            walletBalance:@"100000"
                                             primaryColor:@"52B44A"
                                           secondaryColor:@"FFFFFF"];
    
    [[TerraPayWalletClient shared] launchWith: config
                            completionHandler:^(TPLaunchType launchType,
                                                TPErrorInfo * _Nullable error,
                                                TPMerchant * _Nullable merchantmodel,
                                                TPPaymentStatus * _Nullable statusModel) {
        
        switch (launchType) {
            case TPLaunchTypeOnPINAuthenticate: {
                if (merchantmodel != nil) {
                    NSLog(@"%@", merchantmodel);
                    [self showTargetHostScreen:merchantmodel];
                }
                break;
            }

            case TPLaunchTypeOnError: {
                if (error.message != nil) {
                    [self showToastWithMessage:error.message];
                }
                break;
            }

            case TPLaunchTypeCancelled: {
                [self showToastWithMessage:@"User cancelled."];
                break;
            }

            case TPLaunchTypeOnPaymentSuccess: {
                NSLog(@"Base app: %@", statusModel.description);
                break;
            }

            case TPLaunchTypeOnPaymentFailure: {
                if (error != nil) {
                    [self showToastWithMessage:error.message];
                } else {
                    [self showToastWithMessage:@"Something went wrong."];
                }
                break;
            }
        }
    }];

    
    
}

#pragma mark - Navigation

- (void)showTargetHostScreen:(TPMerchant *)merchant {
    UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [stb instantiateViewControllerWithIdentifier:[TPPINViewController identifier]];
    if ([vc isKindOfClass:[TPPINViewController class]]) {
        TPPINViewController *targetVC = (TPPINViewController *)vc;
        targetVC.modalPresentationStyle = UIModalPresentationFullScreen;
        targetVC.merchantInfo = merchant;
        [self presentViewController:targetVC animated:YES completion:nil];
    }
}

@end
