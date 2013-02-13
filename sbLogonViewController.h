//
//  sbLogonViewController.h
//  Storyboard
//
//  Created by Adam Clark on 2013-02-12.
//  Copyright (c) 2013 Adam Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sbLogonViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet UIButton *logonButton;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UILabel *message;

-(IBAction)logonButtonPressed:(id)sender;
-(IBAction)resetButtonPressed:(id)sender;


@end

