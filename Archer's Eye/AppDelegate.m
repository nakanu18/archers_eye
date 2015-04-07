//
//  AppDelegate.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



//------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.archersEyeInfo = [ArchersEyeInfo new];

    [self loadDataFromURL:[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey]];
    
    return YES;
}



//------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [self loadDataFromURL:url];
    
    return YES;
}



//------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the
    // application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}




//------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.

    [self.archersEyeInfo saveDataToDevice];
}




//------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive
    // state; here you can undo many of the changes made on entering the
    // background.
}




//------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}




//------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}





















#pragma mark - Misc

//------------------------------------------------------------------------------
+ (NSString *)basicDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.locale    = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    return [dateFormatter stringFromDate:date];
}



//------------------------------------------------------------------------------
// Tries to load data from the url.  If not, tries to load from the device.
//------------------------------------------------------------------------------
- (void)loadDataFromURL:(NSURL *)url
{
    if( url != nil  &&  [url isFileURL] )
    {
        NSData *zippedData = [NSData dataWithContentsOfURL:url];
        
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        [self.archersEyeInfo loadDataFromJSONData:zippedData];
    }
    else
        [self.archersEyeInfo loadDataFromDevice];
    
}

@end
