//
//  AppDelegate.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchersEyeInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (nonatomic, strong) UIWindow       *window;
@property (nonatomic, strong) ArchersEyeInfo *archersEyeInfo;






+ (NSString *)basicDate:(NSDate *)date;

@end

