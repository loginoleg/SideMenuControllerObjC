//
//  AppDelegate.m
//  SideMenuControllerObjC
//
//  Created by Oleg Loginov on 2/10/15.
//  Copyright (c) 2015 Oleg Loginov. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideMenuController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)createMenuView {
    UIViewController *mainViewController = [UIViewController new];
    UIViewController *leftViewController = [UIViewController new];
    UIViewController *rightViewController = [UIViewController new];
    mainViewController.view.backgroundColor = [UIColor yellowColor];
    leftViewController.view.backgroundColor = [UIColor redColor];
    rightViewController.view.backgroundColor = [UIColor blueColor];

    UINavigationController *navViewcController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
//    [mainViewController addLeftBarButtonWithImage:[UIImage imageNamed:@"ic_menu_black_24dp"]];
//    [mainViewController addRightBarButtonWithImage:[UIImage imageNamed:@"ic_notifications_black_24dp"]];
//    [mainViewController.getSlideMenuController removeLeftGestures];
//    [mainViewController.getSlideMenuController removeRightGestures];
//    
    SlideMenuController *slideMenuController = [[SlideMenuController alloc] initWithMainViewController:navViewcController andLeftController:leftViewController andRightController:rightViewController];
    
    self.window.backgroundColor = [UIColor colorWithRed:236.0 green:238.0 blue:241.0 alpha:1.0];
    self.window.rootViewController = slideMenuController;
    [self.window makeKeyAndVisible];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self createMenuView];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
