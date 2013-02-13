//
//  sbLogonViewController.m
//  Storyboard
//
//  Created by Adam Clark on 2013-02-12.
//  Copyright (c) 2013 Adam Clark. All rights reserved.
//

#import "sbLogonViewController.h"
#import "UserController.h"


@implementation sbLogonViewController

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
    
    _username.delegate = self;
    _password.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logonButtonPressed:(id)sender
{
    UserController *userController = [[UserController alloc] init];
    
    BOOL result = [userController loginToFuzeWithUsername:_username.text withPassword:_password.text forHost:@"http://biddernator.devtop.evoco.com"];
    
    if (result)
    {
        _message.text = @"Success: Logged in";
    }
    else
    {
        _message.text = @"Error: Not Logged in";
    }
}

- (IBAction)resetButtonPressed:(id)sender
{
    _password.text = nil;
    _username.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _username)
    {
        [textField resignFirstResponder];
        [_password becomeFirstResponder];
    }
    else if (textField == _password)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
