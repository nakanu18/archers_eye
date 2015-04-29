//
//  BowAccessoryViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/27/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "BowAccessoryViewController.h"

@interface BowAccessoryViewController ()

@end

@implementation BowAccessoryViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo = self.appDelegate.archersEyeInfo;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self selectRowWithCheckmark:self.selectedNameID];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}























#pragma mark - Table view data source

//------------------------------------------------------------------------------
// Number of rows in a section.
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayNames count];
}



//------------------------------------------------------------------------------
// Build the rows.
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];
    
    tableViewCell.name.text = self.arrayNames[indexPath.row];
    
    return tableViewCell;
}



//------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectRowWithCheckmark:indexPath.row];
    
    // Send our data to the delegate
    if( self.delegate != nil )
    {
        if( [self.delegate respondsToSelector:@selector(setAccessoryForCurrentBow:forID:)] )
            [self.delegate setAccessoryForCurrentBow:self.selectedNameID forID:self.ID];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
// Set the checkmark for the given row.
//------------------------------------------------------------------------------
- (void)selectRowWithCheckmark:(NSInteger)rowID
{
    self.selectedNameID = rowID;
    
    for( NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i )
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        cell.accessoryType = (i == self.selectedNameID) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

@end
