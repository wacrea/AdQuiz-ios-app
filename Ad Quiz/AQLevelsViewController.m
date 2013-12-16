//
//  AQLevelsViewController.m
//  Ad Quiz
//
//  Created by William AGAY on 28/01/13.
//  Copyright (c) 2013 William AGAY. All rights reserved.
//

#import "AQLevelsViewController.h"

#import "GCPagedScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "SFHFKeychainUtils.h"

#import "AQGameModalViewController.h"
#import "AQSettingsViewController.h"

@interface AQLevelsViewController ()

    @property (nonatomic, readonly) GCPagedScrollView* scrollView;

    - (UIView*) createViewAtIndex:(NSUInteger) index;

@end

#define kStoredData @"com.williamagay.adquiz.fr.service"

@implementation AQLevelsViewController

@synthesize data_json, levels;
@synthesize gamesInLevel;
@synthesize jsonAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(BOOL)IAPItemPurchased {

    NSError *error = nil;
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:@"aq_unlock" andServiceName:kStoredData error:&error];
    
    if ([password isEqualToString:@"unlocked"]) return YES; else return NO;
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    GCPagedScrollView* scrollView = [[GCPagedScrollView alloc] initWithFrame:self.view.frame];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.247 green:0.729 blue:0.851 alpha:1.0];
    
    // Get json data
    NSString* path_json = [[NSBundle mainBundle] pathForResource:@"data_game" ofType:@"json"];
    NSString* json = [NSString stringWithContentsOfFile:path_json
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    data_json = [parser objectWithString:json error:nil];
    
    levels = [data_json valueForKey:@"levels"];
}

- (void)viewWillAppear:(BOOL)animated{
    [self refreshView];
}

- (void)refreshView{
    // Load and reload .plist data
    [self.scrollView removeAllContentSubviews];
    
    for (NSUInteger index = 0; index < [levels count]; index ++) {
        [self.scrollView addContentSubview:[self createViewAtIndex:index]];
    }
    
    // Show current page
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"currentPage.plist"];
    
    NSMutableDictionary *tmpCurrentPage = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    int pageNumber = [[tmpCurrentPage valueForKey:@"number"] intValue];
    if(pageNumber != 0){
        [self.scrollView switchPageCode:pageNumber];
    }
}

- (GCPagedScrollView *)scrollView {
    return (GCPagedScrollView*) self.view;
}

