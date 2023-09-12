//
//  ChildCell.m
//  PinPoint
//
//  Created by Sandip Rudani on 29/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "ChildCell.h"

@implementation ChildCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
