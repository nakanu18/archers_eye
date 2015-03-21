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
    self.bowInfo     = [BowInfo new];
    [self registerForKeyboardNotifications];
    [_barButtonSave setEnabled:NO];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NOTE: This is the fix some weirdness with the top offset of scrollview.
    // Without this set, if the top of the scrollview is flush with the nav bar,
    // the scrollview will actually be moved down by the size of the nav bar
    //
    // Commented out because there is a setting in InterfaceBuilder.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addToolbarToNumberPad];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
























#pragma mark - Keyboard (for UITextField)

//------------------------------------------------------------------------------
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}



//------------------------------------------------------------------------------
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info          = [aNotification userInfo];
    CGSize        kbSize        = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets  contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    _scrollView.contentInset          = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect  aRect       = self.view.frame;
    CGPoint fieldOrigin = _activeTextField.frame.origin;
    
    aRect.size.height -= kbSize.height;
    
    if( !CGRectContainsPoint( aRect, fieldOrigin ) )
    {
        [self.scrollView scrollRectToVisible:_activeTextField.frame animated:YES];
    }
}



//------------------------------------------------------------------------------
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    _scrollView.contentInset            = contentInsets;
    _scrollView.scrollIndicatorInsets   = contentInsets;
}



//------------------------------------------------------------------------------
- (void)addToolbarToNumberPad
{
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    numberToolbar.barStyle  = UIBarStyleBlackTranslucent;
    numberToolbar.items     = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                                                        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                                        [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                                                        nil];
    [numberToolbar sizeToFit];
    _bowDrawWeight.inputAccessoryView = numberToolbar;
}



//------------------------------------------------------------------------------
- (void)cancelNumberPad
{
    [_bowDrawWeight resignFirstResponder];
//    _bowDrawWeight.text = @"";
}



//------------------------------------------------------------------------------
- (void)doneWithNumberPad
{
//    NSString *numberFromTheKeyboard = _bowDrawWeight.text;
    [_bowDrawWeight resignFirstResponder];
}






















#pragma - mark BowName (UITextField)

//------------------------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
}



//------------------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if( textField == _bowName )         _bowInfo.name       = textField.text;
    if( textField == _bowDrawWeight )   _bowInfo.drawWeight = [textField.text integerValue];

    _activeTextField = nil;

    [self toggleSaveButtonIfReady];
}



//------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _activeTextField = nil;
    
    return YES;
}























#pragma mark - BowType (UIPicker)

//------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}



//------------------------------------------------------------------------------
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return eBowType_Count;
}



//------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [BowInfo typeAsString:(eBowType)row];
}




//------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    _bowInfo.type = (eBowType)row;
    
    if( _activeTextField != nil )
        [self textFieldShouldReturn:_activeTextField];
    
    [self toggleSaveButtonIfReady];
}





















#pragma mark - Buttons

//------------------------------------------------------------------------------
- (void)toggleSaveButtonIfReady
{
    _barButtonSave.enabled = [_bowInfo isInfoValid];
}



//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    // Programmatically run the unwind segue.
    [self performSegueWithIdentifier:@"unwindToBowsView" sender:self];
}




//------------------------------------------------------------------------------
- (IBAction)save:(id)sender
{
    if( _activeTextField != nil )
        [self textFieldShouldReturn:_activeTextField];
    
    [_appDelegate addNewBow:_bowInfo];

    // Programmatically run the unwind segue.
    [self performSegueWithIdentifier:@"unwindToBowsView" sender:self];
}

@end
