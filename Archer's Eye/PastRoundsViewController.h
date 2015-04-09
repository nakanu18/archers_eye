//
//  PastScoresViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RoundEditorViewController.h"

@interface PastRoundsViewController : UITableViewController <RoundEditorViewControllerDelegate>
{
    BOOL _showXs;
}

@property (nonatomic, weak)              AppDelegate     *appDelegate;
@property (nonatomic, weak)              ArchersEyeInfo  *archersEyeInfo;
@property (nonatomic, strong)            NSMutableArray  *groupedRounds;
@property (nonatomic, weak)     IBOutlet UIBarButtonItem *showXsButton;






- (IBAction)showX:(id)sender;
- (IBAction)unwindToPastRounds:(UIStoryboardSegue *)segue;

@end
