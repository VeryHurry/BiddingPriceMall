//
//  AppDelegate.m
//  BiddingPriceMall
//
//  Created by mac on 2019/9/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "SQTabbarViewController.h"
#import "SQGuideViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    if (![kUserDefaults objectForKey:@"isFirst"]) {
        SQGuideViewController *vc = [[SQGuideViewController alloc]init];
        [vc showGuideViewWithImageArray:@[@"guide_image1",@"guide_image2",@"guide_image3"] WindowRootController:[SQTabbarViewController new]];
        self.window.rootViewController = vc;
    }
    else
    {
        SQTabbarViewController * vc = [[SQTabbarViewController alloc]init];
        self.window.rootViewController = vc;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

