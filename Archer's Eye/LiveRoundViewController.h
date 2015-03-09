//
//  LiveRoundViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LiveRoundViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak AppDelegate *_appDelegate;
}

@property (nonatomic, weak) AppDelegate *appDelegate;

@end
