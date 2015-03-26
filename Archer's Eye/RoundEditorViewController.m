//
//  LiveRoundViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "RoundEditorViewController.h"

@interface RoundEditorViewController ()

@end



@implementation RoundEditorViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.currRound      = (_appDelegate.currRound != nil) ? _appDelegate.currRound : _appDelegate.liveRound;
    _doneButton.enabled = NO;
    
    CGPoint currEmpty = [_currRound getCurrEndAndArrow];
    _currEndID   = currEmpty.y;
    _currArrowID = currEmpty.x;
    
    // Remove the cancel button if it's the live round
    if( _appDelegate.currRound == nil )
        self.navigationItem.leftBarButtonItem = nil;
    
    // Fix the erase/done button enabled states
    if( _currEndID >= [_currRound numEnds] )
    {
        _doneButton.enabled = YES;
    }
    
    // Enable the appropriate controls
    if( _currRound.type == eRoundType_FITA )
    {
        _controlsFITA.hidden    = NO;
        _controlsNFAA.hidden    = YES;
    }
    else if( _currRound.type == eRoundType_NFAA )
    {
        _controlsFITA.hidden    = YES;
        _controlsNFAA.hidden    = NO;
    }
}



//------------------------------------------------------------------------------
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Enable the appropriate controls
    if( _currRound.type == eRoundType_FITA )
    {
        [self.view removeConstraint:_constraintNFAA];
        [self.view addConstraint:_constraintFITA];
    }
    else if( _currRound.type == eRoundType_NFAA )
    {
        [self.view removeConstraint:_constraintFITA];
        [self.view addConstraint:_constraintNFAA];
    }
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






















#pragma mark - Table view data source

//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsNSIntegerableView:(UITableView *)tableView
{
    return 1;
}



//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currRound.numEnds;
}



//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EndCell     *cell       = [tableView dequeueReusableCellWithIdentifier:@"LiveEndCell"];
    RoundInfo   *liveRound  = _currRound;
    NSInteger    row        = indexPath.row;
    
    cell.endNumLabel.text = [NSString stringWithFormat:@"%ld:", row + 1];
    
    // Initialize the arrow scores
    for( NSInteger i = 0; i < liveRound.numArrowsPerEnd; ++i )
    {
        [self setVisualScore:[liveRound getScoreForEnd:row andArrow:i] forLabel:cell.arrowLabels[i]];
    }
    
    if( row > _currEndID )
    {
        cell.endScoreLabel.text     = @"0";
        cell.totalScoreLabel.text   = @"0";
    }
    else
    {
        cell.endScoreLabel.text     = [NSString stringWithFormat:@"%ld", [liveRound getRealScoreForEnd:row]];
        cell.totalScoreLabel.text   = [NSString stringWithFormat:@"%ld", [liveRound getRealTotalScoreUpToEnd:row]];
    }
    
    if( row == _currEndID )
        [cell.arrowLabels[_currArrowID] setBackgroundColor:[UIColor greenColor]];

    // Hide any slots we're not using
    if( liveRound.numArrowsPerEnd < 1 )       cell.arrow0Label.hidden = YES;
    if( liveRound.numArrowsPerEnd < 2 )       cell.arrow1Label.hidden = YES;
    if( liveRound.numArrowsPerEnd < 3 )       cell.arrow2Label.hidden = YES;
    if( liveRound.numArrowsPerEnd < 4 )       cell.arrow3Label.hidden = YES;
    if( liveRound.numArrowsPerEnd < 5 )       cell.arrow4Label.hidden = YES;
    if( liveRound.numArrowsPerEnd < 6 )       cell.arrow5Label.hidden = YES;
    
    return cell;
}



//------------------------------------------------------------------------------
-               (CGFloat)tableView:(UITableView *)tableView
  estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}



//------------------------------------------------------------------------------
-       (CGFloat)tableView:(UITableView *)tableView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}






















#pragma mark - Data handling methods


//------------------------------------------------------------------------------
// Returns the current end.
- (EndCell *)getCurrEndCell
{
    return (EndCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currEndID inSection:0]];
}



//------------------------------------------------------------------------------
// Returns the current arrow label for the current end.
- (UILabel *)getCurrArrowLabel
{
    UILabel *label = nil;
    EndCell *cell  = [self getCurrEndCell];
    
    label = cell.arrowLabels[_currArrowID];
    
    return label;
}



