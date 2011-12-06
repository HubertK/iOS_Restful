//
//  FilesViewController.h
//  Get_Post
//
//  Created by Helene Brooks on 12/3/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilesViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary *files;
@property (strong, nonatomic) NSString *repository;
@property (strong, nonatomic) NSString *SHA;
@property (strong, nonatomic) NSString *filePicked;


- (void)getFilesFromURLatIndex:(NSInteger)index;
- (void)fetchedData:(NSData *)responseData;
- (void)getContentBase64Data:(NSString*)URL file:(NSString*)filename;
- (BOOL)checkIfText:(NSString*)treeSHA username:(NSString*)username repo:(NSString*)repo file:(NSString*)file;
@end
