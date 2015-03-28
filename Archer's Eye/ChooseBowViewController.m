//
//  ChooseBowViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/27/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "ChooseBowViewController.h"
#import "BowDescCell.h"

@interface ChooseBowViewController ()

@end



@implementation ChooseBowViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}























#pragma mark - Table view data source

//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_appDelegate.allBows count];
}



//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BowDescCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"BowDescCell"];
    BowInfo     *bow    = _appDelegate.allBows[indexPath.row];
    
    cell.bowName.text        = bow.name;
    cell.bowType.text        = [BowInfo typeAsString:bow.type];
    cell.bowDrawWeight.text  = [NSString stringWithFormat:@"%ld lbs", bow.drawWeight];
    
    return cell;
}



//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



//------------------------------------------------------------------------------
-               (CGFloat)tableView:(UITableView *)tableView
  estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



//------------------------------------------------------------------------------
-       (CGFloat)tableView:(UITableView *)tableView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end