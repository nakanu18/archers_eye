//
//  ArchersEyeInfo.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/31/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "ArchersEyeInfo.h"
#import "AppDelegate.h"

@implementation ArchersEyeInfo

#pragma mark - Load/Save

//------------------------------------------------------------------------------
// Load some default values.
//------------------------------------------------------------------------------
- (void)loadDefaults
{
    self.version        = SAVE_DATA_VERSION;
    self.customRounds   = [NSMutableArray new];
    self.pastRounds     = [NSMutableArray new];
    self.allBows        = [NSMutableArray new];
    _currBowID          = -1;
    _currRoundID        = -1;
    
    RoundInfo *fita600Round = [[RoundInfo alloc] initWithName:@"FITA 600" andType:eRoundType_FITA andDist:20 andNumEnds:20 andArrowsPerEnd:3 andXPlusOnePoint:NO];
    RoundInfo *nfaa300Round = [[RoundInfo alloc] initWithName:@"NFAA 300" andType:eRoundType_NFAA andDist:20 andNumEnds:12 andArrowsPerEnd:5 andXPlusOnePoint:NO];
//    RoundInfo *shortRound   = [[RoundInfo alloc] initWithName:@"TEST 25"  andType:eRoundType_FITA andDist:20 andNumEnds:1  andArrowsPerEnd:5 andXPlusOnePoint:NO];
    [_customRounds addObject:fita600Round];
    [_customRounds addObject:nfaa300Round];
//    [_customRounds addObject:shortRound];
    
    BowInfo *whiteFlute = [[BowInfo alloc] initWithName:@"White Flute" andType:eBowType_Recurve  andDrawWeight:28];
    BowInfo *blackPSE   = [[BowInfo alloc] initWithName:@"Black PSE"   andType:eBowType_Compound andDrawWeight:60];
    [_allBows addObject:whiteFlute];
    [_allBows addObject:blackPSE];
    
    self.showHints      = [NSMutableArray new];
    
    for( NSInteger i = 0; i < eHint_Count; ++i )
    {
        [self.showHints addObject:[NSNumber numberWithBool:YES]];
    }
}



//------------------------------------------------------------------------------
// Load the save data if it can be found.
//------------------------------------------------------------------------------
- (void)loadDataFromDevice
{
    NSData *saveData = [[NSUserDefaults standardUserDefaults] dataForKey:@"archersEyeInfo"];

    // No save data file; load the defaults
    if( saveData == nil )
    {
        DLog( @"ArchersEyeInfo: userDefaults save data NOT found - loading defaults" );
        
        [self loadDefaults];
    }
    // Found save data file; load it
    else
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];

        DLog( @"ArchersEyeInfo: userDefaults save data found - loading (v%.2f) - %@", [[unarchiver decodeObjectForKey:@"saveVersion"] floatValue], [unarchiver decodeObjectForKey:@"saveDate"] );
        
        self.version        = [[unarchiver decodeObjectForKey:@"saveVersion"] floatValue];
        self.liveRound      =  [unarchiver decodeObjectForKey:@"liveRound"];
        self.customRounds   =  [unarchiver decodeObjectForKey:@"customRounds"];
        self.currRound      =  [unarchiver decodeObjectForKey:@"currRound"];
        self.pastRounds     =  [unarchiver decodeObjectForKey:@"pastRounds"];
        self.currBow        =  [unarchiver decodeObjectForKey:@"currBow"];
        self.allBows        =  [unarchiver decodeObjectForKey:@"allBows"];
        self.showHints      =  [unarchiver decodeObjectForKey:@"showHints"];
        [unarchiver finishDecoding];
        
        // ERROR CHECK: Make sure showHints has enough values
        if( [self.showHints count] < eHint_Count )
        {
            self.showHints = [NSMutableArray new];
            for( NSInteger i = 0; i < eHint_Count; ++i )
            {
                [self.showHints addObject:[NSNumber numberWithBool:YES]];
            }
        }
        
        DLog( @"\n" );
    }
}



