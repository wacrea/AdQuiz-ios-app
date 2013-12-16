//
//  AQSettingsViewController.h
//  Ad Quiz
//
//  Created by William Agay on 5/21/13.
//  Copyright (c) 2013 William AGAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface AQSettingsViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

- (IBAction)Restore:(id)sender;
- (IBAction)website:(id)sender;
- (IBAction)contact:(id)sender;

@end
