//
//  TPOTPFieldView.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//

#import "TPOTPFieldView.h"
#import "TPOTPFieldView.h"
#import "TPOTPTextField.h"

@interface TPOTPFieldView ()

@property (nonatomic, strong) NSMutableArray<NSString *> *secureEntryData;
@property (nonatomic) NSInteger currIndex;

@end

@implementation TPOTPFieldView

#pragma mark - Init & Defaults

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self applyDefaults];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    [self applyDefaults];
    return self;
}

- (void)applyDefaults {
    _fieldsCount = 4;
    _fieldFont = [UIFont boldSystemFontOfSize:18.0];
    _secureEntry = NO;
    _fieldSize = 60.0;
    _separatorSpace = 16.0;
    _shouldAllowIntermediateEditing = YES;
    _defaultBackgroundColor = UIColor.clearColor;
    _filledBackgroundColor = UIColor.clearColor;
    _placeHolderColor = UIColor.lightGrayColor;
    _fieldTextColor = UIColor.blackColor;

    _hasEnteredOTP = NO;
    _otpString = @"";
    _currIndex = 0;
    _secureEntryData = [NSMutableArray array];
}

#pragma mark - Public

- (void)initializeUI {
    self.layer.masksToBounds = YES;
    [self layoutIfNeeded];

    [self initializeOTPFields];

    [self layoutIfNeeded];
}

- (void)setTextWithTag:(NSInteger)tag {
    self.hasEnteredOTP = NO;

    // 100 means delete/backspace
    if (tag == 100) {
        TPOTPTextField *textField = [self getOTPFieldForIndex:self.currIndex];
        NSString *currentText = textField.text ?: @"";

        if (textField.tag > 1 && currentText.length == 0) {
            UITextField *prevField = (UITextField *)[self viewWithTag:textField.tag - 1];
            if (prevField) {
                [self deleteTextInTextField:prevField];
                self.currIndex = MAX(0, self.currIndex - 1);
            }
        } else {
            [self deleteTextInTextField:textField];
            if (textField.tag > 1) {
                UITextField *prev = (UITextField *)[self viewWithTag:textField.tag - 1];
                if (prev) {
                    self.currIndex = MAX(0, self.currIndex - 1);
                }
            }
        }
    } else {
        // Add digit (0–9)
        TPOTPTextField *otpField = (TPOTPTextField *)[self viewWithTag:self.currIndex + 1];
        if (otpField) {
            if (self.secureEntry) {
                otpField.text = @"●";
            } else {
                otpField.text = [NSString stringWithFormat:@"%ld", (long)tag];
            }

            NSInteger storeIndex = otpField.tag - 1;
            if (storeIndex >= 0 && storeIndex < self.secureEntryData.count) {
                self.secureEntryData[storeIndex] = [NSString stringWithFormat:@"%ld", (long)tag];
            }
            self.currIndex += 1;
        }
    }

    // When filled all fields, compute OTP and notify delegate
    if (self.currIndex == self.fieldsCount) {
        // Keep last box synced (mirrors Swift behavior)
        TPOTPTextField *lastField = (TPOTPTextField *)[self viewWithTag:self.currIndex];
        if (lastField) {
            // NOTE: in Swift they used the incoming 'tag'; here this branch is hit only on digit input.
            // So it's safe to reflect the same text update.
            if (self.secureEntry) {
                lastField.text = @"●";
            } else {
                // Nothing to change, already set above.
            }
        }

        NSMutableString *entered = [NSMutableString string];
        for (NSInteger i = 0; i < self.secureEntryData.count; i++) {
            NSString *piece = self.secureEntryData[i];
            if (piece.length > 0) {
                [entered appendString:piece];
            }
        }

        self.hasEnteredOTP = YES;
        self.otpString = entered.copy;

        if ([self.delegate respondsToSelector:@selector(enteredOTP:)]) {
            [self.delegate enteredOTP:self.otpString];
        }
        if ([self.delegate respondsToSelector:@selector(hasEnteredAllOTP:)]) {
            [self.delegate hasEnteredAllOTP:YES];
        }
    }
}

- (void)resetAllOTPFields {
    for (NSInteger index = 0; index < self.fieldsCount; index++) {
        TPOTPTextField *otpField = (TPOTPTextField *)[self viewWithTag:index + 1];
        if (!otpField) {
            otpField = [self getOTPFieldForIndex:index];
        }
        otpField.text = @"";
    }
    self.currIndex = 0;

    // Clear stored digits
    for (NSInteger i = 0; i < self.secureEntryData.count; i++) {
        self.secureEntryData[i] = @"";
    }

    self.hasEnteredOTP = NO;
    self.otpString = @"";
}

#pragma mark - Private UI Builders

