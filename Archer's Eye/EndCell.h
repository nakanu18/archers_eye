//
//  EndCell.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndCell : UITableViewCell
{
}

@property (strong) NSMutableArray *arrowLabels;

@property (weak) IBOutlet UILabel *endNumLabel;

@property (weak) IBOutlet UILabel *arrow0Label;
@property (weak) IBOutlet UILabel *arrow1Label;
@property (weak) IBOutlet UILabel *arrow2Label;
@property (weak) IBOutlet UILabel *arrow3Label;
@property (weak) IBOutlet UILabel *arrow4Label;
@property (weak) IBOutlet UILabel *arrow5Label;

@property (weak) IBOutlet UILabel *endScoreLabel;
@property (weak) IBOutlet UILabel *totalScoreLabel;

@end
