//
//  ChooseDistanceViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/18/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "RoundInfoViewController.h"

@interface RoundInfoViewController ()

@end



@implementation RoundInfoViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Make sure the segmented control has the proper names
    for( int i = 0; i < eRoundType_Count; ++i )
    {
        [_segControlRoundType setTitle:[RoundInfo typeAsString:i] forSegmentAtIndex:i];
    }
    
    // Create a new Round if we don't have a currently selected one
    if( [_appDelegate currRound] == nil )
        [_appDelegate createNewCustomRound:[RoundInfo new]];

    // Populate the fields with it's data
    _textName.text                              = _appDelegate.currRound.name;
    _segControlRoundType.selectedSegmentIndex   = _appDelegate.currRound.type;
    _textNumEnds.text                           = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.numEnds];
    _textNumArrows.text                         = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.numArrowsPerEnd];
    _textDefaultDistance.text                   = [NSString stringWithFormat:@"%d", 123];

    [self toggleSaveButtonIfReady];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
























#pragma mark - Buttons

//------------------------------------------------------------------------------
- (void)toggleSaveButtonIfReady
{
    _barButtonSave.enabled = [_appDelegate.currRound isInfoValid];
}



//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    [_appDelegate endCurrRoundAndDiscard];
    
    [self performSegueWithIdentifier:@"unwindToNewLiveRound" sender:self];
}



//------------------------------------------------------------------------------
- (IBAction)save:(id)sender
{
    [_appDelegate endCurrRoundAndSave];

    [self performSegueWithIdentifier:@"unwindToNewLiveRound" sender:self];
}

@end
