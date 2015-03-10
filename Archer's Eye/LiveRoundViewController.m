//
//  LiveRoundViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "LiveRoundViewController.h"

@interface LiveRoundViewController ()

@end

@implementation LiveRoundViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [self setAppDelegate:(AppDelegate *)[UIApplication sharedApplication].delegate];
    
    [_appDelegate startLiveRound];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





















#pragma mark - Table view data source

//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_appDelegate liveRound] numEnds];
}



//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EndCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"LiveEndCell"];
    int      numArrowsPerEnd = [[_appDelegate liveRound] numArrowsPerEnd];
    
    [[cell endNumLabel]     setText:[NSString stringWithFormat:@"%ld:", (long)indexPath.row + 1]];
    
    // Initialize the arrow scores
    for( int i = 0; i < [[cell arrowLabels] count]; ++i )
    {
        [self setVisualScore:-1 forLabel:[[cell arrowLabels] objectAtIndex:i]];
    }
    
    [[cell endScoreLabel]   setText:[NSString stringWithFormat:@"0"]];
    [[cell totalScoreLabel] setText:[NSString stringWithFormat:@"0"]];
    
    if( indexPath.row == _currEndID )
        [[[cell arrowLabels] objectAtIndex:_currArrowID] setBackgroundColor:[UIColor greenColor]];

    // Hide any slots we're not using
    if( numArrowsPerEnd < 1 )       [[cell arrow0Label] setHidden:YES];
    if( numArrowsPerEnd < 2 )       [[cell arrow1Label] setHidden:YES];
    if( numArrowsPerEnd < 3 )       [[cell arrow2Label] setHidden:YES];
    if( numArrowsPerEnd < 4 )       [[cell arrow3Label] setHidden:YES];
    if( numArrowsPerEnd < 5 )       [[cell arrow4Label] setHidden:YES];
    if( numArrowsPerEnd < 6 )       [[cell arrow5Label] setHidden:YES];
    
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
- (EndCell *)getCurrEndCell
{
    return (EndCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currEndID inSection:0]];
}



//------------------------------------------------------------------------------
- (UILabel *)getCurrArrowLabel
{
    UILabel *label = nil;
    EndCell *cell  = [self getCurrEndCell];
    
    label = [[cell arrowLabels] objectAtIndex:_currArrowID];
    
    return label;
}



//------------------------------------------------------------------------------
- (void)setCurrEndID:(int)currEndID andCurrArrowID:(int)currArrowID
{
    // Get the score of the currently selected slot
    int      score = [[_appDelegate liveRound] getScoreForEnd:_currEndID andArrow:_currArrowID];
    EndCell *cell  = [self getCurrEndCell];
    UILabel *label = [[cell arrowLabels] objectAtIndex:_currArrowID];
    
    // Visually reset the old slot
    [self setVisualScore:score forLabel:label];
    
    // Highlight the new slot
    _currEndID   = currEndID;
    _currArrowID = currArrowID;
    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
}



//------------------------------------------------------------------------------
- (void)incArrowID
{
    int numEnds         = [[_appDelegate liveRound] numEnds];
    int numArrowsPerEnd = [[_appDelegate liveRound] numArrowsPerEnd];

    if( _currEndID < numEnds )
    {
        if( _currArrowID + 1 >= numArrowsPerEnd )
        {
            if( _currEndID + 1 <= numEnds )
            {
                _currArrowID  = 0;
                _currEndID   += 1;
            }
        }
        else
            _currArrowID += 1;
    }

    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
}



//------------------------------------------------------------------------------
- (void)decArrowID
{
//    int numEnds         = [[_appDelegate liveRound] numEnds];
    int numArrowsPerEnd = [[_appDelegate liveRound] numArrowsPerEnd];
    
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
    
    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
}



//------------------------------------------------------------------------------
- (void)setScoreForCurrArrow:(int)score
{
    EndCell *cell  = [self getCurrEndCell];
    UILabel *label = [[cell arrowLabels] objectAtIndex:_currArrowID];

    // Set the score in the data
    [[_appDelegate liveRound] setScore:score forEnd:_currEndID andArrow:_currArrowID];
    
    // Visually set the score
    [self setVisualScore:score forLabel:label];
    [self updateTotalScores];
    
    [self incArrowID];
}



//------------------------------------------------------------------------------
- (void)setVisualScore:(int)score forLabel:(UILabel *)label
{
    if( score >= 0 )
        [label setText:[NSString stringWithFormat:@"%d", score]];
    else
        [label setText:@"?"];
    
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
        [label setBackgroundColor:[UIColor grayColor]];
}



//------------------------------------------------------------------------------
- (void)eraseScoreForCurrArrow
{
    [self decArrowID];

    EndCell *cell  = [self getCurrEndCell];
    UILabel *label = [[cell arrowLabels] objectAtIndex:_currArrowID];
    
    // Set the score in the data
    [[_appDelegate liveRound] setScore:-1 forEnd:_currEndID andArrow:_currArrowID];
    
    // Visually set the score
    [self setVisualScore:-1 forLabel:label];
    [[self getCurrArrowLabel] setBackgroundColor:[UIColor greenColor]];
    
    [self updateTotalScores];
}



//------------------------------------------------------------------------------
- (void)updateTotalScores
{
    EndCell *cell       = [self getCurrEndCell];
    int      endScore   = [[_appDelegate liveRound] getScoreForEnd:_currEndID];
    int      totalScore = [[_appDelegate liveRound] getTotalScoreUpToEnd:_currEndID];
    
    [[cell endScoreLabel]   setText:[NSString stringWithFormat:@"%d", endScore]];
    [[cell totalScoreLabel] setText:[NSString stringWithFormat:@"%d", totalScore]];
    
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
- (IBAction)doneButtonPressed:(id)sender
{
    
}

@end
