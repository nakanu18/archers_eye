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
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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
        [_bowType setTitle:[BowInfo typeAsString:i] forSegmentAtIndex:i];
    }
    
    // Create a new Bow if we don't have a currently selected one
    if( [_appDelegate currBow] == nil )
        [_appDelegate createNewCurrBow:[BowInfo new]];

    // Populate the fields with it's data
    _bowName.text                   = _appDelegate.currBow.name;
    _bowDrawWeight.text             = [NSString stringWithFormat:@"%ld", _appDelegate.currBow.drawWeight];
    _bowSight.on                    = _appDelegate.currBow.sight;
    _bowClicker.on                  = _appDelegate.currBow.clicker;
    _bowStabilizers.on              = _appDelegate.currBow.stabilizers;
    _bowType.selectedSegmentIndex   = _appDelegate.currBow.type;
    
    [self toggleSaveButtonIfReady];
    [self addToolbarToNumberPad:_bowDrawWeight];
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
    
    if( textField == _bowName )         _appDelegate.currBow.name       =  textField.text;
    if( textField == _bowDrawWeight )   _appDelegate.currBow.drawWeight = [textField.text integerValue];

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
- (IBAction)bowTypeChanged:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    
    _appDelegate.currBow.type = (eBowType)seg.selectedSegmentIndex;

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}





















#pragma mark - Switches

//------------------------------------------------------------------------------
- (IBAction)bowSightSwitched:(id)sender
{
    _appDelegate.currBow.sight = [sender isOn];

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}



//------------------------------------------------------------------------------
- (IBAction)bowClickerSwitched:(id)sender
{
    _appDelegate.currBow.clicker = [sender isOn];

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}



//------------------------------------------------------------------------------
- (IBAction)bowStabilizersSwitched:(id)sender
{
    _appDelegate.currBow.stabilizers = [sender isOn];

    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}






















#pragma mark - Buttons

//------------------------------------------------------------------------------
- (void)toggleSaveButtonIfReady
{
    _barButtonSave.enabled = [_appDelegate.currBow isInfoValid];
}



//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    [_appDelegate discardCurrBow];
    
    // Programmatically run the unwind segue.
    [self performSegueWithIdentifier:@"unwindToBowsView" sender:self];
}




//------------------------------------------------------------------------------
- (IBAction)save:(id)sender
{
    if( _activeTextField != nil )
        [self textFieldShouldReturn:_activeTextField];
    
    [_appDelegate saveCurrBow];

    // Programmatically run the unwind segue.
    [self performSegueWithIdentifier:@"unwindToBowsView" sender:self];
}

@end