//------------------------------------------------------------------------------
// Load the save data if it can be found.
//------------------------------------------------------------------------------
- (void)loadDataFromJSONData:(NSData *)jsonData
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    
    DLog( @"ArchersEyeInfo: loading from json (v%.2f) - %@", [dict[@"saveVersion"] floatValue], dict[@"saveDate"] );
    
    self.version = [dict[@"saveVersion"] floatValue];
    
    self.customRounds = [NSMutableArray new];
    for( NSInteger i = 0; i < [dict[@"customRounds"] count]; ++i )
    {
        RoundInfo *newRound = [[RoundInfo alloc] initFromDictionary:dict[@"customRounds"][i]];

        [self.customRounds addObject:newRound];
    }
    
    
    
    self.pastRounds = [NSMutableArray new];
    for( NSInteger i = 0; i < [dict[@"pastRounds"] count]; ++i )
    {
        RoundInfo *newRound = [[RoundInfo alloc] initFromDictionary:dict[@"pastRounds"][i]];
        
        [self.pastRounds addObject:newRound];
    }
    

    
    self.allBows = [NSMutableArray new];
    for( NSInteger i = 0; i < [dict[@"allBows"] count]; ++i )
    {
        BowInfo *newBow = [[BowInfo alloc] initFromDictionary:dict[@"allBows"][i]];
        
        [self.allBows addObject:newBow];
    }
    
    
    
    self.showHints = [NSMutableArray new];
    for( NSInteger i = 0; i < [dict[@"showHints"] count]; ++i )
    {
        [self.showHints addObject:dict[@"showHints"][i]];
    }
    
    // ERROR CHECK: Make sure showHints has enough values
    if( [self.showHints count] < eHint_Count )
    {
        self.showHints = [NSMutableArray new];
        for( NSInteger i = 0; i < eHint_Count; ++i )
        {
            [self.showHints addObject:[NSNumber numberWithBool:YES]];
        }
    }
        
    DLog( @"\n" );
}



//------------------------------------------------------------------------------
// Returns data in json format.
//------------------------------------------------------------------------------
- (NSData *)jsonData
{
    DLog( @"ArchersEyeInfo: converting to json (v%.2f)", SAVE_DATA_VERSION );

    NSData              *json;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:[NSNumber numberWithFloat:SAVE_DATA_VERSION] forKey:@"saveVersion"];
    [dict setObject:[AppDelegate shortDateAndTime:[NSDate date]] forKey:@"saveDate"];
    [dict setObject:[self infosToDictionary:self.customRounds]   forKey:@"customRounds"];
    [dict setObject:[self infosToDictionary:self.pastRounds]     forKey:@"pastRounds"];
    [dict setObject:[self infosToDictionary:self.allBows]        forKey:@"allBows"];
    [dict setObject:self.showHints                               forKey:@"showHints"];
    
    json = [NSJSONSerialization dataWithJSONObject:dict
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
    
//    DLog( @"ArchersEyeInfo: %@", [[NSString alloc] initWithData:json encoding:NSASCIIStringEncoding] );
    DLog( @"\n" );
    
    return json;
}



//------------------------------------------------------------------------------
// Converts a given xxxInfo array into json format.
//------------------------------------------------------------------------------
- (NSMutableArray *)infosToDictionary:(NSMutableArray *)infos
{
    NSMutableArray *array = [NSMutableArray new];
    
    for( id info in infos )
    {
        [array addObject:[info dictionary]];
    }
    return array;
}