- (UIView *)createViewAtIndex:(NSUInteger)index {
    
    UIView* view = [[UIView alloc] init];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (screenSize.height > 480.0f) {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width - 20,
                                self.view.frame.size.height - 210);
    } else {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width - 20,
                                self.view.frame.size.height - 120);
    }

    view.backgroundColor = [UIColor colorWithRed:0.325 green:0.757 blue:0.863 alpha:1.0];
    view.layer.cornerRadius = 4;
    
    UIImageView *logo_head       = [[UIImageView alloc] initWithFrame:CGRectMake(80, -80, 140, 70)];
    logo_head.image              = [UIImage imageNamed:@"head_levels"];
    [view addSubview:logo_head];
    
    NSUInteger currentLevelReel = index + 1;
    
    UILabel* levelName = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 140, 30)];
    levelName.text = [NSString stringWithFormat:@"Niveau %d", currentLevelReel];
    levelName.backgroundColor = [UIColor clearColor];
    levelName.textColor = [UIColor whiteColor];
    levelName.font = [UIFont fontWithName:@"Fineness" size:20];
    levelName.textAlignment = NSTextAlignmentCenter;
    [view addSubview:levelName];
    
    // Check if the level is available
    /*if ([self IAPItemPurchased] | (currentLevelReel <= 2)) {*/
    
    gamesInLevel = [levels objectAtIndex:index];
    gamesInLevel = [gamesInLevel valueForKey:@"games"];
    
    NSUInteger y = 50;
    NSUInteger x = 9;
    
    NSUInteger indexReel = 0;
    NSUInteger indexRow = 0;
    
    // If plist exists
    BOOL plistExists;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[[NSString stringWithFormat: @"%d", currentLevelReel - 1] stringByAppendingString:@"_level.plist"]];
    plistExists = [fileManager fileExistsAtPath:path];
    
    NSMutableDictionary *tempDictPlist;
    
    if(plistExists == NO)
    {
        tempDictPlist = [[NSMutableDictionary alloc] init];
    }
    else{
        tempDictPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
        
    for (NSUInteger index = 0; index < [gamesInLevel count]; index ++) {
        
        indexReel = index + 1;
        
        // Add in the plist
        if(plistExists == NO)
        {
            [tempDictPlist setValue:@"0" forKey:[NSString stringWithFormat:@"%d", index]];
        }
        
        if(indexReel > 1){
            if(indexReel < 5){
                x = 9 + 69 * index + 2 * index;
                // Marge de base à gauche, largeur d'un bouton multiplié par l'index plus la marge fois l'index non réel.
            }else if (indexReel < 9){
                y = 121;
                
                x = 9 + 69 * indexRow + 2 * indexRow;
                
                indexRow = indexRow + 1;
            }else if (indexReel == 9){
                indexRow = 0;
            }
            if (indexReel > 8 && indexReel < 13){
                y = 192;
                
                x = 9 + 69 * indexRow + 2 * indexRow;
                
                indexRow = indexRow + 1;
            }
            
            if (indexReel == 13){
                indexRow = 0;
            }
            if (indexReel > 12 && indexReel < 17){
                y = 263;
                
                x = 9 + 69 * indexRow + 2 * indexRow;
                
                indexRow = indexRow + 1;
            }
        }
        
        UIButton *gamePlay = [[UIButton alloc] init];
        
        [[gamePlay layer] setValue:[NSString stringWithFormat:@"%d", index] forKey:@"game"];
        [[gamePlay layer] setValue:[NSString stringWithFormat:@"%d", currentLevelReel - 1] forKey:@"level"];
        
        [gamePlay                            addTarget:self
                                                action:@selector(Play:)
                                         forControlEvents:UIControlEventTouchUpInside];
        [gamePlay                            setTitle:[NSString stringWithFormat:@"%d", indexReel]
                                                forState:UIControlStateNormal];
        gamePlay.frame                           = CGRectMake(x, y, 69, 69);
        gamePlay.backgroundColor                 = [UIColor clearColor];
        
        if ([[tempDictPlist valueForKey:[NSString stringWithFormat:@"%d", index]] isEqualToString:@"1"]) {
            gamePlay.backgroundColor = [UIColor colorWithRed:0.165 green:0.671 blue:0.063 alpha:0.7];
        }
        else{
            [gamePlay                            setBackgroundImage:[UIImage imageNamed:@"opacity.png"]
                                                           forState:UIControlStateNormal];
            [gamePlay                            setBackgroundImage:[UIImage imageNamed:@"opacity_x2.png"]
                                                           forState:UIControlStateHighlighted];
        }
        
        [view addSubview:gamePlay];
    }
    
    // Write plist
    if(plistExists == NO)
    {
        [tempDictPlist writeToFile:path atomically: YES];
    }
        
    /*} // And if level available
    
    else{
        // Sorry, level not available
        
        // Lock page
        UIImageView *lock = [[UIImageView alloc] initWithFrame:CGRectMake(25, 53, 250, 194)];
        lock.image = [UIImage imageNamed:@"lock"];
        [view addSubview:lock];
        
        UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsButton addTarget:self
                           action:@selector(SettingsView:)
                 forControlEvents:UIControlEventTouchDown];
        [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
        settingsButton.frame = CGRectMake(260, 10, 30, 30);
        [settingsButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
        [view addSubview:settingsButton];
        
        // Lock button
        UIButton *buttonBuyAQ = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonBuyAQ addTarget:self
                   action:@selector(purchaseUnlock:)
         forControlEvents:UIControlEventTouchUpInside];
        [buttonBuyAQ setTitle:@"Débloquer le reste du jeu" forState:UIControlStateNormal];
        [buttonBuyAQ setTitleColor:[UIColor colorWithRed:0.325 green:0.757 blue:0.863 alpha:1.0] forState:UIControlStateHighlighted];
        buttonBuyAQ.backgroundColor = [UIColor colorWithRed:0.298 green:0.831 blue:0.961 alpha:1];
        buttonBuyAQ.layer.cornerRadius = 4;
        buttonBuyAQ.frame = CGRectMake(0, 260, 300, 80);
        [view addSubview:buttonBuyAQ];
    }*/
        
    return view;
}

