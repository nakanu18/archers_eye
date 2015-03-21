//
//  DismissSegue.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

//------------------------------------------------------------------------------
- (void)perform
{
    UIViewController *source = self.sourceViewController;
    
    [source.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
