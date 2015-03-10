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

@property (nonatomic, strong) NSMutableArray *arrowLabels;

@property (nonatomic, weak) IBOutlet UILabel *endNumLabel;

@property (nonatomic, weak) IBOutlet UILabel *arrow0Label;
@property (nonatomic, weak) IBOutlet UILabel *arrow1Label;
@property (nonatomic, weak) IBOutlet UILabel *arrow2Label;
@property (nonatomic, weak) IBOutlet UILabel *arrow3Label;
@property (nonatomic, weak) IBOutlet UILabel *arrow4Label;
@property (nonatomic, weak) IBOutlet UILabel *arrow5Label;

@property (nonatomic, weak) IBOutlet UILabel *endScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalScoreLabel;

@end
