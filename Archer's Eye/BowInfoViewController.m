//
//  BowInfoViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "BowInfoViewController.h"
#import "BowInfo.h"

@interface BowInfoViewController ()

@end



@implementation BowInfoViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo = self.appDelegate.archersEyeInfo;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NOTE: This is the fix some weirdness with the top offset of scrollview.
    // Without this set, if the top of the scrollview is flush with the nav bar,
    // the scrollview will actually be moved down by the size of the nav bar
    //
    // Commented out because there is a setting in InterfaceBuilder.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Make sure the segmented control has the proper names
    for( int i = 0; i < eBowType_Count; ++i )
    {
        [_segControlBowType setTitle:[BowInfo typeAsString:i] forSegmentAtIndex:i];
    }
    
    // Create a new Bow if we don't have a currently selected one
    if( [self.archersEyeInfo currBow] == nil )
        [self.archersEyeInfo createNewCurrBow:[BowInfo new]];

    // Populate the fields with it's data
    _textBowName.text                       = self.archersEyeInfo.currBow.name;
    _switchBowSight.on                      = self.archersEyeInfo.currBow.sight;
    _switchBowClicker.on                    = self.archersEyeInfo.currBow.clicker;
    _switchBowStabilizers.on                = self.archersEyeInfo.currBow.stabilizers;
    _segControlBowType.selectedSegmentIndex = self.archersEyeInfo.currBow.type;
    
    _labelBowDrawWeight.text                = [NSString stringWithFormat:@"%ld", self.archersEyeInfo.currBow.drawWeight];
    _sliderBowDrawWeight.value              = self.archersEyeInfo.currBow.drawWeight;
    _stepperBowDrawWeight.value             = _sliderBowDrawWeight.value;
    _stepperBowDrawWeight.minimumValue      = _sliderBowDrawWeight.minimumValue;
    _stepperBowDrawWeight.maximumValue      = _sliderBowDrawWeight.maximumValue;
    
    
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
    
    if( textField == _textBowName )
        self.archersEyeInfo.currBow.name = textField.text;

    [self toggleSaveButtonIfReady];
}



//------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL ans = [super textFieldShouldReturn:textField];
    
    return ans;
}











































#pragma mark - Bow Values Changed

//------------------------------------------------------------------------------
- (IBAction)bowDrawWeightChanged:(id)sender
{
    NSInteger value = 0;
    
    if( [sender isKindOfClass:[UISlider class]] )
        value = [(UISlider *)sender value];
    else if( [sender isKindOfClass:[UIStepper class]] )
        value = [(UIStepper *)sender value];
    
    _labelBowDrawWeight.text        = [NSString stringWithFormat:@"%ld", value];
    self.archersEyeInfo.currBow.drawWeight = value;
    
    // Resync the values of the slider and stepper
    if( [sender isKindOfClass:[UISlider class]] )
        _stepperBowDrawWeight.value = _sliderBowDrawWeight.value;
    else if( [sender isKindOfClass:[UIStepper class]] )
        _sliderBowDrawWeight.value = _stepperBowDrawWeight.value;

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}



//------------------------------------------------------------------------------
- (IBAction)bowTypeChanged:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    
    self.archersEyeInfo.currBow.type = (eBowType)seg.selectedSegmentIndex;
    
    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}



//------------------------------------------------------------------------------
- (IBAction)bowSightSwitched:(id)sender
{
    self.archersEyeInfo.currBow.sight = [sender isOn];

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}



//------------------------------------------------------------------------------
- (IBAction)bowClickerSwitched:(id)sender
{
    self.archersEyeInfo.currBow.clicker = [sender isOn];

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}



//------------------------------------------------------------------------------
- (IBAction)bowStabilizersSwitched:(id)sender
{
    self.archersEyeInfo.currBow.stabilizers = [sender isOn];

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}






















#pragma mark - Buttons

//------------------------------------------------------------------------------
- (void)toggleSaveButtonIfReady
{
    _barButtonSave.enabled = [self.archersEyeInfo.currBow isInfoValid];
}



//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    [self.archersEyeInfo discardCurrBow];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




//------------------------------------------------------------------------------
- (IBAction)save:(id)sender
{
    if( _activeTextField != nil )
        [self textFieldShouldReturn:_activeTextField];
    
    [self.archersEyeInfo saveCurrBow];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
