//
//  ChooseRoundViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/9/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ChooseRoundViewController : UITableViewController
{
    
}

@property (nonatomic, weak)    AppDelegate     *appDelegate;
@property (nonatomic, weak)    ArchersEyeInfo  *archersEyeInfo;
@property (nonatomic, strong)  NSMutableArray  *groupedRounds;






- (IBAction)cancel:(id)sender;

@end