//------------------------------------------------------------------------------
// Save the current user data.
//------------------------------------------------------------------------------
- (void)saveDataToDevice
{
    DLog( @"ArchersEyeInfo: Saving data (v%.2f)", SAVE_DATA_VERSION );
    
    NSMutableData   *saveData      = [[NSMutableData    alloc] init];
    NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver  alloc] initForWritingWithMutableData:saveData];
    NSNumber        *saveVersion   = [NSNumber numberWithFloat:SAVE_DATA_VERSION];
    NSString        *date          = [AppDelegate shortDateAndTime:[NSDate date]];
    
    [keyedArchiver encodeObject:saveVersion     forKey:@"saveVersion"];
    [keyedArchiver encodeObject:date            forKey:@"saveDate"];
    [keyedArchiver encodeObject:_liveRound      forKey:@"liveRound"];
    [keyedArchiver encodeObject:_customRounds   forKey:@"customRounds"];
    [keyedArchiver encodeObject:_currRound      forKey:@"currRound"];
    [keyedArchiver encodeObject:_pastRounds     forKey:@"pastRounds"];
    [keyedArchiver encodeObject:_currBow        forKey:@"currBow"];
    [keyedArchiver encodeObject:_allBows        forKey:@"allBows"];
    [keyedArchiver encodeObject:_showHints      forKey:@"showHints"];
    [keyedArchiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"archersEyeInfo"];
    DLog( @"\n" );
}



//------------------------------------------------------------------------------
// Clear the user data.
//------------------------------------------------------------------------------
- (void)clearData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"archersEyeInfo"];
}



















#pragma mark - Live Rounds

//------------------------------------------------------------------------------
// Create a live round from the given template.
//------------------------------------------------------------------------------
- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate
{
    if( _liveRound == nil )
    {
        [roundTemplate clearScorecard];
        self.liveRound      = roundTemplate;
        self.liveRound.date = [NSDate date];
    }
}



//------------------------------------------------------------------------------
// End the live round and discard.
//------------------------------------------------------------------------------
- (void)endLiveRoundAndDiscard
{
    // Release the old live round
    self.liveRound = nil;
}



//------------------------------------------------------------------------------
// End the live round and save.
//------------------------------------------------------------------------------
- (void)endLiveRoundAndSave
{
    if( _liveRound != nil )
    {
        // Add the current live round to the log of past scores
        [_pastRounds insertObject:_liveRound atIndex:0];
        
        // Release the old live round
        self.liveRound = nil;
    }
}





















#pragma mark - Generic Round Selection

//------------------------------------------------------------------------------
// Create a new custom round.
//------------------------------------------------------------------------------
- (void)createNewCustomRound:(RoundInfo *)newRound
{
    self.currRound      = newRound;
    _currRoundCategory  = eRoundCategory_Custom;
    _currRoundID        = -1;
}



//------------------------------------------------------------------------------
// Select an already created round from the given category.
//------------------------------------------------------------------------------
- (void)selectRound:(NSInteger)ID andCategory:(eRoundCategory)category
{
    NSMutableArray *roundArray;
    
    _currRoundCategory  = category;
    _currRoundID        = -1;
    
    // Select the array to use
    switch( _currRoundCategory )
    {
        case eRoundCategory_Custom: roundArray = _customRounds;     break;
        case eRoundCategory_Past:   roundArray = _pastRounds;       break;
        default:                    roundArray = nil;               break;
    }
    
    if( ID >= 0  &&  ID < [roundArray count] )
    {
        self.currRound  = roundArray[ID];
        _currRoundID    = ID;      // Save the ID so we can replace it later
    }
}


//------------------------------------------------------------------------------
// Select an already created round from the given category.
//------------------------------------------------------------------------------
- (void)selectRoundInfo:(RoundInfo *)info andCategory:(eRoundCategory)category
{
    NSMutableArray *roundArray;
    
    _currRoundCategory  = category;
    _currRoundID        = -1;
    
    // Select the array to use
    switch( _currRoundCategory )
    {
        case eRoundCategory_Custom: roundArray = _customRounds;     break;
        case eRoundCategory_Past:   roundArray = _pastRounds;       break;
        default:                    roundArray = nil;               break;
    }

    NSUInteger ID = [roundArray indexOfObject:info];
    
    if( ID != NSNotFound )
    {
        self.currRound  = info;
        _currRoundID    = ID;      // Save the ID so we can replace it later
    }
}



//------------------------------------------------------------------------------
// End the current round and discard.
//------------------------------------------------------------------------------
- (void)endCurrRoundAndDiscard
{
    _currRoundCategory  = eRoundCategory_None;
    self.currRound      = nil;
    _currRoundID        = -1;
}



