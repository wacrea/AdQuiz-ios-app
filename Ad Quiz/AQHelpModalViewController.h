//
//  AQHelpModalViewController.h
//
//  Created by William AGAY on 1/31/13.
//  Copyright (c) 2013 William AGAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AQHelpModalViewController : UIViewController{
    NSString *help;
    IBOutlet UILabel *help_label;
}

@property (nonatomic, retain) NSString *help;
@property (nonatomic, retain) IBOutlet UILabel *help_label;

@end
