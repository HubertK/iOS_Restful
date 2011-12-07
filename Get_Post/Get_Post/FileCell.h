//
//  FileCell.h
//  Get_Post
//
//  Created by Helene Brooks on 12/6/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameOfFile;
@property (weak, nonatomic) IBOutlet UILabel *fileType;
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;
@end