- (void)purchaseUnlock:(id)sender {
    
    // Check the UDID now...
    
    
    NSString *postString = [@"send_udid=" stringByAppendingString:@"empty"];
        
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://adquiz.williamagay.com/api.php"]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    jsonAPI = nil;
    jsonAPI = [parser objectWithString:jsonString error:nil];
        
    int statusAPIudid = [[jsonAPI valueForKey:@"agreement"] intValue];
        
    if(statusAPIudid == 0){
        if ([SKPaymentQueue canMakePayments]) {
            
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"aq_unlock"]];
            
            request.delegate = self;
            [request start];
            
        } else {
            
            UIAlertView *tmp = [[UIAlertView alloc]
                                initWithTitle:@"Prohibited"
                                message:@"Achat impossible, peut être le contrôle parental ?"
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:@"Ok", nil];
            
            [tmp show];
        }
    }
    else{
        [SFHFKeychainUtils storeUsername:@"aq_unlock" andPassword:@"unlocked" forServiceName:kStoredData updateExisting:YES error:nil];
        [self refreshView];
    }
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            /*case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"Processing");
                break;
            }*/
            case SKPaymentTransactionStatePurchased:
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //NSLog(@"Done !");
                UIAlertView *tmp = [[UIAlertView alloc]
                                    initWithTitle:@"Débloqué"
                                    message:@"Vous avez débloqué AdQuiz"
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Ok", nil];
                [tmp show];
                
                
                NSError *error = nil;
                
                // Enregistrer achat.
                [SFHFKeychainUtils storeUsername:@"aq_unlock" andPassword:@"unlocked" forServiceName:kStoredData updateExisting:YES error:&error];
                
                // Rafraichir la vue
                [self refreshView];
                
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    //NSLog(@"Error payment cancelled");
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //NSLog(@"Failed");
                break;
            }
            default:
                break;
        }
    }
}






-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
        
    SKProduct *validProduct = nil;
    int count = [response.products count];
    
    if (count>0) {
        validProduct = [response.products objectAtIndex:0];
        
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"aq_unlock"];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Non disponible"
                            message:@"Rien à débloquer"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
    
    
}

/*-(void)requestDidFinish:(SKRequest *)request
{
    
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
}*/

- (void)Play:(id)sender {
    NSString *game = [[sender layer] valueForKey:@"game"];
    NSString *level = [[sender layer] valueForKey:@"level"];
    NSArray *level_data = [levels objectAtIndex:[level integerValue]];
    NSArray *games_data = [level_data valueForKey:@"games"];
    NSArray *THISGameData = [games_data objectAtIndex:[game integerValue]];
    
    // Call modal view
    AQGameModalViewController *gameController = [[AQGameModalViewController alloc] init];
    gameController.levelNumber = level;
    gameController.THISGameData = THISGameData;
    gameController.gameNumber = [NSString stringWithFormat:@"%d", [game intValue] + 1];
    UINavigationController *gameNavController = [[UINavigationController alloc] initWithRootViewController:gameController];
    [gameNavController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:gameNavController animated:YES completion:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"currentPage.plist"];
    
    NSMutableDictionary *tmpCurrentPage = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [tmpCurrentPage setValue:[NSNumber numberWithInt:[level intValue]] forKey:@"number"];
    [tmpCurrentPage writeToFile:path atomically: YES];
}

- (void) SettingsView:(id)sender{
    // Call modal view
    AQSettingsViewController *settingsController = [[AQSettingsViewController alloc] init];
    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    [settingsNavController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:settingsNavController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
