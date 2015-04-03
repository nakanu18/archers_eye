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
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo = self.appDelegate.archersEyeInfo;

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
// Number of sections.
//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//------------------------------------------------------------------------------
// Number of rows in a section.
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.archersEyeInfo.allBows count];
}



//------------------------------------------------------------------------------
// Build the rows.
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BowDescCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"BowDescCell"];
    BowInfo     *bow    = self.archersEyeInfo.allBows[indexPath.row];
    
    cell.bowName.text        = bow.name;
    cell.bowType.text        = [BowInfo typeAsString:bow.type];
    cell.bowDrawWeight.text  = [NSString stringWithFormat:@"%ld lbs", bow.drawWeight];
    
    return cell;
}



//------------------------------------------------------------------------------
// Did select a row.
//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.archersEyeInfo.liveRound.bow = self.archersEyeInfo.allBows[indexPath.row];
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






















#pragma mark - Buttons

//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    [self.archersEyeInfo endLiveRoundAndDiscard];
    
    // Programmatically run the unwind segue.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end