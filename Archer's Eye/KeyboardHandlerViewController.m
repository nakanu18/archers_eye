//
//  KeyboardHandlerViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/25/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "KeyboardHandlerViewController.h"

@implementation KeyboardHandlerViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerForKeyboardNotifications];
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
- (void)addToolbarToNumberPad:(UITextField *)field
{
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    numberToolbar.barStyle  = UIBarStyleDefault;
    numberToolbar.items     = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil  action:nil],
                                                        [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone           target:self action:@selector(doneWithNumberPad)],
                                                        nil];
    [numberToolbar sizeToFit];
    field.inputAccessoryView = numberToolbar;
}



//------------------------------------------------------------------------------
- (void)doneWithNumberPad
{
//    NSString *numberFromTheKeyboard = _bowDrawWeight.text;
    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
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
    _activeTextField = nil;
}



//------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _activeTextField = nil;
    
    return YES;
}

@end