//------------------------------------------------------------------------------
// Sets the current arrow and end
- (void)setCurrEndID:(NSInteger)currEndID andCurrArrowID:(NSInteger)currArrowID
{
    // Get the score of the currently selected slot
    NSInteger    score = [_currRound getRealScoreForEnd:_currEndID andArrow:_currArrowID];
    EndCell     *cell  = [self getCurrEndCell];
    UILabel     *label = cell.arrowLabels[_currArrowID];
    
    // Visually reset the old slot
    [self setVisualScore:score forLabel:label];
    
    // Highlight the new slot
    _currEndID   = currEndID;
    _currArrowID = currArrowID;
    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
}



//------------------------------------------------------------------------------
// Increments to the next arrow.
- (void)incArrowID
{
    NSInteger numEnds         = _currRound.numEnds;
    NSInteger numArrowsPerEnd = _currRound.numArrowsPerEnd;

    if( _currEndID < numEnds )
    {
        if( _currArrowID + 1 >= numArrowsPerEnd )
        {
            if( _currEndID + 1 <= numEnds )
            {
                _currArrowID  = 0;
                _currEndID   += 1;
                
                if( _currEndID >= numEnds )
                    _doneButton.enabled = YES;
            }
        }
        else
            _currArrowID += 1;
    }

    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
}



//------------------------------------------------------------------------------
// Decrements to the previous arrow.
- (void)decArrowID
{
//    NSInteger numEnds         = _currRound.numEnds;
    NSInteger numArrowsPerEnd = _currRound.numArrowsPerEnd;
    
    [[self getCurrArrowLabel] setBackgroundColor:[UIColor grayColor]];
    
    if( _currArrowID - 1 < 0 )
    {
        _currArrowID  = numArrowsPerEnd - 1;
        _currEndID   -= 1;
        
        // Fix going beyond the beginning
        if( _currEndID < 0 )
        {
            _currArrowID = 0;
            _currEndID   = 0;
        }
    }
    else
        _currArrowID -= 1;
    
    _doneButton.enabled = NO;
    
    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
}



//------------------------------------------------------------------------------
// Sets the score for the current arrow.
- (void)setScoreForCurrArrow:(NSInteger)score
{
    EndCell *cell  = [self getCurrEndCell];
    UILabel *label = cell.arrowLabels[_currArrowID];

    // Set the score in the data
    [_currRound setScore:score forEnd:_currEndID andArrow:_currArrowID];
    
    // Visually set the score
    [self setVisualScore:score forLabel:label];
    [self updateTotalScores];
    
    [self incArrowID];
    
    // Make sure the currently selected arrow is in view
    if( _currEndID < _currRound.numEnds )
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_currEndID inSection:0];
        [_tableView scrollToRowAtIndexPath:path
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
    }
}



//------------------------------------------------------------------------------
// Changes the color of the current arrow according to the score.
- (void)setVisualScore:(NSInteger)score forLabel:(UILabel *)label
{
    if( score >= 11 )
        label.text = @"X";
    else if( score >= 0 )
        label.text = [NSString stringWithFormat:@"%ld", score];
    else
        label.text = @"?";
    
    if( _currRound.type == eRoundType_FITA )
    {
        if( score >= 9 )
            [label setBackgroundColor:[UIColor yellowColor]];
        else if( score >= 7 )
            [label setBackgroundColor:[UIColor redColor]];
        else if( score >= 5 )
            [label setBackgroundColor:[UIColor blueColor]];
        else if( score >= 3 )
            [label setBackgroundColor:[UIColor blackColor]];
        else if( score >= 0 )
            [label setBackgroundColor:[UIColor whiteColor]];
        else
            [label setBackgroundColor:[UIColor colorWithRed:200/256.0f green:200/256.0f blue:200/256.0f alpha:1.0f]];
    }
    else if( _currRound.type == eRoundType_NFAA )
    {
        if( score >= 5 )
            [label setBackgroundColor:[UIColor whiteColor]];
        else if( score >= 0 )
            [label setBackgroundColor:[UIColor colorWithRed:0 green:64/256.0f blue:128/256.0f alpha:1.0f]];
        else
            [label setBackgroundColor:[UIColor colorWithRed:200/256.0f green:200/256.0f blue:200/256.0f alpha:1.0f]];
    }
}



