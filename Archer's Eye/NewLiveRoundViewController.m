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
    self.appDelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.sectionTypes = [NSMutableArray new];

    [super viewDidLoad];
}



//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // Remove all the previous sections
    [_sectionTypes removeAllObjects];
    
    // Now, setup the current sections in a list
    
    if( _appDelegate.liveRound != nil )
        [_sectionTypes addObject:[NSNumber numberWithInt:eNewLiveRoundSectionType_Live]];
    if( [_appDelegate.customRounds count] > 0 )
        [_sectionTypes addObject:[NSNumber numberWithInt:eNewLiveRoundSectionType_Custom]];
    [_sectionTypes addObject:[NSNumber numberWithInt:eNewLiveRoundSectionType_Common]];
    
    // Reload the data;  This is in case we created a live round and need to add
    // that into our list
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTypes count];
}



//------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString                 *header;
    eNewLiveRoundSectionType  type = [_sectionTypes[section] intValue];
    
    switch( type )
    {
        case eNewLiveRoundSectionType_Live:     header = @"Live Rounds";   break;
        case eNewLiveRoundSectionType_Custom:   header = @"Custom Rounds"; break;
        case eNewLiveRoundSectionType_Common:   header = @"Common Rounds"; break;
    }
    
    return header;
}



//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger                 count = [_appDelegate.commonRounds count];
    eNewLiveRoundSectionType  type  = [_sectionTypes[section] intValue];

    switch( type )
    {
        case eNewLiveRoundSectionType_Live:   count = (_appDelegate.liveRound != nil);   break;
        case eNewLiveRoundSectionType_Custom: count = [_appDelegate.customRounds count]; break;
        case eNewLiveRoundSectionType_Common: count = [_appDelegate.commonRounds count]; break;
    }
    
    return count;
}



//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eNewLiveRoundSectionType  type     = [_sectionTypes[indexPath.section] intValue];
    RoundDescCell            *cell     = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
    RoundInfo                *template = nil;

    // Live round section
    if( type == eNewLiveRoundSectionType_Live )
    {
        if( _appDelegate.liveRound != nil )
        {
            template = _appDelegate.liveRound;
            
            [cell setBackgroundColor:[UIColor greenColor]];
            cell.name.text      = template.name;
            cell.desc.text      = [NSString stringWithFormat:@"%ldx%ld", template.numEnds,  template.numArrowsPerEnd];
            cell.score.text     = [NSString stringWithFormat:@"%ld pts", template.numEnds * template.numArrowsPerEnd * [template getMaxArrowScore]];
            
            cell.accessoryType  = UITableViewCellAccessoryNone;
        }
    }
    // Custom rounds section
    else if( type == eNewLiveRoundSectionType_Custom )
    {
        template = _appDelegate.customRounds[indexPath.row];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.name.text      = template.name;
        cell.desc.text      = [NSString stringWithFormat:@"%ldx%ld", template.numEnds,  template.numArrowsPerEnd];
        cell.score.text     = [NSString stringWithFormat:@"%ld pts", template.numEnds * template.numArrowsPerEnd * [template getMaxArrowScore]];
    }
    // Common rounds section
    else if( type == eNewLiveRoundSectionType_Common )
    {
        template = _appDelegate.commonRounds[indexPath.row];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.name.text      = template.name;
        cell.desc.text      = [NSString stringWithFormat:@"%ldx%ld", template.numEnds,  template.numArrowsPerEnd];
        cell.score.text     = [NSString stringWithFormat:@"%ld pts", template.numEnds * template.numArrowsPerEnd * [template getMaxArrowScore]];
    }
    return cell;
}



//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eNewLiveRoundSectionType type = [_sectionTypes[indexPath.section] intValue];

    // Only build a new live round if something is selected from custom or
    // common.
    if( type != eNewLiveRoundSectionType_Live )
    {
        RoundInfo *roundTemplate = nil;
        
        if( type == eNewLiveRoundSectionType_Custom )
            roundTemplate = _appDelegate.customRounds[indexPath.row];
        else if( type == eNewLiveRoundSectionType_Common )
            roundTemplate = _appDelegate.commonRounds[indexPath.row];
        
        if( roundTemplate != nil )
            [_appDelegate startLiveRoundFromTemplate:roundTemplate];
    }
}



//------------------------------------------------------------------------------
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath             *newIndexPath   = indexPath;
    eNewLiveRoundSectionType type           = [_sectionTypes[indexPath.section] intValue];
    
    if( [_appDelegate liveRound] != nil )
    {
        // Prevent selection of other rows if a live round exists
        if( type > eNewLiveRoundSectionType_Live )
            newIndexPath = nil;
    }
    return newIndexPath;
}



//------------------------------------------------------------------------------
-                           (void)tableView:(UITableView *)tableView
   accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    eNewLiveRoundSectionType type = [_sectionTypes[indexPath.section] intValue];
    
    if( type == eNewLiveRoundSectionType_Custom )
        [_appDelegate selectRound:indexPath.row andCategory:eRoundCategory_Custom];
    else if( type == eNewLiveRoundSectionType_Common )
        [_appDelegate selectRound:indexPath.row andCategory:eRoundCategory_Common];
}



//------------------------------------------------------------------------------
// Override to support editing the table view.
-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    eNewLiveRoundSectionType type = [_sectionTypes[indexPath.section] intValue];
    
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        if( type == eNewLiveRoundSectionType_Live )
        {
            if( [_appDelegate liveRound] != nil )
            {
                // Delete the row from the data source
                [_appDelegate endLiveRoundAndDiscard];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else if( type == eNewLiveRoundSectionType_Custom )
        {
            [_appDelegate.customRounds removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if( type == eNewLiveRoundSectionType_Common )
        {
            [_appDelegate.commonRounds removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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
