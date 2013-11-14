//
//  YMAppDelegate.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/25/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMAppDelegate.h"
#import "YMAPIInterfaceCenter.h"

@implementation YMAppDelegate

@synthesize sharedSideBar = _sharedSideBar;
@synthesize delegateSharedSideBar = _delegateSharedSideBar;
@synthesize background = _background;

- (RNFrostedSidebar *)sharedSideBar
{
    if (!_sharedSideBar) {
        NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"info.png"], [UIImage imageNamed:@"form.png"], [UIImage imageNamed:@"purchases.png"], [UIImage imageNamed:@"forum.png"], nil];
        _sharedSideBar = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [images count])] borderColors:[NSArray arrayWithObjects:[UIColor whiteColor], [UIColor whiteColor], [UIColor whiteColor], [UIColor whiteColor], nil]];
        _sharedSideBar.width = 75;
        _sharedSideBar.itemSize = CGSizeMake(50, 50);
    }
    return _sharedSideBar;
}

- (RNFrostedSidebar *)delegateSharedSideBar
{
    if (!_delegateSharedSideBar) {
        NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"info.png"], [UIImage imageNamed:@"forum.png"], nil];
        _delegateSharedSideBar = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [images count])] borderColors:[NSArray arrayWithObjects:[UIColor whiteColor], [UIColor whiteColor], nil]];
        _delegateSharedSideBar.width = 75;
        _delegateSharedSideBar.itemSize = CGSizeMake(50, 50);
    }
    return _delegateSharedSideBar;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStack];
    [self.window makeKeyAndVisible];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        self.window.clipsToBounds = YES;
        self.background = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 20)];
        self.background.backgroundColor = [UIColor blackColor];
        [self.background setHidden:NO];
    }
    
    // For push notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert)];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"My token is: %@", token);
    [YMAPIInterfaceCenter postTokenToPushCenter:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

@end
