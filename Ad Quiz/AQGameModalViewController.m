//
//  AQGameModalViewController.m
//  Ad Quiz
//
//  Created by William AGAY on 31/01/13.
//  Copyright (c) 2013 William AGAY. All rights reserved.
//

#import "AQGameModalViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "MBHUDView.h"
#import "AQHelpModalViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface AQGameModalViewController ()

@end

@implementation AQGameModalViewController

@synthesize THISGameData;
@synthesize gameNumber, levelNumber;
@synthesize currentType, help;
@synthesize response_1, response_2, response_3, response_4, response_5, response_6, response_7, response_8, response_9, response_10;
@synthesize slogan, pub_image, response;
@synthesize loadingContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        helpModal = [[AQHelpModalViewController alloc] initWithNibName:@"AQHelpModalViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @autoreleasepool{
    
    NSString *title = @"Question ";
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleLabel setFont:[UIFont fontWithName:@"Fineness" size:25.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:[title stringByAppendingString:gameNumber]];
    [self.navigationItem setTitleView:titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.247 green:0.729 blue:0.851 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.325 green:0.757 blue:0.863 alpha:1.0];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"Fermer" forState:UIControlStateNormal];
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
    
    UIButton *buttonValid = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageValid = [UIImage imageNamed:@"valid.png"];
    [buttonValid setBackgroundImage:imageValid forState:UIControlStateNormal];
    [buttonValid setTitleColor:[UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1] forState:UIControlStateHighlighted];
    buttonValid.titleLabel.font = [UIFont fontWithName:@"Fineness" size:35.0f];
    [buttonValid.layer setCornerRadius:4.0f];
    [buttonValid.layer setMasksToBounds:YES];
    [buttonValid.layer setBorderWidth:0.5];
    [buttonValid.layer setBorderColor: [[UIColor clearColor] CGColor]];
    buttonValid.frame=CGRectMake(0.0, 100.0, 55.0, 30.0);
    [buttonValid addTarget:self action:@selector(Valid) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnValid = [[UIBarButtonItem alloc] initWithCustomView:buttonValid];
    self.navigationItem.rightBarButtonItem = btnValid;
    
    help = [THISGameData valueForKey:@"help"];
    
    // Good responses
    response_1 = [THISGameData valueForKey:@"response_1"];
    response_2 = [THISGameData valueForKey:@"response_2"];
    response_3 = [THISGameData valueForKey:@"response_3"];
    response_4 = [THISGameData valueForKey:@"response_4"];
    response_5 = [THISGameData valueForKey:@"response_5"];
    response_6 = [THISGameData valueForKey:@"response_6"];
    response_7 = [THISGameData valueForKey:@"response_7"];
    response_8 = [THISGameData valueForKey:@"response_8"];
    response_9 = [THISGameData valueForKey:@"response_9"];
    response_10 = [THISGameData valueForKey:@"response_10"];
    
    //////////////////////
    
    // Type of the current game
    currentType = [THISGameData valueForKey:@"type"];
    
    if ([currentType isEqualToString:@"slogan"]) {
        [pub_image setHidden:TRUE];
        slogan.text = [THISGameData valueForKey:@"content"];
    }
    else if ([currentType isEqualToString:@"image"]){
        [slogan setHidden:TRUE];
        
        // Detect touches
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [pub_image addGestureRecognizer:singleTap];
        [pub_image setUserInteractionEnabled:YES];
        
        // Load image in another thread
        [loadingContent startAnimating];
        [NSThread detachNewThreadSelector:@selector(LoadImagePub) toTarget:self withObject:nil];
    }
    
    // Response field
    response.returnKeyType                = UIReturnKeyDone;
    response.autocorrectionType           = UITextAutocorrectionTypeNo;
    response.keyboardType                 = UIKeyboardTypeDefault;
    response.clearButtonMode              = UITextFieldViewModeWhileEditing;
    response.tag                          = 1;
    response.delegate                     = self;
    
    // Set response if success
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[levelNumber stringByAppendingString:@"_level.plist"]];
    
    NSMutableDictionary *tmpPlistContent = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    // Get result
    NSString *currentResult = [tmpPlistContent valueForKey:[NSString stringWithFormat:@"%d", [gameNumber intValue] - 1]];
    
    if([currentResult intValue] == 1){
        response.text = response_1;
    }
    
    [response becomeFirstResponder];
        
    }
}

- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer {
    // Name without .png ext.
    NSString *fileName = [[THISGameData valueForKey:@"content"] stringByReplacingOccurrencesOfString:@".png" withString:@""];
    // Call zoom function
    [self zoomOnPicture:fileName];
}

- (void)LoadImagePub
{
    pub_image.image = [UIImage imageNamed:[THISGameData valueForKey:@"content"]];
    [loadingContent stopAnimating];
}

- (void)Close
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Cal Valid method
    [self Valid];
    
    return TRUE;
}

- (void)Valid
{
    NSString *userResponse = response.text;
    userResponse = [userResponse lowercaseString];
    
    int win = 0;
    
    #define CASE(str)                       if ([__s__ isEqualToString:(str)])
    #define SWITCH(s)                       for (NSString *__s__ = (s); ; )
    #define DEFAULT
        
    SWITCH (userResponse) {
        CASE (@"") {
            win = 0;
            break;
        }
        CASE (response_1) {
            win = 1;
            break;
        }
        CASE (response_2) {
            win = 1;
            break;
        }
        CASE (response_3) {
            win = 1;
            break;
        }
        CASE (response_4) {
            win = 1;
            break;
        }
        CASE (response_5) {
            win = 1;
            break;
        }
        CASE (response_6) {
            win = 1;
            break;
        }
        CASE (response_7) {
            win = 1;
            break;
        }
        CASE (response_8) {
            win = 1;
            break;
        }
        CASE (response_9) {
            win = 1;
            break;
        }
        CASE (response_10) {
            win = 1;
            break;
        }
        DEFAULT {
            win = 0;
            break;
        }
    }
    
    if (win == 1) {
        // Get .plist content
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[levelNumber stringByAppendingString:@"_level.plist"]];
        
        NSMutableDictionary *tmpPlistContent = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        //NSLog(@"%@", tmpPlistContent);
        // Save success
        [tmpPlistContent setValue:@"1" forKey:[NSString stringWithFormat:@"%d", [gameNumber intValue] - 1]];
        // Saving .plist
        [tmpPlistContent writeToFile:path atomically: YES];
        //NSLog(@"%@", tmpPlistContent);
        MBAlertView *alert = [MBAlertView alertWithBody:@"Bravo !" cancelTitle:nil cancelBlock:nil];
        [alert addButtonWithText:@"Continuer" type:MBAlertViewItemTypePositive block:^{
            [self Close];
        }];
        [alert addToDisplayQueue];
    }
    else{
        [MBHUDView hudWithBody:@"Faux" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.5 show:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(responseFirstResponder:) userInfo:nil repeats:NO];
    }
}

- (void)responseFirstResponder:(NSTimer *)timer {
    [response becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomOnPicture:(NSString *)picName
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    photo = [MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:picName ofType:@"png"]];
    [photos addObject:photo];
    self.photos = photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    UINavigationController *photosViewer = [[UINavigationController alloc] initWithRootViewController:browser];
    photosViewer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:photosViewer animated:YES completion:nil];
}

- (IBAction)Help:(id)sender {
    [response resignFirstResponder];
    helpModal.help = help;
    [self presentSemiViewController:helpModal];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

@end