//------------------------------------------------------------------------------
// End the current round and save.
//------------------------------------------------------------------------------
- (void)endCurrRoundAndSave
{
    if( _currRoundCategory != eRoundCategory_None )
    {
        NSMutableArray *roundArray;
        
        // Select the array to use
        switch( _currRoundCategory )
        {
            case eRoundCategory_Custom: roundArray = _customRounds;     break;
            case eRoundCategory_Past:   roundArray = _pastRounds;       break;
            default:                    roundArray = nil;               break;
        }
        
        if( _currRoundID >= 0  &&  _currRoundID < [roundArray count] )
            [roundArray replaceObjectAtIndex:_currRoundID withObject:_currRound];
        else
            [roundArray insertObject:_currRound atIndex:0];
    }
    [self endCurrRoundAndDiscard];
}




















#pragma mark - Bows

//------------------------------------------------------------------------------
// Create a new current bow.
//------------------------------------------------------------------------------
- (void)createNewCurrBow:(BowInfo *)newBow
{
    self.currBow     = newBow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Inventory;
}



//------------------------------------------------------------------------------
// Select an already created bow.
//------------------------------------------------------------------------------
- (void)selectBow:(NSInteger)bowID
{
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Inventory;
    
    if( bowID >= 0  &&  bowID < [_allBows count] )
    {
        // Make a copy so that we can discard the values easily if needed
        self.currBow = _allBows[bowID];
        _currBowID   = bowID;
    }
}



//------------------------------------------------------------------------------
// Select the bow from the live round.
//------------------------------------------------------------------------------
- (void)selectBowFromLiveRound
{
    self.currBow     = _liveRound.bow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Live;
}



//------------------------------------------------------------------------------
// Select the bow from the past round.
//------------------------------------------------------------------------------
- (void)selectBowFromPastRound
{
    self.currBow     = _currRound.bow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Past;
}



//------------------------------------------------------------------------------
// Save the current bow.
//------------------------------------------------------------------------------
- (void)saveCurrBow
{
    // Bow is from the live round
    if( _currBowCategory == eBowCategory_Live )
    {
        _liveRound.bow = _currBow;
    }
    // Bow is from a past round
    else if( _currBowCategory == eBowCategory_Past )
    {
        _currRound.bow = _currBow;
    }
    else if( _currBowCategory == eBowCategory_Inventory )
    {
        // Bow is brand new
        if( _currBowID == -1 )
        {
            [_allBows insertObject:_currBow atIndex:0];
        }
        // Bow is a copy of another one
        else
        {
            [_allBows replaceObjectAtIndex:_currBowID withObject:_currBow];
        }
    }
    [self discardCurrBow];
}



//------------------------------------------------------------------------------
// Discard the current bow.
//------------------------------------------------------------------------------
- (void)discardCurrBow
{
    self.currBow     = nil;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_None;
}




















#pragma mark - Arrays for graphs

//------------------------------------------------------------------------------
// Sorts the given array of RoundInfos by date.
//------------------------------------------------------------------------------
- (void)sortRoundInfos:(NSMutableArray *)roundInfos byKeys:(NSArray *)keys ascending:(BOOL)ascending
{
    NSMutableArray *descs = [NSMutableArray new];
    
    // Iterate through the keys and add them as sorting descriptors
    for( NSString *string in keys )
    {
        NSSortDescriptor *desc  = [[NSSortDescriptor alloc] initWithKey:string ascending:ascending];

        [descs addObject:desc];
    }
    
    [roundInfos sortUsingDescriptors:descs];
}



//------------------------------------------------------------------------------
// Creates an array of rounds used in a given set of rounds.
//------------------------------------------------------------------------------
- (NSMutableArray *)arrayOfUsedRounds
{
    NSMutableArray *usedRounds = [NSMutableArray new];
    
    // Parse through all past rounds and record each unique round used.
    for( RoundInfo *pastRound in _pastRounds )
    {
        BOOL unique = YES;
        
        for( RoundInfo *usedRound in usedRounds )
        {
            if( [usedRound      isTypeOfRound:pastRound]  &&
                [usedRound.bow  isTypeOfBow:pastRound.bow] )
            {
                unique = NO;
                break;
            }
        }
        
        if( unique )
            [usedRounds addObject:pastRound];
    }
    
    if( [usedRounds count] == 0 )
        usedRounds = nil;
    
    return usedRounds;
}



