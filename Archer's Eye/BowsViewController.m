//
//  BowsViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "BowsViewController.h"
#import "BowDescCell.h"

@interface BowsViewController ()

@end



@implementation BowsViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [super viewDidLoad];
}



//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data;  This is in case we created a live round and need to add
    // that into our list
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
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
    BowDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BowDescCell"];
    BowInfo     *bow  = _appDelegate.allBows[indexPath.row];

    cell.bowName.text        = bow.name;
    cell.bowType.text        = [BowInfo typeAsString:bow.type];
    cell.bowDrawWeight.text  = [NSString stringWithFormat:@"%ld lbs", bow.drawWeight];
    
    return cell;
}



//------------------------------------------------------------------------------
// Override to support editing the table view.
-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        // Delete the row from the data source
        [_appDelegate.allBows removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if( editingStyle == UITableViewCellEditingStyleInsert )
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_appDelegate selectBow:indexPath.row];
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
