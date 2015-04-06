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

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UILabel *dist;
@property (nonatomic, weak) IBOutlet UILabel *desc;
@property (nonatomic, weak) IBOutlet UILabel *avg;
@property (nonatomic, weak) IBOutlet UILabel *score;

@property (nonatomic, weak) IBOutlet UILabel *bowName;
@property (nonatomic, weak) IBOutlet UILabel *bowType;
@property (nonatomic, weak) IBOutlet UILabel *bowWeight;

@end
