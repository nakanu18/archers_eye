//
//  NewLiveRoundViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/15/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "NewLiveRoundViewController.h"
#import "RoundDescCell.h"

@interface NewLiveRoundViewController ()

@end



@implementation NewLiveRoundViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
    self.groupedRounds  = [self.archersEyeInfo arrayOfCustomRoundsByFirstName];
    
    // Insert a dummy array for the live round
    if( self.archersEyeInfo.liveRound != nil )
        [self.groupedRounds insertObject:[NSMutableArray new] atIndex:0];

    [super viewDidLoad];
}


//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data;  This is in case we created a live round and need to add
    // that into our list
    self.groupedRounds  = [self.archersEyeInfo arrayOfCustomRoundsByFirstName];

    // Insert a dummy array for the live round
    if( self.archersEyeInfo.liveRound != nil )
        [self.groupedRounds insertObject:[NSMutableArray new] atIndex:0];
    
    [self.tableView reloadData];

    [super viewWillAppear:animated];
}



//------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.archersEyeInfo showHintPopupIfNecessary:eHint_BnA_NewLiveRound];
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
    if( section == 0  &&  self.archersEyeInfo.liveRound != nil )
        return 1;
    else
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
    else
    {
        if( section == 0  &&  self.archersEyeInfo.liveRound != nil )
            title = @"Live Round";
    }
    return title;
}



//------------------------------------------------------------------------------
// Build the rows.
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundDescCell *cell     = nil;
    RoundInfo     *template = nil;

    // Build the live round
    if( indexPath.section == 0  &&  self.archersEyeInfo.liveRound != nil )
    {
        cell     = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCellLive"];
        template = self.archersEyeInfo.liveRound;

        [cell setBackgroundColor:[UIColor greenColor]];
    }
    
    // Check if we haven't build the live round, then build the regular round
    if( cell == nil )
    {
        cell     = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
        template = self.groupedRounds[indexPath.section][indexPath.row];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
    }

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
    if( self.archersEyeInfo.liveRound == nil )
    {
        RoundInfo *roundTemplate = self.groupedRounds[indexPath.section][indexPath.row];
        
        if( roundTemplate != nil )
            [self.archersEyeInfo startLiveRoundFromTemplate:roundTemplate];
    }
}



//------------------------------------------------------------------------------
// Will select a row.
//------------------------------------------------------------------------------
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *newIndexPath = indexPath;
    
    if( [self.archersEyeInfo liveRound] != nil )
    {
        // Prevent selection of other rows if a live round exists
        if( indexPath.section > 0 )
            newIndexPath = nil;
    }
    return newIndexPath;
}



//------------------------------------------------------------------------------
// Row accessory button tapped.
//------------------------------------------------------------------------------
-                           (void)tableView:(UITableView *)tableView
   accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    RoundInfo *roundTemplate = self.groupedRounds[indexPath.section][indexPath.row];
    
    [self.archersEyeInfo selectRoundInfo:roundTemplate andCategory:eRoundCategory_Custom];
}



//------------------------------------------------------------------------------
// Override to support editing the table view.
//------------------------------------------------------------------------------
-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL deleteCustom = YES;
    
    if( [self.archersEyeInfo liveRound] != nil )
    {
        if( indexPath.section == 0 )
        {
            // Delete the row from the data source
            [self.archersEyeInfo endLiveRoundAndDiscard];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            deleteCustom = NO;
        }
    }
    
    if( deleteCustom )
    {
        RoundInfo *roundTemplate = self.groupedRounds[indexPath.section][indexPath.row];
        
        [self.archersEyeInfo.customRounds removeObject:roundTemplate];
        [self.groupedRounds[indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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



//------------------------------------------------------------------------------
- (IBAction)unwindToNewLiveRound:(UIStoryboardSegue *)segue
{
}

@end
