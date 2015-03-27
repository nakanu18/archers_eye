//
//  ChooseDistanceViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/18/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KeyboardHandlerViewController.h"

@interface RoundInfoViewController : KeyboardHandlerViewController <UITextFieldDelegate>
{
}

@property (weak)            AppDelegate         *appDelegate;
@property (weak) IBOutlet   UIBarButtonItem     *barButtonSave;

@property (weak) IBOutlet   UITextField         *textName;
@property (weak) IBOutlet   UISegmentedControl  *segControlRoundType;
@property (weak) IBOutlet   UILabel             *labelNumEnds;
@property (weak) IBOutlet   UILabel             *labelNumArrows;
@property (weak) IBOutlet   UILabel             *labelDefaultDist;
@property (weak) IBOutlet   UISlider            *sliderNumEnds;
@property (weak) IBOutlet   UISlider            *sliderNumArrows;
@property (weak) IBOutlet   UISlider            *sliderDefaultDist;





- (IBAction)numEndsChanged:(id)sender;
- (IBAction)numArrowsChanged:(id)sender;
- (IBAction)defaultDistChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
