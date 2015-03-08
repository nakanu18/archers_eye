//
//  AppDelegate.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *_roundScores;
}

@property (nonatomic, strong)   UIWindow        *window;
@property (nonatomic)           NSMutableArray  *roundScores;

@end

