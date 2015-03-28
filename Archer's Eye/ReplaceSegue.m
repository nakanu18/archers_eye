//
//  ReplaceSegue.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/27/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "ReplaceSegue.h"

@implementation ReplaceSegue

//------------------------------------------------------------------------------
- (void)perform
{
    UIViewController *dest   = (UIViewController *) self.destinationViewController;
    UIWindow         *window = [UIApplication sharedApplication].keyWindow;
    
    window.rootViewController = dest;
}

@end
