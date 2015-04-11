//
//  ChooseRoundViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/9/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "ChooseRoundViewController.h"
#import "RoundDescCell.h"

@interface ChooseRoundViewController ()

@end



@implementation ChooseRoundViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
    self.groupedRounds  = [self.archersEyeInfo arrayOfRoundsByFirstName:self.archersEyeInfo.customRounds];
    
    [super viewDidLoad];
}



//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data.
    self.groupedRounds  = [self.archersEyeInfo arrayOfRoundsByFirstName:self.archersEyeInfo.customRounds];
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}























#pragma mark - Table view data source

//------------------------------------------------------------------------------
// Number of sections.
//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groupedRounds count];
}



//------------------------------------------------------------------------------
// Number of rows for a section.
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.groupedRounds[section] count];
}



//------------------------------------------------------------------------------
// Section titles.
//------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    if( [self.groupedRounds[section] count] > 0 )
    {
        RoundInfo *pastRoundInfo  = self.groupedRounds[section][0];
        
        title = [pastRoundInfo name];
    }
    return title;
}



//------------------------------------------------------------------------------
// Build the rows.
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundDescCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
    RoundInfo     *template = self.groupedRounds[indexPath.section][indexPath.row];
    
    cell.name.text      = template.name;
    cell.dist.text      = [NSString stringWithFormat:@"%ld yds", (long)template.distance];
    cell.desc.text      = [NSString stringWithFormat:@"%ldx%ld", (long)template.numEnds,  (long)template.numArrowsPerEnd];
    cell.score.text     = [NSString stringWithFormat:@"%ld pts", (long)template.numEnds * (long)template.numArrowsPerEnd * [template getMaxArrowRealScore]];
    
    return cell;
}



//------------------------------------------------------------------------------
// Did select a row.
//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundInfo *roundTemplate = self.groupedRounds[indexPath.section][indexPath.row];
    
    [self.archersEyeInfo startLiveRoundFromTemplate:roundTemplate];
}



//------------------------------------------------------------------------------
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
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
