//
//  FilesViewController.m
//  Get_Post
//
//  Created by Helene Brooks on 12/3/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "FilesViewController.h"
#import "HTMLViewController.h"
#import "Base64.h"
#import "FileCell.h"

@implementation FilesViewController

@synthesize files,repository,SHA,filePicked;
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
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtlePat1.png"]];
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
    return [self.files count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    
    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *theFile = [[files valueForKey:@"path"]objectAtIndex:indexPath.section];
    cell.nameOfFile.text = theFile;
    NSString *type = [[files valueForKey:@"type"]objectAtIndex:indexPath.section];
    if ([type isEqualToString:@"tree"]) {
        cell.fileImage.image = [UIImage imageNamed:@"folder.png"];
        cell.fileType.text = nil;
    }
    else{
        cell.fileImage.image = [UIImage imageNamed:@"fileType.png"];;
        NSString *ext = [theFile pathExtension];
        cell.fileType.text = ext;
    }
    return cell;
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 52;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *sep = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seperator.png"]];
    return sep;
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
    
       NSString *type = [[files valueForKey:@"type"]objectAtIndex:indexPath.section];
    if ([type isEqualToString:@"tree"]) {
        self.filePicked = [[files valueForKey:@"path"]objectAtIndex:indexPath.section];
        [self getFilesFromURLatIndex:indexPath.section];
    }
    if ([type isEqualToString:@"blob"]) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissView" object:nil];
        NSString *content = [[files valueForKey:@"url"]objectAtIndex:indexPath.section];
        [self getContentBase64Data:content file:[[files valueForKey:@"path"]objectAtIndex:indexPath.section]];
        
    }
}

- (void)getFilesFromURLatIndex:(NSInteger)index{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        NSString *URLString = [[self.files valueForKey:@"url"]objectAtIndex:index];
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
//    self.files = [json valueForKey:@"tree"];
    self.SHA = [json valueForKey:@"sha"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FilesViewController *controller = [story instantiateViewControllerWithIdentifier:@"FilesViewController"];
    [controller setFiles:[[json valueForKey:@"tree"]mutableCopy]];
    [controller setRepository:self.repository];
    [controller setSHA:self.SHA];
    [controller setTitle:self.filePicked];
    [self.navigationController pushViewController:controller animated:YES];

}


- (void)getContentBase64Data:(NSString*)URL file:(NSString *)filename{
   
    NSString *treeSHA = self.SHA;
    NSString *user = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    NSString *repo = self.repository;
    
    BOOL isText = [self checkIfText:treeSHA username:user repo:repo file:filename];
    NSLog(@"istext:%d",isText);
    NSError *error = nil;
    NSString *testData  = URL;  //AddView from github repo commit
    NSURL *url = [NSURL URLWithString:testData];
    NSData *data = [NSData dataWithContentsOfURL:url];       // GET ACTUAL STRING 
    NSDictionary* json = [NSJSONSerialization                // FOR DISPLAY USING
                          JSONObjectWithData:data            // BASE  64 DECODING
                          options:kNilOptions                // YAY!!!!!!!!!!!!!!
                          error:&error];
  //  NSLog(@"Received Data:%@",[json description]);
    
    [Base64 initialize];
    NSString *base = [[json valueForKey:@"content"]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData * data2 = [Base64 decode:base];
    NSString * actualString = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
  //  NSLog(@"Actual:%@",actualString);
    if (isText == YES) {
        
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:actualString,@"content",filename,@"filename",[NSNumber numberWithBool:YES],@"isText", nil];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushHTMLView" object:nil userInfo:userInfo];
       
    }
    else{
       
         NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:data2,@"content",filename,@"filename",[NSNumber numberWithBool:NO],@"isText", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushHTMLView" object:nil userInfo:userInfo];
         
    }
    
}


 // http://github.com/api/v2/json/blob/show/HubertK/iOS_Restful/49acc5b9126613c22f5220cec36931eda4e6c96c/GPAppDelegate.h

- (BOOL)checkIfText:(NSString*)treeSHA username:(NSString*)username repo:(NSString*)repo file:(NSString*)file{
    BOOL isText;
    NSString *fileNoSpaces = [file stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"\nUser:%@\nRepo:%@\nFile:%@\nTreeSHA:%@",username,repo,fileNoSpaces,treeSHA);
    NSString *URL = [NSString stringWithFormat:@"http://github.com/api/v2/json/blob/show/%@/%@/%@/%@?meta=1",username,repo,treeSHA,fileNoSpaces];
     
    NSError *error = nil;
  
    NSURL *url = [NSURL URLWithString:URL];
    NSData *data = [NSData dataWithContentsOfURL:url];      
    NSDictionary* json = [NSJSONSerialization                
                          JSONObjectWithData:data            
                          options:kNilOptions               
                          error:&error];
    NSLog(@"Received Data:%@",[json description]);
    if ([[[json valueForKey:@"blob"] valueForKey:@"mime_type"]isEqualToString:@"text/plain"]) {
        isText = YES;
    }
    else{
        isText = NO;
    }
    return isText;
}






















@end
