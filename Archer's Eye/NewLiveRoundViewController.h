//
//  NewLiveRoundViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/15/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

typedef enum
{
    eNewLiveRoundSectionType_Live,
    eNewLiveRoundSectionType_Custom,
    eNewLiveRoundSectionType_Common,
} eNewLiveRoundSectionType;

@interface NewLiveRoundViewController : UITableViewController
{
}

@property (nonatomic, weak)    AppDelegate     *appDelegate;
@property (nonatomic, weak)    ArchersEyeInfo  *archersEyeInfo;
@property (nonatomic, strong)  NSMutableArray  *sectionTypes;






- (IBAction)unwindToNewLiveRound:(UIStoryboardSegue *)segue;

@end
