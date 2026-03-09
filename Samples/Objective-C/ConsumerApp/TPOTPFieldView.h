//
//  TPOTPFieldView.h
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//

#import <UIKit/UIKit.h>

@class TPOTPTextField;

NS_ASSUME_NONNULL_BEGIN

@protocol OTPFieldViewDelegate <NSObject>
- (void)enteredOTP:(NSString *)otp;
- (void)hasEnteredAllOTP:(BOOL)hasEnteredAll;
@end

@interface TPOTPFieldView : UIView <UITextFieldDelegate>

/// Number of OTP boxes (default: 4)
@property (nonatomic) NSInteger fieldsCount;

/// Font for each box (default: bold 18 pt)
@property (nonatomic, strong) UIFont *fieldFont;

/// If YES, shows ● and stores actual digits separately (default: NO)
@property (nonatomic) BOOL secureEntry;

/// Size (width == height) of each box (default: 60)
@property (nonatomic) CGFloat fieldSize;

/// Spacing between boxes (default: 16)
@property (nonatomic) CGFloat separatorSpace;

/// If NO, disallows jumping ahead (must fill in order) (default: YES)
@property (nonatomic) BOOL shouldAllowIntermediateEditing;

/// Background colors
@property (nonatomic, strong) UIColor *defaultBackgroundColor;  // default: clear
@property (nonatomic, strong) UIColor *filledBackgroundColor;   // default: clear (unused in original Swift, preserved)

/// Placeholder & text color
@property (nonatomic, strong) UIColor *placeHolderColor;        // default: lightGray
@property (nonatomic, strong) UIColor *fieldTextColor;          // default: black

/// State
@property (nonatomic) BOOL hasEnteredOTP;                       // set true when complete
@property (nonatomic, copy) NSString *otpString;                // concatenated digits when complete

@property (nonatomic, weak, nullable) id<OTPFieldViewDelegate> delegate;

/// Build UI and fields (call after sizing)
- (void)initializeUI;

/// Feed input from a keypad. Pass 0–9 for digits, and **100** for delete.
- (void)setTextWithTag:(NSInteger)tag;

/// Clear everything and reset cursor to the first field
- (void)resetAllOTPFields;

@end

NS_ASSUME_NONNULL_END
