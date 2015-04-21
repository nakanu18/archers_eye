//
//  IAPHelper.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/2/12.
//  Copyright (c) 2012 Playhaven. All rights reserved.
//
// Modified to hell by Derek! Boo-ya!
//

#import "IAPHelper.h"

@interface NSObject (hash)

- (NSString *)hashString;

@end

@implementation NSObject (hash)

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (NSString *)hashString
{
    return [NSString stringWithFormat:@"%ld", [self hash]];
}

@end












@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end

@implementation SKProduct (LocalizedPrice)

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    
    return [numberFormatter stringFromNumber:self.price];
}

@end












@implementation IAPHelper

static IAPHelper *instance;

#pragma mark singleton stuff

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
+ (IAPHelper *)sharedInstance
{
    @synchronized( [IAPHelper class] )
	{
		if( !instance )
             instance = [[IAPHelper alloc] init];
        
		return instance;
	}
    
	return nil;
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
+ (id)alloc
{
	@synchronized( [IAPHelper class] )
	{
		NSAssert( instance == nil, @"Attempted to allocate a second instance of IAPHelper" );
		return [super alloc];
	}
    
	return nil;
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (id)init
{
	self = [super init];

    if( self != nil )
    {
        _pendingPurchases = [[NSMutableDictionary alloc]init];
        _pendingRequests  = [[NSMutableDictionary alloc]init];
        
        //register for store kit callbacks
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
	return self;
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)dealloc
{
    // Should never be called, but just here for clarity really.
    [_pendingPurchases removeAllObjects], _pendingPurchases = nil;
    [_pendingRequests  removeAllObjects], _pendingRequests = nil;
    
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)setPurchaseDelegate:(id)delegate andSelector:(SEL)selector
{
    purchaseDelegate = delegate;
    purchaseSelector = selector;
}












#pragma mark IAP Functions

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)startPurchase:(NSString *)productID
{
    // The first step is requesting product information for this purchase.
    if( productID )
    {
        NSSet *productIdentifiers = [NSSet setWithObject:productID];
        
        self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];

        NSLog( @"Attempting to purchase: %@", productID );
        
         self.request.delegate = self;
        [self.request start];
        
        //storing the purchase and the product request to retrieve later
        [self.pendingRequests setValue:productID forKey:[self.request hashString]];
    }
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)restorePurchases
{
    NSLog( @"Attempting to restore purchases..." );
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    restoreSuccess = false;
}












#pragma mark Store Kit Delegate Functions

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSString    *key        = [request hashString];
    NSString    *purchase   = [self.pendingRequests valueForKey:key];
    NSArray     *products   = response.products;
    SKProduct   *product    = [products count] == 1 ? [products objectAtIndex:0] : nil;
    
    NSArray *skProducts = response.products;
    for( SKProduct *skProduct in skProducts )
    {
        NSLog( @"Found product: %@ %@ %0.2f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue );
    }

//    NSArray * skInvalidProducts = response.invalidProductIdentifiers;
//    for (SKProduct * skProduct in skInvalidProducts)
//    {
//        NSLog(@"Found invalid product: %@ %@ %0.2f",
//              skProduct.productIdentifier,
//              skProduct.localizedTitle,
//              skProduct.price.floatValue);
//    }
    
    if( [purchase isEqualToString:product.productIdentifier] ) //did we request this purchase?
    {
       //create a payment for this request
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        //send the payment through
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        //add this purchase to our pending requests for later retrieval
        [self.pendingRequests setValue:purchase forKey:[payment hashString]];
        
    }
    else
    {
        //either the purchase or the product request is invalid, report as an error
        NSLog( @"Invalid purchase request:%@", product.productIdentifier );
    }
    
    //either way clean up the stored request
    [self.pendingRequests removeObjectForKey:key];
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                    message:@"Cannot connect to iTunes store."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog( @"Store response received..." );
  
    for( SKPaymentTransaction *transaction in transactions )
    {
        NSString *key = [transaction.payment hashString];
        NSString *purchase = [self.pendingRequests valueForKey:key];
        
        [self.pendingPurchases removeObjectForKey:key];
        
        switch( transaction.transactionState )
        {
            case SKPaymentTransactionStatePurchased:
                [self CompleteTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self RestoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self FailedTransaction:transaction wasRestoreAttempt:purchase != nil];//if we didn't have a pending request for this transaction, it is the result of attempting to restore the purchases... if we failed at restoring purchases, they haven't purcahsed anything!
                break;
            default:
                break;
        }
    }
}












#pragma mark TRANSACTION COMPLETION

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)CompleteTransaction:(SKPaymentTransaction *)transaction
{
    NSLog( @"CompleteTransaction..." );
    NSLog( @"IAPHelper: Purchased %@!", transaction.payment.productIdentifier );
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                    message:@"You have purchased the full game."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    //provide content
    [self ProvideContent:transaction.payment.productIdentifier];
    
    //finish transaction
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)FailedTransaction:(SKPaymentTransaction *)transaction wasRestoreAttempt:(BOOL)restoreAttempt
{
    NSLog( @"FailedTransaction..." );
    NSLog( @"IAPHelper: Failed to purchase %@!", transaction.payment.productIdentifier );
    if( restoreAttempt )
    {
        //failure pop up -- this is just a courtesy, not necessary
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Purchases"
                                                        message:@"No purchases were restored. Please check your iTunes purchase history."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];        
    }
    else
    {
        NSString *title = @"Failed Transaction";
        NSString *desc  = @"";
        
        switch( transaction.error.code )
        {
            case SKErrorPaymentCancelled:   desc = @"Payment cancelled."; break;
            case SKErrorUnknown:            desc = @"Unknown error has occurred."; break;
            case SKErrorClientInvalid:      desc = @"Not allowed to perform the transaction."; break;
            case SKErrorPaymentInvalid:     desc = @"Invalid payment parameter."; break;
            case SKErrorPaymentNotAllowed:  desc = @"Not allowed to authorize payments."; break;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:desc delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    //do whatever here --
    //possible error codes:
    //SKErrorPaymentCancelled
    //SKErrorUnknown
    //SKErrorClientInvalid
    //SKErrorPaymentInvalid
    //SKErrorPaymentNotAllowed
    
    //finish transaction
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)RestoreTransaction:(SKPaymentTransaction *)transaction
{
     NSLog( @"RestoreTransaction..." );
     NSLog( @"IAPHelper: Restored %@!", transaction.payment.productIdentifier );
    
    restoreSuccess = true;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Purchases"
                                                    message:@"Full game purchase has been restored."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    //give em what they came for
    [self ProvideContent:transaction.payment.productIdentifier];

    //finish transaction
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    if( !restoreSuccess )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Failed"
                                                        message:@"Attempt to restore in-app purchase failed."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if( error.code != SKErrorPaymentCancelled )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                        message:@"Cannot connect to iTunes store."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void)ProvideContent:(NSString *)productIdentifier
{
    //provide content from purchase depending on identifier
//    [[Player getCurrentPlayerData] setTitleUnlocked:YES];
//    [[Player getCurrentPlayerData] save];
    
    [purchaseDelegate performSelector:purchaseSelector];
}
@end
