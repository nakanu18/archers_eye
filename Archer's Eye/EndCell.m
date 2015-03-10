//
//  EndCell.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "EndCell.h"

@implementation EndCell

//------------------------------------------------------------------------------
- (void)awakeFromNib
{
    // Initialization code
    [self setArrowLabels:[[NSMutableArray alloc] init]];
    
    [_arrowLabels addObject:_arrow0Label];
    [_arrowLabels addObject:_arrow1Label];
    [_arrowLabels addObject:_arrow2Label];
    [_arrowLabels addObject:_arrow3Label];
    [_arrowLabels addObject:_arrow4Label];
    [_arrowLabels addObject:_arrow5Label];
}



//------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
