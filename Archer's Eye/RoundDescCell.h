//
//  RoundDescCell.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/15/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundDescCell : UITableViewCell
{
    
}

@property (weak) IBOutlet UILabel *name;
@property (weak) IBOutlet UILabel *date;
@property (weak) IBOutlet UILabel *desc;
@property (weak) IBOutlet UILabel *score;

@end
