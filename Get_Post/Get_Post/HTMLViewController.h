//
//  HTMLViewController.h
//  Get_Post
//
//  Created by Helene Brooks on 12/5/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface HTMLViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *file;
@property (strong,nonatomic) NSData *imageData;
@property (strong,nonatomic) NSString *content;
@property (weak, nonatomic) IBOutlet UILabel *filename;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (nonatomic) BOOL isText;
- (void)reloadWeb:(NSString*)aString;
@end
