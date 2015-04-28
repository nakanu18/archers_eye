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
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo = self.appDelegate.archersEyeInfo;

    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Make sure the segmented control has the proper names
    for( int i = 0; i < eRoundType_Count; ++i )
    {
        [_segControlRoundType setTitle:[RoundInfo typeAsString:i] forSegmentAtIndex:i];
    }
    
    // Create a new Round if we don't have a currently selected one
    if( [self.archersEyeInfo currRound] == nil )
        [self.archersEyeInfo createNewCustomRound:[[RoundInfo alloc] initWithName:@"NewRound"
                                                                          andType:eRoundType_NFAA
                                                                          andDist:20
                                                                       andNumEnds:1
                                                                  andArrowsPerEnd:6
                                                                 andXPlusOnePoint:NO]];

    // Populate the fields with it's data
    _textName.text                              = self.archersEyeInfo.currRound.name;
    _segControlRoundType.selectedSegmentIndex   = self.archersEyeInfo.currRound.type;

    _textNumEnds.text                           = [NSString stringWithFormat:@"%ld", (long)self.archersEyeInfo.currRound.numEnds];
    _textNumArrows.text                         = [NSString stringWithFormat:@"%ld", (long)self.archersEyeInfo.currRound.numArrowsPerEnd];
    _textDistance.text                          = [NSString stringWithFormat:@"%ld", (long)self.archersEyeInfo.currRound.distance];
    _switchXExtraPoint.on                       = self.archersEyeInfo.currRound.xPlusOnePoint;

    [self toggleSaveButtonIfReady];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}























#pragma mark - Table view data source

//------------------------------------------------------------------------------
-               (CGFloat)tableView:(UITableView *)tableView
  estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



//------------------------------------------------------------------------------
-       (CGFloat)tableView:(UITableView *)tableView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}






















#pragma - mark BowName (UITextField)

//------------------------------------------------------------------------------
// Text editting started.
//
// Show a UIAlertView with TextField and correct descs.
//------------------------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSArray     *title  = @[@"Name",
                            @"Number of Ends",
                            @"Number of Arrows",
                            @"Distance"];
    NSArray     *desc   = @[@"Tip: Rounds are sorted by first name",
                            @"Enter the number of ends [1-40]",
                            @"Enter the number of ends [1-6]",
                            @"Enter the distance [>0]"];
    NSArray     *fields = @[_textName, _textNumEnds, _textNumArrows, _textDistance];
    NSUInteger   ID     = [fields indexOfObject:textField];
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:title[ID]
                                                     message:desc[ID]
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Save", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if( textField == self.textName )
        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
    else
        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    
     self.textActive = textField;
    [self.textActive endEditing:YES];
    [alert textFieldAtIndex:0].text = self.textActive.text;
    [alert show];
//    [[alert textFieldAtIndex:0] selectAll:nil];       // Doesn't work?????
    
    _barButtonSave.enabled = NO;
}



//------------------------------------------------------------------------------
// Text editting ended.
//------------------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}



//------------------------------------------------------------------------------
// Text editting should return.
//------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
























#pragma mark - Buttons

//------------------------------------------------------------------------------
- (void)toggleSaveButtonIfReady
{
    _barButtonSave.enabled = [self.archersEyeInfo.currRound isInfoValid];
}



//------------------------------------------------------------------------------
- (IBAction)xExtraPointChanged:(id)sender
{
    UISwitch *switcher = (UISwitch *)sender;
    
    self.archersEyeInfo.currRound.xPlusOnePoint = switcher.on;
}





















#pragma mark - UIAlertView

//------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Save clicked
    if( buttonIndex == 1 )
    {
        self.textActive.text = [alertView textFieldAtIndex:0].text;
        
        if( self.textActive == self.textName )
            self.archersEyeInfo.currRound.name = self.textActive.text;
        else
        {
            NSInteger num = [self.textActive.text integerValue];
            
            if( self.textActive == self.textNumEnds )
            {
                self.archersEyeInfo.currRound.numEnds = MAX(MIN(num, 40), 1);
                self.textActive.text = [@(self.archersEyeInfo.currRound.numEnds) stringValue];
            }
            else if( self.textActive == self.textNumArrows )
            {
                self.archersEyeInfo.currRound.numArrowsPerEnd = MAX(MIN(num, 6), 1);
                self.textActive.text = [@(self.archersEyeInfo.currRound.numArrowsPerEnd) stringValue];
            }
            else if( self.textActive == self.textDistance )
            {
                self.archersEyeInfo.currRound.distance = MAX(num, 0);
                self.textActive.text = [@(self.archersEyeInfo.currRound.distance) stringValue];
            }
        }
    }

     self.textActive = nil;
    [self.textActive resignFirstResponder];
    [self toggleSaveButtonIfReady];
}
























//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    [self.archersEyeInfo endCurrRoundAndDiscard];
 
    [self dismissViewControllerAnimated:YES completion:nil];
}



//------------------------------------------------------------------------------
- (IBAction)save:(id)sender
{
    [self.archersEyeInfo endCurrRoundAndSave];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
