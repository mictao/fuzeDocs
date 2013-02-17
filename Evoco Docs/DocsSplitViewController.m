//
//  DocsSplitViewController.m
//  fuze Docs
//
//  Created by Gabor Shaio on 2013-02-17.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import "DocsSplitViewController.h"

@interface DocsSplitViewController ()

@end

@implementation DocsSplitViewController

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
	// Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// this is not working
- (BOOL) splitViewController:(UISplitViewController *)svc
    shouldHideViewController:(UIViewController *)vc
               inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}

@end
