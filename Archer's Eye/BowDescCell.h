//
//  BowDescCell.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BowDescCell : UITableViewCell
{
    
}

@property (nonatomic, weak) IBOutlet UILabel *bowName;
@property (nonatomic, weak) IBOutlet UILabel *bowType;
@property (nonatomic, weak) IBOutlet UILabel *bowDrawWeight;

@end
