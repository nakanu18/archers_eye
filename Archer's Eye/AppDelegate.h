//
//  AppDelegate.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "ArchersEyeInfo.h"
#import "CorePlot-CocoaTouch.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    
}

@property (nonatomic, strong) UIWindow       *window;
@property (nonatomic, strong) ArchersEyeInfo *archersEyeInfo;
@property (nonatomic, strong) NSURL          *url;





+ (NSString *)basicDate:(NSDate *)date;
+ (NSString *)shortDate:(NSDate *)date;
+ (NSString *)shortDateAndTime:(NSDate *)date;
- (void)loadData;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

