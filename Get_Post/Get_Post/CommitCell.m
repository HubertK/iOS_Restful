//
//  CommitCell.m
//  Get_Post
//
//  Created by Helene Brooks on 12/3/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "CommitCell.h"

@implementation CommitCell
@synthesize commiter,message,date,authorImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
