//
//  CommitsViewController.m
//  Get_Post
//
//  Created by Helene Brooks on 12/3/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "CommitsViewController.h"
#import "CommitCell.h"
#import "FilesViewController.h"
#import "ISO8601DateFormatter.h"

@implementation CommitsViewController
@synthesize commits,repo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
- (void)received:(NSNotification*)notif{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(received:) name:@"PopMaster" object:nil];
    self.title = @"Commits";
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pat.png"]];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [commits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommitCell";
    
    CommitCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CommitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.commiter.text = [[[commits valueForKey:@"committer"]valueForKey:@"name"] objectAtIndex:indexPath.row]; 
    cell.message.text = [[commits valueForKey:@"message"]objectAtIndex:indexPath.row];
    NSString *dString1 = [[[commits valueForKey:@"committer"]valueForKey:@"date"]objectAtIndex:indexPath.row];
    
//    
//    ISO8601DateFormatter *f = [[ISO8601DateFormatter alloc]init];
//    
//    NSDate *date = [f dateFromString:dString1];
//    
//    NSLog(@"date:%@",date);
//    ISO8601DateFormatter *f2 = [[ISO8601DateFormatter alloc] init];
//    [f2 setDefaultTimeZone:[NSTimeZone defaultTimeZone]];
//   
//    [f2 setFormat:ISO8601DateFormatCalendar];
//    NSString *s = [f2 stringFromDate:date];
   
    cell.date.text = [self getDate:dString1];
    return cell;
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getFilesFromURLatIndex:indexPath.section];
   
    }
- (void)getFilesFromURLatIndex:(NSInteger)index{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        NSString *URLString = [[[self.commits valueForKey:@"tree"]valueForKey:@"url"]objectAtIndex:index];
        NSURL *URL = [NSURL URLWithString:URLString];
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
    NSLog(@"\nFiles:%@",json);
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FilesViewController *controller = [story instantiateViewControllerWithIdentifier:@"FilesViewController"];
    [controller setFiles:[[json valueForKey:@"tree"]mutableCopy]];
    [controller setRepository:self.repo];
    [controller setSHA:[json valueForKey:@"sha"]];
    NSLog(@"Sending Repo:%@ to fileview",self.repo);
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSString*)getDate:(NSString*)dateString{
    ISO8601DateFormatter *f = [[ISO8601DateFormatter alloc]init];
    
    NSDate *date = [f dateFromString:dateString];
    
    NSLog(@"date:%@",date);
    ISO8601DateFormatter *f2 = [[ISO8601DateFormatter alloc] init];
    [f2 setDefaultTimeZone:[NSTimeZone defaultTimeZone]];
    
    [f2 setFormat:ISO8601DateFormatCalendar];
    [f2 setIncludeTime:YES];
    NSString *s = [f2 stringFromDate:date];
    NSLog(@"ISOformat:%@",s);
    NSDateFormatter *f3 = [[NSDateFormatter alloc] init];
    [f3 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *date2 = [f3 dateFromString:s];
    
    NSDateFormatter *f4 = [[NSDateFormatter alloc] init];
    [f4 setLocale:[NSLocale currentLocale]];
    [f4   setTimeZone:[NSTimeZone systemTimeZone]];
    [f4 setDateFormat:@"MMM,dd yyyy 'at' hh:mm a"];
    NSString *final = [f4 stringFromDate:date2];
    return final;
}


























@end
