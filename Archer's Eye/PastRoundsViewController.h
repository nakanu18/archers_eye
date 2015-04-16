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

typedef enum
{
    ePastRoundEx_Average,
    ePastRoundEx_Bullseyes,
    ePastRoundEx_BowName,
    ePastRoundEx_Count,
} ePastRoundEx;

@interface PastRoundsViewController : UITableViewController <RoundEditorViewControllerDelegate>
{
}

@property (nonatomic, weak)              AppDelegate     *appDelegate;
@property (nonatomic, weak)              ArchersEyeInfo  *archersEyeInfo;
@property (nonatomic, strong)            NSMutableArray  *groupedRounds;
@property (nonatomic, weak)     IBOutlet UIBarButtonItem *showXsButton;
@property (nonatomic, readwrite)         ePastRoundEx     roundExInfo;






- (IBAction)showX:(id)sender;
- (IBAction)unwindToPastRounds:(UIStoryboardSegue *)segue;

@end
