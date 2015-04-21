//
//  IAPHelper.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/2/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//
// Modified to hell by Derek! Boo-ya!

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    __weak id  purchaseDelegate;
    SEL        purchaseSelector;
    bool       restoreSuccess;
}

@property (nonatomic, readonly) NSMutableDictionary *pendingPurchases;
@property (nonatomic, readonly) NSMutableDictionary *pendingRequests;
@property (nonatomic, strong)   SKProductsRequest   *request;






+ (IAPHelper *)sharedInstance;

- (void)setPurchaseDelegate:(id)delegate andSelector:(SEL)selector;

- (void)startPurchase:(NSString *)productID;
- (void)restorePurchases;

@end
