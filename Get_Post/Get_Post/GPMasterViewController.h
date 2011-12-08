//
//  GPMasterViewController.h
//  Get_Post
//
//  Created by Helene Brooks on 11/30/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPDetailViewController;

@interface GPMasterViewController : UITableViewController

@property (strong, nonatomic) GPDetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableDictionary *repoDictionary;
@property (strong, nonatomic) NSMutableDictionary *JSONDictionary;
@property (strong, nonatomic) NSString *repoPicked;
@property (weak, nonatomic) NSURLConnection *URLConnection;

- (void)getCommitsForRepo:(NSString*)repo;
@end
