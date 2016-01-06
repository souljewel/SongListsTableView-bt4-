//
//  AppDelegate.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/9/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "AppDelegate.h"
#import "MyMediaPlayerViewController.h"
#import "MyAnimationHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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

// -------------------------------------------------------------------------------
//	handleError:error
//  Reports any error with an alert which was received from connection or loading failures.
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    
    // alert user that our current record was deleted, and then we leave this view controller
    //
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Show Categories"
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         // dissmissal of alert completed
                                                     }];
    
    [alert addAction:OKAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - MediaPlayer

- (void) showMediaPlayerViewWithAnimation{
    if(_navigationMediaPlayerViewController == nil){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.navigationMediaPlayerViewController = [storyboard instantiateViewControllerWithIdentifier:@"navigationPlayMusicVC"];
    }
    
    [self.window.rootViewController addChildViewController:_navigationMediaPlayerViewController];
    [self.window.rootViewController.view addSubview:_navigationMediaPlayerViewController.view];
    [[MyAnimationHelper shareInstanced] slideDown:UIViewAnimationOptionCurveEaseInOut view:self.navigationMediaPlayerViewController.view seconds:0.8f];
//    [[MyAnimationHelper shareInstanced] fadeInAnimation:self.window.rootViewController.view];
}
































@end
