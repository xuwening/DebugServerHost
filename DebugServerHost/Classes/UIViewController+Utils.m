
#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

+(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if ([vc isKindOfClass: [UINavigationController class]]) {
        return vc;
    }
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass: NSClassFromString(@"CMSlideRootViewController")]) {
        
        if ([vc respondsToSelector:@selector(currentViewController)]) {
            return [UIViewController findBestViewController: [vc performSelector:@selector(currentViewController)]];
        } else {
            return nil;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return nil;
        
    }
    
}

+(UIViewController*) currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *last = [UIViewController findBestViewController:viewController];
    if (last == nil) {
        return viewController;
    }
    
    return  last;
}

@end
