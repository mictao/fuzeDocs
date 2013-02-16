//
//  LoginViewController.h
//  Evoco Docs
//
//  Created by Adam Clark on 2013-02-13.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) IBOutlet UITextField *urlHost;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *username;


@property (nonatomic, strong) IBOutlet UILabel *message;

- (IBAction)loginButtonPressed:(id)sender;

@end
