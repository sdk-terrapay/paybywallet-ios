#import <UIKit/UIKit.h>
//
//  TPUtils.h
//  ConsumerApp
//
//  Created by Sunku Sneha on 09/03/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPUtils : NSObject

+ (UIViewController *)fetchVCWithBoardName:(NSString *)boardName identifier:(NSString *)identifier;
+ (void)setUpAppConfigurations;
@end

NS_ASSUME_NONNULL_END

