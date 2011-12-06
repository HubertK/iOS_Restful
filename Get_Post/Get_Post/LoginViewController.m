//
//  LoginViewController.m
//  Get_Post
//
//  Created by Helene Brooks on 12/1/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoViewController.h"

@implementation LoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize checkmark;
@synthesize spinner;
@synthesize username,password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"savedPassword"] == YES) {
        
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"username"]) {
        self.usernameField.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"]) {
        self.passwordField.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"password"];
    }
        
    }
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setCheckmark:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)savePassword:(id)sender {
    if ([self.checkmark isHidden] == YES) {
        [self.checkmark setHidden:NO];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"savedPassword"];
    }
    else{
        [self.checkmark setHidden:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"savedPassword"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)loginInWithCredentials:(id)sender {
    self.password = self.passwordField.text;
    self.username = self.usernameField.text;
    if ([self.username length] <= 0) {
        NSLog(@"No Username was Entered");
        
    }
    if ([self.password length] <= 0) {
        NSLog(@"No Password was Entered");
    }
    if ([self.password length] > 0 && [self.username length] > 0) {
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.username forKey:@"username"];
    [defaults setValue:self.password forKey:@"password"];
    [defaults synchronize];
    }
    [self loggedIn];
}

- (IBAction)signUpForGithubAccount:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://github.com/plans"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}



#pragma Mark UITextFieldDelegate Protocol
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)loggedIn{
   
    [self.navigationController popToRootViewControllerAnimated:YES];
}




























@end
