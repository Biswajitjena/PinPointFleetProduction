//
//  RightMenuTableViewCell.m
//  PinPoint
//
//  Created by Sandip Rudani on 29/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "RightMenuTableViewCell.h"

@implementation RightMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(115, 7, 200, 25)];
        self.lblTitle.textColor=[UIColor whiteColor];
        self.lblTitle.font=[UIFont fontWithName:@"Palatino" size:17];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        self.lblTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lblTitle];
        
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 20,20)];
        self.imgview.backgroundColor = [UIColor clearColor];
        //    self.imgview.contentMode = UIViewContentModeCenter;
        //    self.imgview.clipsToBounds = YES;
        self.imgview.image = [UIImage imageNamed:@"down-arrow.png"];
        [self addSubview:self.imgview];
        
        self.lblSubTitle=[[UILabel alloc]initWithFrame:CGRectMake(115, 7, 200, 25)];
        self.lblSubTitle.textColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        self.lblSubTitle.font=[UIFont fontWithName:@"Helvetica Neue" size:15];
        self.lblSubTitle.textAlignment = NSTextAlignmentCenter;
        self.lblSubTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lblSubTitle];
        
        self.backgroundColor = [UIColor clearColor];
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
