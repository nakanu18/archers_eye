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
        [_appDelegate createNewCustomRound:[[RoundInfo alloc] initWithName:@"" andType:eRoundType_NFAA andDist:20 andNumEnds:1 andArrowsPerEnd:6]];

    // Populate the fields with it's data
    _textName.text                              = _appDelegate.currRound.name;
    _segControlRoundType.selectedSegmentIndex   = _appDelegate.currRound.type;
    _textNumEnds.text                           = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.numEnds];
    _textNumArrows.text                         = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.numArrowsPerEnd];
    _textDefaultDist.text                       = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.distance];

    [self toggleSaveButtonIfReady];
    [self addToolbarToNumberPad:_textNumEnds];
    [self addToolbarToNumberPad:_textNumArrows];
    [self addToolbarToNumberPad:_textDefaultDist];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






















#pragma - mark BowName (UITextField)

//------------------------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    
    _barButtonSave.enabled = NO;
}



//------------------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
    if( textField == _textName )        _appDelegate.currRound.name             =  textField.text;
    if( textField == _textNumEnds )     _appDelegate.currRound.numEnds          = [textField.text integerValue];
    if( textField == _textNumArrows )   _appDelegate.currRound.numArrowsPerEnd  = [textField.text integerValue];
    if( textField == _textDefaultDist ) _appDelegate.currRound.distance      = [textField.text integerValue];
    
    [self toggleSaveButtonIfReady];
}



//------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL ans = [super textFieldShouldReturn:textField];
    
    return ans;
}























#pragma mark - BowType (UISegmentedControl)

//------------------------------------------------------------------------------
- (IBAction)targetTypeChanged:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    
    _appDelegate.currRound.type = (eRoundType)seg.selectedSegmentIndex;
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
