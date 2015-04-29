//
//  LiveRoundViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/9/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "LiveRoundViewController.h"
#import "RoundEditorViewController.h"
#import "RoundDescCell.h"

@interface LiveRoundViewController ()

@end



@implementation LiveRoundViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
    
    [super viewDidLoad];
}



//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data;  This is in case we created a live round and need to add
    // that into our list
    [self.tableView reloadData];
    [self initPlot];
    self.startButton.enabled = !self.archersEyeInfo.liveRound;
    
    [super viewWillAppear:animated];
}



//------------------------------------------------------------------------------
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self initPlot];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



//------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"gotoRoundEditorFromLiveRound"] )
    {
        UINavigationController    *nav    = segue.destinationViewController;
        RoundEditorViewController *editor = (RoundEditorViewController *)[nav topViewController];
        
        editor.editorType = eRoundEditorType_Live;
    }
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
// Number of rows for a section.
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.archersEyeInfo.liveRound != nil;
}



//------------------------------------------------------------------------------
// Section titles.
//------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return @"";
}



//------------------------------------------------------------------------------
// Build the rows.
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
    RoundInfo     *info = self.archersEyeInfo.liveRound;
    
    cell.name.text      = info.name;
    cell.dist.text      = [NSString stringWithFormat:@"%ld yds", (long)info.distance];
    cell.desc.text      = [NSString stringWithFormat:@"%ldx%ld", (long)info.numEnds,  (long)info.numArrowsPerEnd];
    cell.score.text     = [NSString stringWithFormat:@"%ld pts", (long)info.numEnds * (long)info.numArrowsPerEnd * [info getMaxArrowRealScore]];
    cell.bowName.text   = info.bow.name;
    cell.bowType.text   = [BowInfo typeAsString:info.bow.type];
    cell.bowWeight.text = [NSString stringWithFormat:@"%ld lbs", (long)info.bow.drawWeight];
    
    return cell;
}



//------------------------------------------------------------------------------
// Did select a row.
//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



//------------------------------------------------------------------------------
// Override to support editing the table view.
//------------------------------------------------------------------------------
-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [self.archersEyeInfo liveRound] != nil )
    {
        // Delete the row from the data source
        [self.archersEyeInfo endLiveRoundAndDiscard];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.startButton.enabled = YES;
        [self initPlot];
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
























#pragma mark - Chart behavior

//------------------------------------------------------------------------------
// Create a new plot.
//------------------------------------------------------------------------------
- (void)initPlot
{
    self.breakdownView.currRound = self.archersEyeInfo.liveRound;
    [self.breakdownView initPlot];
}
























//------------------------------------------------------------------------------
- (IBAction)unwindToLiveRound:(UIStoryboardSegue *)segue
{
}

@end
