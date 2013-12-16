//
//  AQGameModalViewController.h
//  Ad Quiz
//
//  Created by William AGAY on 31/01/13.
//  Copyright (c) 2013 William AGAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@class AQHelpModalViewController;

@interface AQGameModalViewController : UIViewController<UITextFieldDelegate, MWPhotoBrowserDelegate>{
    NSArray *THISGameData;
    NSString *gameNumber;
    NSString *levelNumber;
    NSString *currentType;
    NSString *help;
    
    // Good responses
    NSString *response_1;
    NSString *response_2;
    NSString *response_3;
    NSString *response_4;
    NSString *response_5;
    NSString *response_6;
    NSString *response_7;
    NSString *response_8;
    NSString *response_9;
    NSString *response_10;
    
    // Elements
    IBOutlet UILabel *slogan;
    IBOutlet UIImageView *pub_image;
    IBOutlet UITextField *response;
    
    AQHelpModalViewController * helpModal;
    
    IBOutlet UIActivityIndicatorView *loadingContent;
    
    NSArray *_photos;
}

@property (nonatomic, retain) NSArray *photos;

@property (nonatomic, retain) NSArray *THISGameData;
@property (nonatomic, retain) NSString *gameNumber;
@property (nonatomic, retain) NSString *levelNumber;
@property (nonatomic, retain) NSString *currentType;
@property (nonatomic, retain) NSString *help;

@property (nonatomic, retain) NSString *response_1;
@property (nonatomic, retain) NSString *response_2;
@property (nonatomic, retain) NSString *response_3;
@property (nonatomic, retain) NSString *response_4;
@property (nonatomic, retain) NSString *response_5;
@property (nonatomic, retain) NSString *response_6;
@property (nonatomic, retain) NSString *response_7;
@property (nonatomic, retain) NSString *response_8;
@property (nonatomic, retain) NSString *response_9;
@property (nonatomic, retain) NSString *response_10;

@property (nonatomic, retain) IBOutlet UILabel *slogan;
@property (nonatomic, retain) IBOutlet UIImageView *pub_image;
@property (nonatomic, retain) IBOutlet UITextField *response;

@property (nonatomic, retain) UIActivityIndicatorView *loadingContent;

- (IBAction)Help:(id)sender;

@end
