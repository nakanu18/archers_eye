//
//  RoundCell.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastRoundCell : UITableViewCell
{
    
}

@property (weak) IBOutlet UILabel *nameLabel;
@property (weak) IBOutlet UILabel *dateLabel;
@property (weak) IBOutlet UILabel *scoreLabel;
@property (weak) IBOutlet UILabel *averageLabel;

@end
