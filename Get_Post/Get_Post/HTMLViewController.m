//
//  HTMLViewController.m
//  Get_Post
//
//  Created by Helene Brooks on 12/5/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "HTMLViewController.h"

@implementation HTMLViewController
@synthesize filename;
@synthesize spinner;
@synthesize myImageView;
@synthesize myWebView,address,content,file,imageData,isText;

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
-(void)received:(NSNotification*)notification{
 //   UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  //  HTMLViewController *controller = [story instantiateViewControllerWithIdentifier:@"HTMLViewController"];
    NSString *newfilename = [notification.userInfo valueForKey:@"filename"];
//    [controller setFile:newfilename];
    self.filename.text = newfilename;
    NSLog(@"HTML in HTML notification");
    
    if ([[notification.userInfo valueForKey:@"isText"]isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSLog(@"Notification YES");
        NSString *newcontent = [notification.userInfo valueForKey:@"content"];
        self.content = newcontent;
 //       [controller setContent:newcontent];
        self.isText = YES;
        NSLog(@"IS TEXT!");  
        
        [self.myWebView setHidden:NO];
        [self.myImageView setHidden:YES];

        [self reloadWeb:self.content];
  //      [controller setIsText:YES];  
        
    }
    else if ([[notification.userInfo valueForKey:@"isText"]isEqualToNumber:[NSNumber numberWithBool:NO]]){
        NSLog(@"Notification NO");
     //   [controller setIsText:NO];
        self.isText = NO;
   //     [controller setImageData:[notification.userInfo valueForKey:@"content"]];
        self.imageData = [notification.userInfo valueForKey:@"content"];
        
        [self.myWebView setHidden:YES];
        [self.myImageView setHidden:NO];
        self.myImageView.image = [UIImage imageWithData:self.imageData];

    }
    
    
    
       
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{  
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(received:) name:@"PushHTMLView" object:nil];
     [self.spinner startAnimating];
//    self.myWebView.scrollView.layer.cornerRadius = 20;
//    self.myWebView.layer.cornerRadius = 20;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationReceived:) name:@"DismisstheView" object:nil];
    if (isText == YES) {
        NSLog(@"IS TEXT!");  
    self.filename.text = self.file;
//    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.address]]]; 
    [self reloadWeb:self.content];
    }
    if (isText == NO) {
        NSLog(@"NOT TEXT");
        self.filename.text = self.file;
        [self.myWebView setHidden:YES];
        [self.myImageView setHidden:NO];
        self.myImageView.image = [UIImage imageWithData:self.imageData];
        [self.spinner stopAnimating];
    }
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
      [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setMyWebView:nil];
    [self setFilename:nil];
    [self setMyImageView:nil];
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
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    if ([self.content length] <= 0) {
//        self.content = [myWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
//        [self reloadWeb:self.content];
//    }
//    
//    
//}

- (void)reloadWeb:(NSString*)aString{
    NSLog(@"Content=%@",aString);
    NSString *htmlstring = [NSString stringWithFormat:@"<html><head><link href=\"prettify.css\" type=\"text/css\" rel=\"stylesheet\" /><script type=\"text/javascript\" src=\"prettify.js\"></script></head><body onload=\"prettyPrint()\"><pre class=\"prettyprint\">%@</pre></html>",aString];
    
    //    NSString *htmlstring2 = [NSString stringWithFormat:@"<html><head><link href='http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.css' rel='stylesheet' type='text/css'/><script src='http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.js' type='text/javascript'/></head><body>onload=\"prettyPrint()\" </body><pre class=\"prettyprint\">%@</pre></html>",aString];
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [myWebView loadHTMLString:htmlstring baseURL:baseURL];
    [self.spinner stopAnimating];
}

- (void)notificationReceived:(NSNotification*)ntification{
    [self dismissModalViewControllerAnimated:NO];
}

@end