//------------------------------------------------------------------------------
// Nulls out the current arrow.
- (void)eraseScoreForCurrArrow
{
    EndCell *prevCell  = [self getCurrEndCell];

    [self decArrowID];

    EndCell *cell  = [self getCurrEndCell];
    UILabel *label = cell.arrowLabels[_currArrowID];
    
    // Handle the case where we jumped back one full end
    if( _currArrowID == _currRound.numArrowsPerEnd - 1 )
    {
        prevCell.totalScoreLabel.text = @"0";
    }
    
    // Set the score in the data
    [_currRound setScore:-1 forEnd:_currEndID andArrow:_currArrowID];
    
    // Visually set the score
    [self setVisualScore:-1 forLabel:label];
    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
    
    [self updateTotalScores];
    
    // Make sure the currently selected arrow is in view
    NSIndexPath *path = [NSIndexPath indexPathForRow:_currEndID inSection:0];
    [_tableView scrollToRowAtIndexPath:path
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
}



//------------------------------------------------------------------------------
// Updates the score totals for the current end.
- (void)updateTotalScores
{
    EndCell     *cell       = [self getCurrEndCell];
    NSInteger    endScore   = [_currRound getRealScoreForEnd:_currEndID];
    NSInteger    totalScore = [_currRound getRealTotalScoreUpToEnd:_currEndID];
    
    cell.endScoreLabel.text    = [NSString stringWithFormat:@"%ld", endScore];
    cell.totalScoreLabel.text  = [NSString stringWithFormat:@"%ld", totalScore];
}

















#pragma mark - Scoring buttons

//------------------------------------------------------------------------------
- (IBAction)scoreXButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:11];
}



//------------------------------------------------------------------------------
- (IBAction)score10ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:10];
}



//------------------------------------------------------------------------------
- (IBAction)score9ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:9];
}



//------------------------------------------------------------------------------
- (IBAction)score8ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:8];
}



//------------------------------------------------------------------------------
- (IBAction)score7ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:7];
}



//------------------------------------------------------------------------------
- (IBAction)score6ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:6];
}



//------------------------------------------------------------------------------
- (IBAction)score5ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:5];
}



//------------------------------------------------------------------------------
- (IBAction)score4ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:4];
}



//------------------------------------------------------------------------------
- (IBAction)score3ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:3];
}



//------------------------------------------------------------------------------
- (IBAction)score2ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:2];
}



//------------------------------------------------------------------------------
- (IBAction)score1ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:1];
}



//------------------------------------------------------------------------------
- (IBAction)score0ButtonPressed:(id)sender
{
    [self setScoreForCurrArrow:0];
}



//------------------------------------------------------------------------------

- (IBAction)eraseButtonPressed:(id)sender
{
    [self eraseScoreForCurrArrow];
}



//------------------------------------------------------------------------------
- (IBAction)cancelButtonPressed:(id)sender
{
    NSString *unwindSegueName;
    
    if( _appDelegate.currRound != nil )
    {
        [_appDelegate endCurrRoundAndDiscard];
        unwindSegueName = @"unwindToPastRounds";
    }
    else
    {
        [_appDelegate endLiveRoundAndDiscard];
        unwindSegueName = @"unwindToNewLiveRound";
    }
    
    [_tableView reloadData];
    
    // Programmatically run the unwind segue because we have to wait for the
    // AlertView.
    [self performSegueWithIdentifier:unwindSegueName sender:self];
}



//------------------------------------------------------------------------------
- (IBAction)saveButtonPressed:(id)sender
{
    UIAlertView *confirmDone = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Save now?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Save", nil];
    
    [confirmDone show];
}
























#pragma UIAlertView delegate methods

//------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 )
    {
        NSString *unwindSegueName;
        
        if( _appDelegate.currRound != nil )
        {
            [_appDelegate endCurrRoundAndSave];
            unwindSegueName = @"unwindToPastRounds";
        }
        else
        {
            [_appDelegate endLiveRoundAndSave];
            unwindSegueName = @"unwindToNewLiveRound";
        }
        
        [_tableView reloadData];
        
        // Programmatically run the unwind segue because we have to wait for the
        // AlertView.
        [self performSegueWithIdentifier:unwindSegueName sender:self];
    }
}

@end
