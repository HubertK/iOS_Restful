//
//  RepoDetailView.m
//  Get_Post
//
//  Created by Helene Brooks on 12/7/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "RepoDetailView.h"
#import "HTMLViewController.h"

@implementation RepoDetailView
@synthesize repoName;
@synthesize repoDescription;
@synthesize publicPrivate;
@synthesize language;
@synthesize repoOwner;
@synthesize button1;
@synthesize URLString;
@synthesize icon;

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedRepoInfo:) name:@"RepoInfoNotification" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissNotificationReceived:) name:@"dismissView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(received:) name:@"PushHTMLView" object:nil];
    [self getinformation:self.URLString];
        [super viewDidLoad];
}

- (void)receivedRepoInfo:(NSNotification*)notification{
   
    NSString *URL = [notification.userInfo valueForKey:@"repoURL"];
    NSLog(@"RepoInfo Notification sending URL:%@",URL);
    [self getinformation:URL];
}
- (void)dismissNotificationReceived:(NSNotification*)notification{
    [self dismissModalViewControllerAnimated:NO];
}

-(void)received:(NSNotification*)notification{
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

- (void)viewDidUnload
{
    [self setRepoName:nil];
    [self setRepoDescription:nil];
    [self setPublicPrivate:nil];
    [self setLanguage:nil];
    [self setRepoOwner:nil];
    [self setButton1:nil];
    [self setIcon:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)listComments:(id)sender {
}










- (void)getinformation:(NSString*)repoURLString{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        
        NSURL *URL = [NSURL URLWithString:repoURLString];
        NSData *data = [NSData dataWithContentsOfURL:URL];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            [self fetchedData:data];
            
        });
    });
    
}
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData 
                          options:kNilOptions 
                          error:&error];
    if (error) {
        NSLog(@"ERROR:%@",[error localizedDescription]);
    }
    NSLog(@"INFORMATION:%@",json);
    NSString *rname = @"None";
    NSString *rdesc = @"No Description";
    NSString *rowner = @"None";
    NSString *rlang = @"None Specified";
    rname = [json valueForKey:@"name"];
    rdesc = [json valueForKey:@"description"];
    rowner = [[json valueForKey:@"owner"]valueForKey:@"login"];
    rlang = [json valueForKey:@"language"];
    if ([rname isKindOfClass:[NSNull class]] || [rname length] == 0) {
        rname = @"No Name Specified";
    }
    if ([rdesc isKindOfClass:[NSNull class]] || [rdesc length] == 0) {
        rdesc = @"No Description Specified";
    }
    if ([rowner isKindOfClass:[NSNull class]] || [rowner length] == 0) {
        rowner = @"No Name Specified";
    }
    if ([rlang isKindOfClass:[NSNull class]] || [rlang length] == 0) {
        rlang = @"No Language Specified";
    }
    self.repoName.text = rname;
    self.repoDescription.text = rdesc;
    self.repoOwner.text = rowner;
    self.language.text = rlang;
    NSInteger private = [[json valueForKey:@"private"]intValue];
    switch (private) {
        case 0:
            self.publicPrivate.text = @"Private";
            break;
        case 1:
            self.publicPrivate.text = @"Public";
            break;

            
        default:
            self.publicPrivate.text = @"";
            break;
    }
    if ([[[json valueForKey:@"owner"]valueForKey:@"avatar_url"]isKindOfClass:[NSNull class]]) {
        self.icon.image = [UIImage imageNamed:@"user-icon.png"];
    }
    else{
        [self getIconForUser:[[json valueForKey:@"owner"]valueForKey:@"avatar_url"]];
    }
   
}

- (void)getIconForUser:(NSString *)iconURL{
    if ([iconURL length] > 0) {
        
    NSURL *URL = [NSURL URLWithString:iconURL];
        NSData *iconData = [NSData dataWithContentsOfURL:URL];
        self.icon.image = [UIImage imageWithData:iconData];
        
        
    }
}

























@end
