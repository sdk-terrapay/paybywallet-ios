//
//  TPOTPTextField.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//


#import "TPOTPTextField.h"

@implementation TPOTPTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Any additional setup if needed
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Any additional setup if needed
    }
    return self;
}

- (void)initializeUI {
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textAlignment = NSTextAlignmentCenter;

    if (@available(iOS 12.0, *)) {
        self.textContentType = UITextContentTypeOneTimeCode;
    }
}

- (void)deleteBackward {
    [super deleteBackward];

    // Notify delegate same as Swift version
    if ([self.delegate respondsToSelector:
         @selector(textField:shouldChangeCharactersInRange:replacementString:)]) {

        [self.delegate textField:self
  shouldChangeCharactersInRange:NSMakeRange(0, 0)
              replacementString:@""];
    }
}

@end
