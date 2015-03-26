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

typedef enum
{
    eRoundCategory_None,
    eRoundCategory_Custom,
    eRoundCategory_Common,
    eRoundCategory_Past,
} eRoundCategory;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSInteger       _currBowID;
    eRoundCategory  _currRoundCategory;
    NSInteger       _currRoundID;
}

@property (nonatomic, strong)   UIWindow        *window;
@property (strong)              RoundInfo       *liveRound;
@property (strong)              NSMutableArray  *customRounds;
@property (strong)              NSMutableArray  *commonRounds;
@property (strong)              RoundInfo       *currRound;
@property (strong)              NSMutableArray  *pastRounds;
@property (strong)              BowInfo         *currBow;
@property (strong)              NSMutableArray  *allBows;






- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate;
- (void)endLiveRoundAndDiscard;
- (void)endLiveRoundAndSave;

// Generic
- (void)createNewCustomRound:(RoundInfo *)newRound;
- (void)selectRound:(NSInteger)ID andCategory:(eRoundCategory)category;
- (void)endCurrRoundAndDiscard;
- (void)endCurrRoundAndSave;

- (void)createNewCurrBow:(BowInfo *)newBow;
- (void)selectBow:(NSInteger)bowID;
- (void)saveCurrBow;
- (void)discardCurrBow;

+ (NSString *)basicDate:(NSDate *)date;

@end

