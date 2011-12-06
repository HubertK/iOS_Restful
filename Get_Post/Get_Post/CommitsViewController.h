//
//  CommitsViewController.h
//  Get_Post
//
//  Created by Helene Brooks on 12/3/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitsViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *commits;
@property (nonatomic, strong) NSString *repo;
- (void)getFilesFromURLatIndex:(NSInteger)index;
- (void)fetchedData:(NSData *)responseData;
- (NSString*)getDate:(NSString*)dateString;
@end
