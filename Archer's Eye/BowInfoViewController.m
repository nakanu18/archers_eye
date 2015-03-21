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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NOTE: This is the fix some weirdness with the top offset of scrollview.
    // Without this set, if the top of the scrollview is flush with the nav bar,
    // the scrollview will actually be moved down by the size of the nav bar
    //
    // Commented out because there is a setting in InterfaceBuilder.
//    self.automaticallyAdjustsScrollViewInsets = NO;
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
//    fieldOrigin.y     += _activeTextField.frame.size.height;
    
    NSLog( @"frame %@", NSStringFromCGRect( aRect ) );
    NSLog( @"fieldOrigin %@", NSStringFromCGPoint( fieldOrigin ) );
    NSLog( @"keyboard %@", NSStringFromCGSize( kbSize ) );
    
    if( !CGRectContainsPoint( aRect, fieldOrigin ) )
    {
//        [self.scrollView scrollRectToVisible:_activeTextField.frame animated:YES];
        CGPoint scrollPoint = CGPointMake( 0.0, fieldOrigin.y - kbSize.height);
        [_scrollView setContentOffset:scrollPoint animated:YES];
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






















#pragma - mark BowName (UITextField)

//------------------------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( _activeTextField != nil )
        [self textFieldShouldReturn:_activeTextField];
    
    _activeTextField = textField;
}



//------------------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if( textField == _bowName )         _bowInfo.name       = textField.text;
    if( textField == _bowDrawWeight )   _bowInfo.drawWeight = [textField.text integerValue];

    _activeTextField = nil;
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
    
    NSLog( @"BowType: %d", _bowInfo.type );
}





















#pragma mark - Buttons

//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    // Programmatically run the unwind segue because we have to wait for the
    // AlertView.
    [self performSegueWithIdentifier:@"unwindToBowsView" sender:self];
}




//------------------------------------------------------------------------------
- (IBAction)save:(id)sender
{
    if( _activeTextField != nil )
        [self textFieldShouldReturn:_activeTextField];
    
    [_appDelegate addNewBow:_bowInfo];

    // Programmatically run the unwind segue because we have to wait for the
    // AlertView.
    [self performSegueWithIdentifier:@"unwindToBowsView" sender:self];
}

@end
