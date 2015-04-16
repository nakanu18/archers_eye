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

@property (nonatomic, weak)            AppDelegate         *appDelegate;
@property (nonatomic, weak)            ArchersEyeInfo      *archersEyeInfo;
@property (nonatomic, weak) IBOutlet   UIBarButtonItem     *barButtonSave;

@property (nonatomic, weak) IBOutlet   UITextField         *textName;
@property (nonatomic, weak) IBOutlet   UISegmentedControl  *segControlRoundType;
@property (nonatomic, weak) IBOutlet   UILabel             *labelNumEnds;
@property (nonatomic, weak) IBOutlet   UILabel             *labelNumArrows;
@property (nonatomic, weak) IBOutlet   UILabel             *labelDefaultDist;
@property (nonatomic, weak) IBOutlet   UISlider            *sliderNumEnds;
@property (nonatomic, weak) IBOutlet   UISlider            *sliderNumArrows;
@property (nonatomic, weak) IBOutlet   UISlider            *sliderDefaultDist;
@property (nonatomic, weak) IBOutlet   UIStepper           *stepperNumEnds;
@property (nonatomic, weak) IBOutlet   UIStepper           *stepperNumArrows;
@property (nonatomic, weak) IBOutlet   UIStepper           *stepperDefaultDist;
@property (nonatomic, weak) IBOutlet   UISwitch            *switchXExtraPoint;





- (IBAction)numEndsChanged:(id)sender;
- (IBAction)numArrowsChanged:(id)sender;
- (IBAction)defaultDistChanged:(id)sender;
- (IBAction)xExtraPointChanged:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