//------------------------------------------------------------------------------
// Creates an array of bows used in a given set of rounds.
//------------------------------------------------------------------------------
- (NSMutableArray *)arrayOfUsedBows
{
    NSMutableArray *usedBows = [NSMutableArray new];
    
    // Parse through all past rounds and record each unique bow used.
    for( RoundInfo *pastRound in _pastRounds )
    {
        BOOL unique = YES;
        
        for( BowInfo *usedBow in usedBows )
        {
            if( [usedBow isTypeOfBow:pastRound.bow] )
            {
                unique = NO;
                break;
            }
        }
        
        if( unique )
            [usedBows addObject:pastRound.bow];
    }
    
    if( [usedBows count] == 0 )
        usedBows = nil;
    
    return usedBows;
}



//------------------------------------------------------------------------------
// Creates a 2D array of commonly used rounds.
//------------------------------------------------------------------------------
- (NSMutableArray *)matrixOfFavoritePastRounds
{
    NSMutableArray *favRounds   = [NSMutableArray new];
    NSMutableArray *usedRounds  = [self arrayOfUsedRounds];
    
    // Sort the past rounds into favRounds based on the type and bow type
    for( RoundInfo *usedRound in usedRounds )
    {
        NSMutableArray *newFav = [NSMutableArray new];
        
        for( RoundInfo *pastRound in _pastRounds )
        {
            if( [usedRound     isTypeOfRound:pastRound]  &&
               [usedRound.bow isTypeOfBow:pastRound.bow] )
                [newFav addObject:pastRound];
        }
        [favRounds addObject:newFav];
    }
    
    
    
    // Remove any rounds that are played less than x amount
    for( NSInteger i = 0; i < [favRounds count]; ++i )
    {
        NSMutableArray *favRound = favRounds[i];
        
        //        if( [favRound count] > 0 )
        //            DLog( @"ArchersEyeInfo: %@ / %@ - %ld", [favRound[0] name], [[favRound[0] bow] name], [favRound count] );
        
        if( [favRound count] < 2 )
        {
            [favRounds removeObject:favRound];
            --i;
        }
    }
    
    
    
    // Let's sort the subarrays so that the dates are ascending
    for( NSMutableArray *array in favRounds )
    {
        [self sortRoundInfos:array byKeys:@[@"date"] ascending:YES];
    }
    
    // Finally let's sort the rows by full name and then distance
    [favRounds sortUsingComparator:^( NSMutableArray *a, NSMutableArray *b )
    {
        NSComparisonResult result = [[a[0] name] compare:[b[0] name] options:0];
        
        if( result == NSOrderedSame )
        {
            if( [a[0] distance] > [b[0] distance] )
                result = NSOrderedDescending;
            else
                result = NSOrderedAscending;
        }
        
        return result;
    }];
    
    return favRounds;
}



//------------------------------------------------------------------------------
// Creates an array of rounds grouped by name.
//------------------------------------------------------------------------------
- (NSMutableArray *)matrixOfRoundsByFirstName:(NSMutableArray *)array
{
    NSMutableArray *groupedArray = [NSMutableArray new];
    NSString       *prevName     = @"";

    [self sortRoundInfos:array byKeys:@[@"firstName", @"lastName", @"distance"] ascending:YES];
    
    // Parse through customRounds - create a new array for each new name
    for( RoundInfo *roundInfo in array )
    {
        NSString *name = [roundInfo firstName];
        
        // New month was found: create a new array
        if( ![prevName isEqualToString:name] )
            [groupedArray addObject:[NSMutableArray new]];
        
        // Add the temp round into it's correct group
        [[groupedArray lastObject] addObject:roundInfo];
        
        prevName = name;
    }
    
    return groupedArray;
}



