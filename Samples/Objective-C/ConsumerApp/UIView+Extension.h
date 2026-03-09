//
//  View.h
//  ConsumerApp
//
//  Created by Sunku Sneha on 09/03/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)
- (void)tp_roundCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)tp_setRadiusWithShadow;
@end

NS_ASSUME_NONNULL_END
