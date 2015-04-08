//
//  Defines.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#pragma once

#if defined(DEBUG) || TARGET_IPHONE_SIMULATOR
//    #define DLog(s, ...) NSLog((@"%s " s), __PRETTY_FUNCTION__, ## __VA_ARGS__);
    #define DLog(s, ...) NSLog((@"" s), ## __VA_ARGS__);
#else
    #define DLog(s, ...) /* */
#endif