- (void)initializeOTPFields {
    [self.secureEntryData removeAllObjects];

    for (NSInteger index = 0; index < self.fieldsCount; index++) {
        TPOTPTextField *old = (TPOTPTextField *)[self viewWithTag:index + 1];
        [old removeFromSuperview];

        TPOTPTextField *otpField = [self getOTPFieldForIndex:index];
        otpField.userInteractionEnabled = NO; // Input is handled via keypad
        [self addSubview:otpField];

        [self.secureEntryData addObject:@""]; // reserve slot
    }
}

- (TPOTPTextField *)getOTPFieldForIndex:(NSInteger)index {
    BOOL hasOdd = (self.fieldsCount % 2 == 1);
    CGRect fieldFrame = CGRectMake(0, 0, self.fieldSize, self.fieldSize);

    if (hasOdd) {
        // Center alignment (odd)
        fieldFrame.origin.x = self.bounds.size.width / 2.0
        - ((CGFloat)(self.fieldsCount / 2 - index) * (self.fieldSize + self.separatorSpace) + self.fieldSize / 2.0);
    } else {
        // Center alignment (even)
        fieldFrame.origin.x = self.bounds.size.width / 2.0
        - ((CGFloat)(self.fieldsCount / 2 - index) * self.fieldSize
           + (CGFloat)(self.fieldsCount / 2 - index - 1) * self.separatorSpace
           + self.separatorSpace / 2.0);
    }

    fieldFrame.origin.y = (self.bounds.size.height - self.fieldSize) / 2.0;

    TPOTPTextField *otpField = [[TPOTPTextField alloc] initWithFrame:fieldFrame];
    otpField.delegate = self;
    otpField.tag = index + 1;
    otpField.font = self.fieldFont;

    otpField.backgroundColor = self.defaultBackgroundColor;

    // Build final look
    [otpField initializeUI];
    otpField.textColor = self.fieldTextColor;

    UIColor *placeholderColor = self.placeHolderColor;
    if (@available(iOS 13.0, *)) {
        // If you prefer system placeholder color, uncomment below:
        // placeholderColor = [UIColor placeholderTextColor];
    }

    NSDictionary<NSAttributedStringKey, id> *attrs = @{
        NSForegroundColorAttributeName: placeholderColor ?: UIColor.lightGrayColor,
        NSFontAttributeName: self.fieldFont ?: [UIFont systemFontOfSize:17.0]
    };
    otpField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"●" attributes:attrs];

    return otpField;
}

#pragma mark - Flow Control

- (BOOL)isPreviousFieldsEnteredForTextField:(UITextField *)textField {
    BOOL isTextFilled = YES;
    UITextField *nextOTPField = nil;

    if (!self.shouldAllowIntermediateEditing) {
        for (NSInteger index = 1; index <= self.fieldsCount; index++) {
            UITextField *temp = (UITextField *)[self viewWithTag:index];
            if (temp && temp.text.length == 0) {
                nextOTPField = temp;
                break;
            }
        }
        if (nextOTPField) {
            // Allowed if it's the next empty field or we are right before it.
            isTextFilled = (nextOTPField == textField || (textField.tag == (nextOTPField.tag - 1)));
        }
    }
    return isTextFilled;
}

- (void)calculateEnteredOTPStringIsDeleted:(BOOL)isDeleted {
    self.hasEnteredOTP = NO;

    if (isDeleted) {
        if ([self.delegate respondsToSelector:@selector(hasEnteredAllOTP:)]) {
            [self.delegate hasEnteredAllOTP:NO];
        }

        // In Swift, they rebuilt/ensured boxes exist; we already do that on init.
        // Keep placeholders/visuals untouched here.
    } else {
        NSMutableString *entered = [NSMutableString string];

        for (NSInteger i = 0; i < self.secureEntryData.count; i++) {
            NSString *val = self.secureEntryData[i];
            if (val.length > 0) {
                [entered appendString:val];
            }
        }

        if (entered.length == self.fieldsCount) {
            self.hasEnteredOTP = YES;
            self.otpString = entered.copy;

            if ([self.delegate respondsToSelector:@selector(enteredOTP:)]) {
                [self.delegate enteredOTP:self.otpString];
            }
            if ([self.delegate respondsToSelector:@selector(hasEnteredAllOTP:)]) {
                [self.delegate hasEnteredAllOTP:(entered.length == self.fieldsCount)];
            }
        }
    }
}

- (void)deleteTextInTextField:(UITextField *)textField {
    NSInteger idx = textField.tag - 1;
    if (idx >= 0 && idx < self.secureEntryData.count) {
        self.secureEntryData[idx] = @"";
    }
    textField.text = @"";
    [self calculateEnteredOTPStringIsDeleted:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [self isPreviousFieldsEnteredForTextField:textField];
}

@end
