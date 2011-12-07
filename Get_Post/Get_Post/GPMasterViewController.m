//
//  GPMasterViewController.m
//  Get_Post
//
//  Created by Helene Brooks on 11/30/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//
#define kCommits @"/repos/%@/%@/commits"
#import "GPMasterViewController.h"
#import "CommitsViewController.h"
#import "GPDetailViewController.h"

@implementation GPMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize repoDictionary,URLConnection,repoPicked;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtlePat1.png"]];
    self.repoDictionary = [[NSMutableDictionary alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allReposNotification:) name:@"AllReposNotification" object:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (GPDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
   
}

- (void)viewDidUnload
{
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
- (void)allReposNotification:(NSNotification*)notification{
    [self setTitle:@"Repositories"];
    for (int i = 0; i < [notification.userInfo count]; i++) {
        NSString *theName = [[notification.userInfo valueForKey:@"name"]objectAtIndex:i];;
        id description = [[notification.userInfo valueForKey:@"description"]objectAtIndex:i];
        if ([description isKindOfClass:[NSNull class]]) {
            description =(NSString*) @"No description";
        }
        [self.repoDictionary setValue:description forKey:theName];
    }
    [self.tableView reloadData];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.repoDictionary count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    NSString *keys = [[self.repoDictionary allKeys]objectAtIndex:indexPath.row];
    cell.textLabel.text = keys;
    cell.detailTextLabel.text = [self.repoDictionary valueForKey:keys];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *repository = cell.textLabel.text;
    self.repoPicked = repository;
    [self getCommitsForRepo:repository];
}

-(void)getCommitsForRepo:(NSString *)repo{
    NSString *user = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    NSString *URLString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/commits",user,repo];
    NSURL *oRequestUrl = [NSURL URLWithString:URLString];
    NSMutableURLRequest *oRequest = [[NSMutableURLRequest alloc] init];
    [oRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [oRequest setHTTPMethod:@"GET"];
    [oRequest setURL:oRequestUrl];
    
    self.URLConnection = [[NSURLConnection alloc]initWithRequest:oRequest delegate:self];
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
    NSLog(@"Received Data:%@",[json description]);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CommitsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CommitsViewController"];
    [controller setCommits:[[json valueForKey:@"commit"]mutableCopy]];
    [controller setRepo:self.repoPicked];
    NSLog(@"REPO:%@",self.repoPicked);
    [self.navigationController pushViewController:controller animated:YES];
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

















@end
