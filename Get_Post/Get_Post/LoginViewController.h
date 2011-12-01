//
//  LoginViewController.h
//  Get_Post
//
//  Created by Helene Brooks on 12/1/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
- (IBAction)savePassword:(id)sender;
- (IBAction)loginInWithCredentials:(id)sender;
- (IBAction)signUpForGithubAccount:(id)sender;
@end
