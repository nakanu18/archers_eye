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
    self.roundTemplates = [NSMutableArray new];
    self.pastRounds     = [NSMutableArray new];
    self.allBows        = [NSMutableArray new];
    _currBowID          = -1;

    
    
    RoundInfo *fita600Round = [[RoundInfo alloc] initWithName:@"FITA 600" andDate:nil andNumEnds:20 andArrowsPerEnd:3];
    RoundInfo *nfaa300Round = [[RoundInfo alloc] initWithName:@"NFAA 300" andDate:nil andNumEnds:12 andArrowsPerEnd:5];
    RoundInfo *shortRound   = [[RoundInfo alloc] initWithName:@"TEST 25"  andDate:nil andNumEnds:1  andArrowsPerEnd:5];
    [_roundTemplates addObject:fita600Round];
    [_roundTemplates addObject:nfaa300Round];
    [_roundTemplates addObject:shortRound];
    
    
    BowInfo *whiteFlute = [[BowInfo alloc] initWithName:@"White Flute" andType:eBowType_Barebow];
    BowInfo *blackPSE   = [[BowInfo alloc] initWithName:@"Black PSE"   andType:eBowType_Compound];
    [_allBows addObject:whiteFlute];
    [_allBows addObject:blackPSE];
    
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
        NSLog( @"Creating new live round" );
        self.liveRound = [roundTemplate copy];
    }
    else
        NSLog( @"Live round already exists" );
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
        [_pastRounds addObject:_liveRound];
        
        // Release the old live round
        self.liveRound = nil;
    }
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
        [_allBows addObject:_currBow];
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

@end
