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
    [self setArrowButtons:[NSMutableArray new]];
    
    [_arrowButtons addObject:_arrow0Button];
    [_arrowButtons addObject:_arrow1Button];
    [_arrowButtons addObject:_arrow2Button];
    [_arrowButtons addObject:_arrow3Button];
    [_arrowButtons addObject:_arrow4Button];
    [_arrowButtons addObject:_arrow5Button];
    
    for( UIButton *button in self.arrowButtons )
    {
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
}



//------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
