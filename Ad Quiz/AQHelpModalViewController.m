//
//  KNThirdViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "AQHelpModalViewController.h"
#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>

@interface AQHelpModalViewController ()

@end

@implementation AQHelpModalViewController
@synthesize help, help_label;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    help_label.text = help;
}

- (void)viewDidUnload {

  [super viewDidUnload];
}

@end
