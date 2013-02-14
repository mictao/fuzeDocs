//
//  LoginViewController.m
//  Evoco Docs
//
//  Created by Adam Clark on 2013-02-13.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import "LoginViewController.h"
#import "WebTopClient.h"
#import "LAPTableViewController.h"

@interface LoginViewController ()

@property WebTopClient *wtClient;

@end


@implementation LoginViewController


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
    
    self.username.delegate = self;
    self.password.delegate = self;
    self.message.text = nil;
    self.username.text = nil;
    self.password.text = nil;
    
    self.wtClient = [[WebTopClient alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logonButtonPressed:(id)sender
{
    self.wtClient.clientUrl = [NSString stringWithFormat:@"http://%@",self.urlHost.text];
    NSString *result = [self.wtClient login: self.username.text password: self.password.text];
    
    if (result != nil)
    {
        _message.text = result;
        [self.view endEditing:YES];
    }
    else
    {
        [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
    }

}
    
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
        LAPTableViewController *dest = segue.destinationViewController;
        [dest setWebTopClient: self.wtClient];
    }

- (IBAction)resetButtonPressed:(id)sender
{
    self.password.text = nil;
    self.username.text = nil;
    self.message.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.username)
    {
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    else if (textField == self.password)
    {
        [textField resignFirstResponder];
        [self becomeFirstResponder];
        [self.logonButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    return YES;
}



@end
