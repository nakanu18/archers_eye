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

@property (nonatomic, strong) NSMutableArray *arrowButtons;

@property (nonatomic, weak) IBOutlet UILabel *endNumLabel;

@property (nonatomic, weak) IBOutlet UIButton *arrow0Button;
@property (nonatomic, weak) IBOutlet UIButton *arrow1Button;
@property (nonatomic, weak) IBOutlet UIButton *arrow2Button;
@property (nonatomic, weak) IBOutlet UIButton *arrow3Button;
@property (nonatomic, weak) IBOutlet UIButton *arrow4Button;
@property (nonatomic, weak) IBOutlet UIButton *arrow5Button;

@property (nonatomic, weak) IBOutlet UILabel *endXLabel;
@property (nonatomic, weak) IBOutlet UILabel *endScoreLabel;

@end
