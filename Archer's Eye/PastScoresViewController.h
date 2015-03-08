//
//  PastScoresViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PastScoresViewController : UITableViewController
{
    __weak AppDelegate *_appDelegate;
}

@property (nonatomic, weak) AppDelegate *appDelegate;

@end
