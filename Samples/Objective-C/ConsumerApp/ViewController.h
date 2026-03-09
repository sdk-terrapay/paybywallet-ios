//
//  ViewController.h
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//
#import <UIKit/UIKit.h>

@class TPMerchantModel;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblNameCustomer;
@property (weak, nonatomic) IBOutlet UILabel *lblNameShort;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNum;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;

@property (nonatomic, strong) NSString *subscriberName;
@property (nonatomic, strong) NSString *msisdn;
@property (nonatomic, strong) NSString *dialCode;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *countryName;
+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
