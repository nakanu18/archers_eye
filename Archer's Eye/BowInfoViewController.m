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
    
    // Create a new Bow if we don't have a currently selected one
    if( [self.archersEyeInfo currBow] == nil )
        [self.archersEyeInfo createNewCurrBow:[BowInfo new]];

    // Populate the fields with it's data
    _textBowName.text           = self.archersEyeInfo.currBow.name;
    _textBowDrawWeight.text     = [@(self.archersEyeInfo.currBow.drawWeight) stringValue];
    _labelBowType.text          = [BowInfo typeAsString:self.archersEyeInfo.currBow.type];
    _switchBowClicker.on        = self.archersEyeInfo.currBow.clicker;
    _switchBowStabilizers.on    = self.archersEyeInfo.currBow.stabilizers;
    _labelAiming.text           = [BowInfo aimAsString:self.archersEyeInfo.currBow.aim];

    // Make certain rows unselectable
    for( NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i )
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if( i != 2  &&  i != 5 )
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self toggleSaveButtonIfReady];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController     *nav    = segue.destinationViewController;
    BowAccessoryViewController *bowAcc = (BowAccessoryViewController *)[nav topViewController];
    NSMutableArray             *array  = [NSMutableArray new];

    if( [segue.identifier isEqualToString:@"BowTypeSegue"] )
    {
        // Populate the array with bow types
        for( NSInteger i = 0; i < eBowType_Count; ++i )
        {
            [array addObject:[BowInfo typeAsString:(eBowType)i]];
        }
        bowAcc.title            = @"Bow Type";
        bowAcc.selectedNameID   = self.archersEyeInfo.currBow.type;
        bowAcc.ID               = 0;               // Identifier for bow property
    }
    else if( [segue.identifier isEqualToString:@"BowAimSegue"] )
    {
        // Populate the array with bow aim types
        for( NSInteger i = 0; i < eBowAim_Count; ++i )
        {
            [array addObject:[BowInfo aimAsString:(eBowAim)i]];
        }
        bowAcc.title            = @"Method of Aiming";
        bowAcc.selectedNameID   = self.archersEyeInfo.currBow.aim;
        bowAcc.ID               = 1;               // Identifier for bow property
    }
    bowAcc.delegate   = self;
    bowAcc.arrayNames = array;
}






















#pragma mark - Table view data source

//------------------------------------------------------------------------------
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 2  || indexPath.row == 5 )
        return indexPath;
    else
        return nil;
}



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
// Text editting did begin.
//------------------------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSArray     *title  = @[@"Name",
                            @"Draw Weight"];
    NSArray     *desc   = @[@"Choose a name for your bow",
                            @"Enter the draw weight [1-100]"];
    NSArray     *fields = @[_textBowName, _textBowDrawWeight];
    NSUInteger   ID     = [fields indexOfObject:textField];
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:title[ID]
                                                     message:desc[ID]
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Save", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if( textField == self.textBowName )
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











































#pragma mark - Bow Values Changed

//------------------------------------------------------------------------------
- (IBAction)bowClickerSwitched:(id)sender
{
    self.archersEyeInfo.currBow.clicker = [sender isOn];
}



//------------------------------------------------------------------------------
- (IBAction)bowStabilizersSwitched:(id)sender
{
    self.archersEyeInfo.currBow.stabilizers = [sender isOn];
}





















#pragma mark - UIAlertView

//------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Save clicked
    if( buttonIndex == 1 )
    {
        self.textActive.text = [alertView textFieldAtIndex:0].text;
        
        if( self.textActive == self.textBowName )
            self.archersEyeInfo.currBow.name = self.textActive.text;
        else if( self.textActive == self.textBowDrawWeight )
        {
            NSInteger num = [self.textActive.text integerValue];
            
            self.archersEyeInfo.currBow.drawWeight = MAX(MIN(num, 100), 1);
            self.textActive.text = [@(self.archersEyeInfo.currBow.drawWeight) stringValue];
        }
    }
    
     self.textActive = nil;
    [self.textActive resignFirstResponder];
    [self toggleSaveButtonIfReady];
}





















#pragma mark - BowAccessoryViewControllerDelegate

//------------------------------------------------------------------------------
// Receives a value for a bow accessory (either BowType or BowAim).
//------------------------------------------------------------------------------
- (void)setAccessoryForCurrentBow:(NSInteger)accessoryID forID:(NSInteger)ID
{
    // BowType
    if( ID == 0 )
    {
        eBowType bowType = (eBowType)accessoryID;
        
        self.archersEyeInfo.currBow.type = bowType;
        self.labelBowType.text           = [BowInfo typeAsString:bowType];
    }
    // BowAim
    else
    {
        eBowAim bowAim = (eBowAim)accessoryID;
        
        self.archersEyeInfo.currBow.aim  = bowAim;
        self.labelAiming.text            = [BowInfo aimAsString:bowAim];
    }
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
    [self.archersEyeInfo saveCurrBow];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
