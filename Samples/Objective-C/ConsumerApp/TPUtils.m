//
//  TPUtils.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 09/03/26.
//

#import "TPUtils.h"
#import <UIKit/UIKit.h>

@implementation TPUtils

+ (UIViewController *)fetchVCWithBoardName:(NSString *)boardName identifier:(NSString *)identifier {
    if (boardName != nil && identifier != nil) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:boardName bundle:nil];
        UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:identifier];
        return viewController;
    }
    return nil;
}




+ (void)setUpAppConfigurations {
    // iOS 15+ UINavigationBar appearance
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor colorNamed:@"primaryAirtel"];
        appearance.shadowColor = [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorNamed:@"navigationLeft"]};
        
        UINavigationBar *navBarAppearance = [UINavigationBar appearance];
        navBarAppearance.standardAppearance = appearance;
        navBarAppearance.scrollEdgeAppearance = appearance;
        navBarAppearance.tintColor = [UIColor  colorNamed:@"navigationLeft"];
    } else {
        // Fallback for iOS <15
        UINavigationBar *navBarAppearance = [UINavigationBar appearance];
        navBarAppearance.tintColor = [UIColor  colorNamed:@"navigationLeft"];
        [navBarAppearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        navBarAppearance.shadowImage = [UIImage new];
        navBarAppearance.backgroundColor = [UIColor colorNamed:@"primaryAirtel"];
    }
}

@end
