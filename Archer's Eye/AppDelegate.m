//
//  AppDelegate.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



//------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.commonRounds = [NSMutableArray new];
    self.pastRounds     = [NSMutableArray new];
    self.allBows        = [NSMutableArray new];
    _currBowID          = -1;
    _currRoundID    = -1;

    
    
    RoundInfo *fita600Round = [[RoundInfo alloc] initWithName:@"FITA 600" andType:eRoundType_FITA andNumEnds:20 andArrowsPerEnd:3];
    RoundInfo *nfaa300Round = [[RoundInfo alloc] initWithName:@"NFAA 300" andType:eRoundType_NFAA andNumEnds:12 andArrowsPerEnd:5];
    RoundInfo *shortRound   = [[RoundInfo alloc] initWithName:@"TEST 25"  andType:eRoundType_FITA andNumEnds:1  andArrowsPerEnd:5];
    [_commonRounds addObject:fita600Round];
    [_commonRounds addObject:nfaa300Round];
    [_commonRounds addObject:shortRound];
    
    
    BowInfo *whiteFlute = [[BowInfo alloc] initWithName:@"White Flute" andType:eBowType_Recurve andDrawWeight:28];
    BowInfo *blackPSE   = [[BowInfo alloc] initWithName:@"Black PSE"   andType:eBowType_Compound andDrawWeight:60];
    [_allBows addObject:whiteFlute];
    [_allBows addObject:blackPSE];
    
    [_pastRounds addObject:[shortRound copy]];
    [_pastRounds[0] setDate:[NSDate date]];
    
    // Override point for customization after application launch.
    return YES;
}




//------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the
    // application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}




//------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}




//------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive
    // state; here you can undo many of the changes made on entering the
    // background.
}




//------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}




//------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}





















#pragma mark - Live Rounds

//------------------------------------------------------------------------------
- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate
{
    if( _liveRound == nil )
    {
        self.liveRound      = [roundTemplate copy];
        self.liveRound.date = [NSDate date];
    }
}



//------------------------------------------------------------------------------
- (void)endLiveRoundAndDiscard
{
    // Release the old live round
    self.liveRound = nil;
}



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
- (void)createNewCustomRound:(RoundInfo *)newRound
{
    self.currRound      = newRound;
    _currRoundCategory  = eRoundCategory_Custom;
    _currRoundID        = -1;
}



//------------------------------------------------------------------------------
- (void)selectRound:(NSInteger)ID andCategory:(eRoundCategory)category
{
    NSMutableArray *roundArray;
    
    _currRoundCategory  = category;
    _currRoundID        = -1;
    
    // Select the array to use
    switch( _currRoundCategory )
    {
        case eRoundCategory_Custom: roundArray = nil;               break;
        case eRoundCategory_Common: roundArray = _commonRounds;     break;
        case eRoundCategory_Past:   roundArray = _pastRounds;       break;
        default:                    roundArray = nil;               break;
    }
    
    if( ID >= 0  &&  ID < [roundArray count] )
    {
        self.currRound  = [roundArray[ID] copy];
        _currRoundID    = ID;      // Save the ID so we can replace it later
    }
}



//------------------------------------------------------------------------------
- (void)endCurrRoundAndDiscard
{
    _currRoundCategory  = eRoundCategory_None;
    self.currRound      = nil;
    _currRoundID        = -1;
}



//------------------------------------------------------------------------------
- (void)endCurrRoundAndSave
{
    if( _currRoundCategory != eRoundCategory_None )
    {
        NSMutableArray *roundArray;
        
        // Select the array to use
        switch( _currRoundCategory )
        {
            case eRoundCategory_Custom: roundArray = nil;               break;
            case eRoundCategory_Common: roundArray = _commonRounds;     break;
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
- (void)createNewCurrBow:(BowInfo *)newBow
{
    self.currBow = newBow;
    _currBowID   = -1;
}



//------------------------------------------------------------------------------
- (void)selectBow:(NSInteger)bowID
{
    _currBowID = -1;

    if( bowID >= 0  &&  bowID < [_allBows count] )
    {
        // Make a copy so that we can discard the values easily if needed
        self.currBow = [_allBows[bowID] copy];
        _currBowID   = bowID;
    }
}



//------------------------------------------------------------------------------
- (void)saveCurrBow
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
    [self discardCurrBow];
}



//------------------------------------------------------------------------------
- (void)discardCurrBow
{
    self.currBow = nil;
    _currBowID   = -1;
}





















#pragma mark - Misc

//------------------------------------------------------------------------------
+ (NSString *)basicDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.locale    = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    return [dateFormatter stringFromDate:date];
}

@end
