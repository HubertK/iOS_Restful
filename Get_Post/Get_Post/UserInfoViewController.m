//
//  UserInfoViewController.m
//  Get_Post
//
//  Created by Helene Brooks on 12/1/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "HTMLViewController.h"
#import "RepoDetailView.h"

@implementation UserInfoViewController
@synthesize company;
@synthesize location;
@synthesize following;
@synthesize followers;
@synthesize repos;
@synthesize email;
@synthesize user;
@synthesize avatar;
@synthesize containerView;
@synthesize loginName;
@synthesize logButton;
@synthesize repoConnection,infoConnection;

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(received:) name:@"PushHTMLView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedRepoInfo:) name:@"RepoInfoNotification" object:nil];
    [super viewDidLoad];
}
- (void)receivedRepoInfo:(NSNotification*)notification{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    RepoDetailView *controller = [story instantiateViewControllerWithIdentifier:@"RepoDetailViewController"];
    NSString *URL = [notification.userInfo valueForKey:@"repoURL"];
    NSLog(@"RepoInfo Notification sending URL:%@",URL);
    [controller dismissModalViewControllerAnimated:NO];
    [controller setURLString:URL];
    [self presentModalViewController:controller animated:YES];
}
- (void)received:(NSNotification*)notification{
    if (self.presentedViewController == self) {
        NSLog(@"USERINFO");
    }
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    HTMLViewController *controller = [story instantiateViewControllerWithIdentifier:@"HTMLViewController"];
    NSString *filename = [notification.userInfo valueForKey:@"filename"];
    [controller setFile:filename];
    NSLog(@"HTML in detail notification");
    
     if ([[notification.userInfo valueForKey:@"isText"]isEqualToNumber:[NSNumber numberWithBool:YES]]) {
    NSLog(@"Notification YES");
    NSString *content = [notification.userInfo valueForKey:@"content"];
   
    [controller setContent:content];
    
    [controller setIsText:YES];  
         
     }
    else if ([[notification.userInfo valueForKey:@"isText"]isEqualToNumber:[NSNumber numberWithBool:NO]]){
        NSLog(@"Notification NO");
        [controller setIsText:NO];
        [controller setImageData:[notification.userInfo valueForKey:@"content"]];
    }
    
    [self presentModalViewController:controller animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"savedPassword"] == YES) {
        [self.logButton setTitle:@"Sign Out"];
        [self loadUserInfo];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setCompany:nil];
    [self setLocation:nil];
    [self setFollowing:nil];
    [self setFollowers:nil];
    [self setRepos:nil];
    [self setEmail:nil];
    [self setUser:nil];
    [self setAvatar:nil];
    [self setContainerView:nil];
    [self setLogButton:nil];
    
    [self setLoginName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)logInOut:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"savedPassword"] == YES) {
        [defaults setBool:NO forKey:@"savedPassword"];
        [defaults removeObjectForKey:@"username"];
        [defaults removeObjectForKey:@"password"];
        UIAlertView *logOutAlert = [[UIAlertView alloc]initWithTitle:@"Logged Out" message:@"You have been signed out" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [logOutAlert show];
        [defaults synchronize];
        [self.logButton setTitle:@"Login"];
        [self resetInfo];
    
        
    }
    else{
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (IBAction)listRepositories:(id)sender {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([[defaults valueForKey:@"username"] length] == 0 || [[defaults valueForKey:@"password"] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Your not logged in" message:@"Please Login to see your Repositories" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSURL *oRequestUrl = [NSURL URLWithString:@"https://api.github.com/user/repos"];
    NSMutableURLRequest *oRequest = [[NSMutableURLRequest alloc] init];
    [oRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [oRequest setHTTPMethod:@"GET"];
    [oRequest setURL:oRequestUrl];
    
    self.repoConnection = [[NSURLConnection alloc]initWithRequest:oRequest delegate:self];
}




-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Response:%@",response);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:data 
                          options:kNilOptions 
                          error:&error];

    if (connection == self.repoConnection) {
        
      NSLog(@"Received Repo Data:%@",[json description]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AllReposNotification" object:nil userInfo:json];
       
         
    }
    
   else if (connection == self.infoConnection) {
       
        NSLog(@"Received Info Data:%@",[json description]);
       [self fillInInformation:json];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *eStr = [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Awww Shit!" message:eStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"Error:%@",[error localizedDescription]);
    //check the error domain and report errors back to the calling function via a delegate
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //perform any cleanup and notify the delegate of available data
}


-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    //return YES to say that we have the necessary credentials to access the requested resource
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{    
    NSLog(@"Authentication Challenge");
    NSString *username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];    
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:@"password"]; 
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceForSession];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
} 



- (void)loadUserInfo{
    NSURL *oRequestUrl = [NSURL URLWithString:@"https://api.github.com/user"];
    NSMutableURLRequest *iRequest = [[NSMutableURLRequest alloc] init];
    [iRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [iRequest setHTTPMethod:@"GET"];
    [iRequest setURL:oRequestUrl];
    
    self.infoConnection = [[NSURLConnection alloc]initWithRequest:iRequest delegate:self];
}


- (void)fillInInformation:(NSDictionary*)userInfo{
    self.user.text = [userInfo valueForKey:@"name"];
    self.email.text = [userInfo valueForKey:@"email"];
    self.followers.text = [[userInfo valueForKey:@"followers"]stringValue];
    self.following.text = [[userInfo valueForKey:@"following"]stringValue];
    self.company.text = [userInfo valueForKey:@"company"];
    self.location.text = [userInfo valueForKey:@"location"];
    self.loginName.text = [userInfo valueForKey:@"login"];
    self.repos.text = [[userInfo valueForKey:@"public_repos"]stringValue];
    NSString *avatarURLString = [userInfo valueForKey:@"avatar_url"];
    NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
    NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
    self.avatar.image = [UIImage imageWithData:avatarData];
}

- (void)resetInfo{
    self.user.text = nil;
    self.email.text = nil;
    self.followers.text = nil;
    self.following.text = nil;
    self.company.text = nil;
    self.location.text = nil;
    self.repos.text = nil;
    self.avatar.image = nil;
}











@end
