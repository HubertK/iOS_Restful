//
//  GPDetailViewController.h
//  Get_Post
//
//  Created by Helene Brooks on 11/30/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPDetailViewController : UIViewController <UISplitViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,NSURLConnectionDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) NSMutableString *URLString;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) NSURLConnection *URLConnection;
- (IBAction)changedPrivateSwitch:(id)sender;
- (IBAction)sendRequestForNewRepository:(id)sender;
@end
