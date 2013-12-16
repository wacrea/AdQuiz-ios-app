//
//  AQSettingsViewController.m
//  Ad Quiz
//
//  Created by William Agay on 5/21/13.
//  Copyright (c) 2013 William AGAY. All rights reserved.
//

#import "AQSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SFHFKeychainUtils.h"

@interface AQSettingsViewController ()

@end

@implementation AQSettingsViewController

#define kStoredData @"com.williamagay.adquiz.fr.service"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = @"Paramètres";
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleLabel setFont:[UIFont fontWithName:@"Fineness" size:25.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [self.navigationItem setTitleView:titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.247 green:0.729 blue:0.851 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.325 green:0.757 blue:0.863 alpha:1.0];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"Retour" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1] forState:UIControlStateHighlighted];
    closeButton.titleLabel.font = [UIFont fontWithName:@"Fineness" size:14.0f];
    [closeButton.layer setCornerRadius:4.0f];
    [closeButton.layer setMasksToBounds:YES];
    [closeButton.layer setBorderWidth:0.5];
    [closeButton.layer setBorderColor: [[UIColor clearColor] CGColor]];
    closeButton.frame=CGRectMake(0.0, 100.0, 55.0, 30.0);
    [closeButton addTarget:self action:@selector(Close) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = btnClose;
}

- (void)Close
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Restore:(id)sender {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    /*NSLog(@"Restore completed transactions finished.");
    NSLog(@" Number of transactions in queue: %d", [[queue transactions] count]);
    for (SKPaymentTransaction *trans in [queue transactions])
    {
        NSLog(@" transaction id %@ for product %@.", [trans transactionIdentifier], [[trans payment] productIdentifier]);
        NSLog(@" original transaction id: %@ for product %@.", [[trans originalTransaction] transactionIdentifier],
              [[[trans originalTransaction] payment]productIdentifier]);
    }*/
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:@"Niveaux restaurés !"
                        message:@"Vos achats ont étés restaurés"
                        delegate:self 
                        cancelButtonTitle:nil 
                        otherButtonTitles:@"OK", nil]; 
    [tmp show];
    
    // Enregistrer achat.
    [SFHFKeychainUtils storeUsername:@"aq_unlock" andPassword:@"unlocked" forServiceName:kStoredData updateExisting:YES error:nil];
    
}

- (IBAction)website:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://adquiz.williamagay.com"]];
}

- (IBAction)contact:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://williamagay.com/contact"]];
}

@end
