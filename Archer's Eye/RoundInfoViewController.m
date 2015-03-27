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
    _labelNumEnds.text                          = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.numEnds];
    _sliderNumEnds.value                        = _appDelegate.currRound.numEnds;
    _labelNumArrows.text                        = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.numArrowsPerEnd];
    _sliderNumArrows.value                      = _appDelegate.currRound.numArrowsPerEnd;
    _labelDefaultDist.text                      = [NSString stringWithFormat:@"%ld", _appDelegate.currRound.distance];
    _sliderDefaultDist.value                    = _appDelegate.currRound.distance;

    [self toggleSaveButtonIfReady];
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
    
    if( textField == _textName )
        _appDelegate.currRound.name = textField.text;

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

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}
























#pragma mark - Buttons

//------------------------------------------------------------------------------
- (void)toggleSaveButtonIfReady
{
    _barButtonSave.enabled = [_appDelegate.currRound isInfoValid];
}



//------------------------------------------------------------------------------
- (IBAction)numEndsChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger value  = (NSInteger)slider.value;
    
    _labelNumEnds.text              = [NSString stringWithFormat:@"%ld", value];
    _appDelegate.currRound.numEnds  = value;
}



//------------------------------------------------------------------------------
- (IBAction)numArrowsChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger value  = (NSInteger)slider.value;
    
    _labelNumArrows.text                    = [NSString stringWithFormat:@"%ld", value];
    _appDelegate.currRound.numArrowsPerEnd  = value;
}



//------------------------------------------------------------------------------
- (IBAction)defaultDistChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSInteger value  = (NSInteger)slider.value;
    
    _labelDefaultDist.text          = [NSString stringWithFormat:@"%ld", value];
    _appDelegate.currRound.distance = value;
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
