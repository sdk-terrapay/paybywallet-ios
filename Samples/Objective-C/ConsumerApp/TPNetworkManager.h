//
//  TPNetworkManager.h
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPNetworkStatus) {
    TPNetworkStatusSatisfied = 0,
    TPNetworkStatusUnsatisfied,
    TPNetworkStatusRequiresConnection
};

NS_ASSUME_NONNULL_BEGIN

@interface TPNetworkManager : NSObject

/// Singleton accessor
+ (instancetype)shared;

/// Global network status (mirrors Swift `static var`)
@property (class, atomic) TPNetworkStatus networkStatus;

/// Start monitoring network changes
- (void)initialize;

/// Show "No Internet" alert (or hook in your snackbar, etc.)
- (void)showNoInternetAlertWithParent:(UIViewController * _Nullable)parent;

@end

NS_ASSUME_NONNULL_END
