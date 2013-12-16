//
//  AQLevelsViewController.h
//  Ad Quiz
//
//  Created by William AGAY on 28/01/13.
//  Copyright (c) 2013 William AGAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>  

@interface AQLevelsViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    NSMutableArray *data_json;
    NSMutableArray *levels;
    NSMutableArray *gamesInLevel;
    NSMutableArray *jsonAPI;
}

@property (nonatomic, retain) NSMutableArray *data_json;
@property (nonatomic, retain) NSMutableArray *levels;
@property (nonatomic, retain) NSMutableArray *gamesInLevel;
@property (nonatomic, retain) NSMutableArray *jsonAPI;

@end
