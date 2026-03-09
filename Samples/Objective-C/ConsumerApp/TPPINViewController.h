//
//  TPPINViewController.h
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//

#import <UIKit/UIKit.h>

@class TPMerchantModel;
@class TPOTPFieldView;

NS_ASSUME_NONNULL_BEGIN

@interface TPPINViewController : UIViewController

    @property (weak, nonatomic) IBOutlet UILabel *lblMerchantName;
    @property (weak, nonatomic) IBOutlet UILabel *lblAmount;
    @property (weak, nonatomic) IBOutlet UIView *viewSender;
    @property (weak, nonatomic) IBOutlet UIView *viewKeyBoard;
    @property (weak, nonatomic) IBOutlet TPOTPFieldView *pinFieldView;
    @property (weak, nonatomic) IBOutlet UIImageView *imgDelete;
    @property (weak, nonatomic) IBOutlet UIImageView *imgProceed;
    @property (weak, nonatomic) IBOutlet UIView *viewWarning;

// Connect all 0–9 keypad buttons to this outlet collection in Interface Builder.
// Make sure each button has tag set to the intended digit (0–9).
    @property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *keyPadButtons;

    @property (class, nonatomic, readonly) NSString *identifier;

// Set by the presenting controller before showing this screen
    @property (strong, nonatomic, nullable) TPMerchantModel *merchantInfo;

@end

NS_ASSUME_NONNULL_END
