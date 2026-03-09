//
//  NSString.h
//  ConsumerApp
//
//  Created by Sunku Sneha on 09/03/26.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TPSize)

- (CGSize)tp_sizeForViewWithFont:(UIFont *)font width:(CGFloat)width height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