//------------------------------------------------------------------------------
// Creates an array of rounds grouped by name.
//------------------------------------------------------------------------------
- (NSMutableArray *)matrixOfRoundsByFullName:(NSMutableArray *)array
{
    NSMutableArray *groupedArray = [NSMutableArray new];
    NSString       *prevName     = @"";
    
    [self sortRoundInfos:array byKeys:@[@"name"] ascending:YES];
    
    // Parse through customRounds - create a new array for each new name
    for( RoundInfo *roundInfo in array )
    {
        NSString *name = [roundInfo name];
        
        // New month was found: create a new array
        if( ![prevName isEqualToString:name] )
            [groupedArray addObject:[NSMutableArray new]];
        
        // Add the temp round into it's correct group
        [[groupedArray lastObject] addObject:roundInfo];
        
        prevName = name;
    }
    
    return groupedArray;
}


//------------------------------------------------------------------------------
// Creates an array of rounds grouped by month.
//------------------------------------------------------------------------------
- (NSMutableArray *)matrixOfRoundsByMonth:(NSMutableArray *)array
{
    NSMutableArray *groupedArray = [NSMutableArray new];
    NSInteger       prevMonth    = -1;
    NSInteger       prevYear     = -1;
    
    [self sortRoundInfos:array byKeys:@[@"date"] ascending:NO];
    
    // Parse through pastRounds - create a new array for each new month
    for( RoundInfo *roundInfo in array )
    {
        NSInteger month = [roundInfo.date month];
        NSInteger year  = [roundInfo.date year];
        
        // New month was found: create a new array
        if( prevMonth != month  ||  prevYear != year )
            [groupedArray addObject:[NSMutableArray new]];
        
        // Add the temp round into it's correct group
        [[groupedArray lastObject] addObject:roundInfo];
        
        prevMonth = month;
        prevYear  = year;
    }
    return groupedArray;
}




















#pragma mark - Hints



//------------------------------------------------------------------------------
// Resets the flags for all hints.
//------------------------------------------------------------------------------
- (void)resetAllHints
{
    for( NSInteger i = 0; i < [self.showHints count]; ++i )
    {
        self.showHints[i] = [NSNumber numberWithBool:YES];
    }
}



//------------------------------------------------------------------------------
// Sets the value of a particular hint flag.
//------------------------------------------------------------------------------
- (void)setShowHint:(eHint)hint toBool:(BOOL)show
{
    if( hint < eHint_Count )
        self.showHints[hint] = [NSNumber numberWithBool:show];
}



//------------------------------------------------------------------------------
// Sets the value of a particular hint flag.
//------------------------------------------------------------------------------
- (BOOL)showHint:(eHint)hint
{
    BOOL show = NO;
    
    if( hint < eHint_Count )
        show = [self.showHints[hint] boolValue];
    
    return show;
}



//------------------------------------------------------------------------------
// Message for a particular hint.
//------------------------------------------------------------------------------
- (void)showHintPopupIfNecessary:(eHint)hint
{
    NSString *hintString = [self hintAsString:hint];
    
    if( [self showHint:hint]  &&  ![hintString isEqualToString:@""] )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                            message:[self hintAsString:hint]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    }
    [self setShowHint:hint toBool:NO];
}



//------------------------------------------------------------------------------
// Message for a particular hint.
//------------------------------------------------------------------------------
- (NSString *)hintAsString:(eHint)hint
{
    NSString *string = nil;
    
    switch( hint )
    {
        case eHint_BnA_Results:             string = @""; break;
        case eHint_BnA_Rounds:              string = @""; break;
        case eHint_BnA_Bows:                string = @""; break;
        case eHint_Graphs_PointsBreakdown:  string = @"Shoot a round first to view how the points breakdown."; break;
        case eHint_Graphs_Progress:         string = @"Shoot 2 or more of the SAME round with the SAME bow to monitor your progress."; break;
        default:                            string = nil; break;
    }
    
    return string;
}

@end
