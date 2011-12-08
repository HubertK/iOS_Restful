//
//  RepoDetailView.h
//  Get_Post
//
//  Created by Helene Brooks on 12/7/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoDetailView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *repoName;
@property (weak, nonatomic) IBOutlet UILabel *repoDescription;
@property (weak, nonatomic) IBOutlet UILabel *publicPrivate;
@property (weak, nonatomic) IBOutlet UILabel *language;
@property (weak, nonatomic) IBOutlet UILabel *repoOwner;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) NSString *URLString;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
- (IBAction)listComments:(id)sender;
- (void)getinformation:(NSString*)repoURLString;
- (void)fetchedData:(NSData *)responseData;
- (void)getIconForUser:(NSString*)iconURL;
- (IBAction)seeProfile:(id)sender;
@end
