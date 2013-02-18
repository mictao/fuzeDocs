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
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@property (nonatomic, strong) WebTopClient *wtClient;
@property (nonatomic, strong) NSUserDefaults *prefs;

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

    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.masksToBounds = YES;
    
    self.wtClient = [WebTopClient instance];
    self.prefs = [NSUserDefaults standardUserDefaults];
    
    self.username.delegate = self;
    self.password.delegate = self;
    self.message.text = nil;
    self.username.text = [self.prefs objectForKey:@"username"];
    self.urlHost.text = [self.prefs objectForKey:@"urlHost"];
    self.password.text = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    // for scrolling view when keyboard is shown. not working yet.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // for scrolling view when keyboard is hidden, not working yet.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void) keyboardWillShow: (NSNotification *) notification
{
//    [UIView beginAnimations:nil context:nil];
//    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect newRect = self.view.frame;
//    //Down size your text view
//    newRect.size.height -= endRect.size.height;
//    self.view.frame = newRect;
//    [UIView commitAnimations];
}

- (void) keyboarrdWillHide: (NSNotification *) notification
{

    
}

- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender
{
    [self doLogin];
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
        [self doLogin];
    }
    return YES;
}


- (void) doLogin
{
    self.wtClient.clientUrl = [NSString stringWithFormat:@"http://%@/",self.urlHost.text];
    NSString *result = [self.wtClient login: self.username.text password: self.password.text];
    
    [self.view endEditing:YES];
    
    if (result != nil)
    {
        self.message.text = result;
    }
    else
    {
        [self.prefs setValue:self.username.text forKey:@"username"];
        [self.prefs setValue:self.urlHost.text forKey:@"urlHost"];
        [self.prefs synchronize];
        
        [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
    }
}



@end
