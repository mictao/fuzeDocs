//
//  LoginViewController.h
//  Evoco Docs
//
//  Created by Adam Clark on 2013-02-13.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIButton *logonButton;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;

@property (nonatomic, strong) IBOutlet UITextField *urlHost;
@property (nonatomic, strong) IBOutlet UILabel *domain;

@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *username;


@property (nonatomic, strong) IBOutlet UILabel *message;

-(IBAction)logonButtonPressed:(id)sender;
-(IBAction)resetButtonPressed:(id)sender;

@end
