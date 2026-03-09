//
//  TPNetworkManager.m
//  ConsumerApp
//
//  Created by Sunku Sneha on 05/03/26.
//

#import "TPNetworkManager.h"
#import <Network/Network.h>

@interface TPNetworkManager () {
    nw_path_monitor_t _monitor;              // C handle (not an Obj‑C object)
    dispatch_queue_t _monitorQueue;
}
@end

@implementation TPNetworkManager

static TPNetworkStatus _tp_networkStatus = TPNetworkStatusUnsatisfied;

+ (instancetype)shared {
    static TPNetworkManager *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[TPNetworkManager alloc] init];
    });
    return inst;
}

+ (TPNetworkStatus)networkStatus {
    @synchronized (self) { return _tp_networkStatus; }
}

+ (void)setNetworkStatus:(TPNetworkStatus)status {
    @synchronized (self) { _tp_networkStatus = status; }
}

- (void)initialize {
    if (_monitor) { return; } // already started

    if (@available(iOS 12.0, *)) {
        _monitor = nw_path_monitor_create(); // retain the monitor handle
        _monitorQueue = dispatch_queue_create("com.yourorg.tp.monitor", DISPATCH_QUEUE_SERIAL);

        __weak typeof(self) weakSelf = self;
        nw_path_monitor_set_queue(_monitor, _monitorQueue);
        nw_path_monitor_set_update_handler(_monitor, ^(nw_path_t  _Nonnull path) {
            __strong typeof(weakSelf) self = weakSelf;
            if (!self) return;

            nw_path_status_t status = nw_path_get_status(path);
            switch (status) {
                case nw_path_status_satisfied:
                    TPNetworkManager.networkStatus = TPNetworkStatusSatisfied;
                    break;
                case nw_path_status_unsatisfied:
                    TPNetworkManager.networkStatus = TPNetworkStatusUnsatisfied;
                    break;
                default:
                    TPNetworkManager.networkStatus = TPNetworkStatusRequiresConnection;
                    break;
            }
        });

        nw_path_monitor_start(_monitor);
    } else {
        TPNetworkManager.networkStatus = TPNetworkStatusRequiresConnection;
    }
}

- (void)dealloc {
    if (_monitor) {
        nw_path_monitor_cancel(_monitor);
        _monitor = nil;
    }
}

- (void)showNoInternetAlertWithParent:(UIViewController * _Nullable)parent {
    if (!parent) return;

    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"No Internet"
                                        message:@"Please check your internet connection and try again!"
                                 preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [parent presentViewController:alert animated:YES completion:nil];

    // Or show your custom snackbar/toast here.
}

@end
