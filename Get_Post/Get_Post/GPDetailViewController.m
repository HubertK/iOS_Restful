//
//  GPDetailViewController.m
//  Get_Post
//
//  Created by Helene Brooks on 11/30/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//
#define kRootURL @"https://api.github.com"//----------Root URL for GITHUB API
#define GitRepos @"/users/%@/repos"//-----------------Get all Repositories: ,username
#define GitCommits @"/repos/%@/%@/commits"//----Get Commit for repository: ,username,repo

#import "Base64.h"
#import "GPDetailViewController.h"

@interface GPDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation GPDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize URLString;
@synthesize nameField = _nameField;
@synthesize descriptionView = _descriptionView;
@synthesize URLConnection;
#pragma mark - Managing the detail item
bool isPrivate;
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSFileManager *filemgr;
    NSString *currentpath;
    NSArray *filelist;
    int count;
    int i;
    NSError *error;
    
    filemgr = [NSFileManager defaultManager];
    filelist = [filemgr contentsOfDirectoryAtPath:@"/tmp" error:&error];
    
    count = [filelist count];
    
    for (i = 0; i < count; i++)
        NSLog (@"%@", [filelist objectAtIndex: i]);

    
    self.URLString = [[NSMutableString alloc]initWithFormat:kRootURL];
    [self.URLString appendString:@"/user/repos"];
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    NSString *testData  = [NSString stringWithFormat:@"https://api.github.com/repos/HubertK/Dosage-Repo/git/blobs/1c236e284bf95d86440f9d6d8540d36e3a47407d"];//AddView from github repo commit
    NSURL *url = [NSURL URLWithString:testData];
    NSData *data = [NSData dataWithContentsOfURL:url];       // GET ACTUAL STRING 
    NSDictionary* json = [NSJSONSerialization                // FOR DISPLAY USING
                          JSONObjectWithData:data            // BASE  64 DECODING
                          options:kNilOptions                // YAY!!!!!!!!!!!!!!
                          error:&error];
    NSLog(@"Received Data:%@",[json description]);
   
    [Base64 initialize];
    NSString *base = [[json valueForKey:@"content"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData * data2 = [Base64 decode:base];
    NSString * actualString = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"Actual:%@",actualString);
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setDescriptionView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)changedPrivateSwitch:(id)sender {
    isPrivate = [sender isOn];
}

- (IBAction)sendRequestForNewRepository:(id)sender {
   
    NSString *theName = self.nameField.text;
    NSString *theDescription = self.descriptionView.text;
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:theName,@"name",theDescription,@"description", nil];
    
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON Output: %@", jsonString);
    
    
    NSURL *oRequestUrl = [NSURL URLWithString:@"https://api.github.com/user/repos"];
    NSMutableURLRequest *oRequest = [[NSMutableURLRequest alloc] init];
    [oRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [oRequest setHTTPMethod:@"POST"];
    [oRequest setURL:oRequestUrl];
    [oRequest setHTTPBody:jsonData];
     self.URLConnection = [[NSURLConnection alloc]initWithRequest:oRequest delegate:self];
    
//    NSError *oError = [[NSError alloc] init];
//    NSHTTPURLResponse *oResponseCode = nil;
//    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:oRequest returningResponse:&oResponseCode error:&oError];
    
    
}



-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Response:%@",response);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    //probably append the received data in a member variable
//    NSString * strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Received Data:%@",strResult);
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:data 
                          options:kNilOptions 
                          error:&error];
    NSLog(@"Received Data:%@",[json description]);
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
    NSLog(@"Auth");
    NSString *username;     //Add NSUserDefaults
    NSString *password;     //for username and password!!
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"hubertk" password:@"hbrooks16" persistence:NSURLCredentialPersistenceForSession];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
} 






















- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}





@end
