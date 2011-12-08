//
//  UserInfoViewController.h
//  Get_Post
//
//  Created by Helene Brooks on 12/1/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *repos;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *loginName;
@property (strong, nonatomic) NSURLConnection *infoConnection;
@property (strong, nonatomic) NSURLConnection *repoConnection;;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logButton;


- (IBAction)logInOut:(id)sender;
- (IBAction)listRepositories:(id)sender;
- (void)loadUserInfo;
- (void)fillInInformation:(NSDictionary*)userInfo;
- (void)resetInfo;
@end
