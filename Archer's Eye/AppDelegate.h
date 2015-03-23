//
//  AppDelegate.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundInfo.h"
#import "BowInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSUInteger _currBowID;
}

@property (nonatomic, strong)   UIWindow        *window;
@property (strong)              RoundInfo       *liveRound;
@property (strong)              NSMutableArray  *roundTemplates;
@property (strong)              NSMutableArray  *pastRounds;
@property (strong)              BowInfo         *currBow;
@property (strong)              NSMutableArray  *allBows;






- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate;
- (void)endLiveRoundAndDiscard;
- (void)endLiveRoundAndSave;

- (void)createNewCurrBow:(BowInfo *)newBow;
- (void)selectBow:(NSInteger)bowID;
- (void)saveCurrBow;
- (void)discardCurrBow;

- (NSString *)basicDate:(NSDate *)date;

@end

