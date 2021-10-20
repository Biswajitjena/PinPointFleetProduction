//
//  ParentCell.m
//  PinPoint
//
//  Created by Sandip Rudani on 29/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "ParentCell.h"

@implementation ParentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    self.lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 25)];
    self.lblTitle.textColor=[UIColor darkTextColor];
    self.lblTitle.font=[UIFont fontWithName:@"Palatino" size:18];
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    self.lblTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lblTitle];
        
    self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25,25)];
    self.imgview.backgroundColor = [UIColor clearColor];
//    self.imgview.contentMode = UIViewContentModeCenter;
//    self.imgview.clipsToBounds = YES;
    self.imgview.image = [UIImage imageNamed:@"down-arrow.png"];
    [self addSubview:self.imgview];
        
    self.lblSubTitle=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 25)];
    self.lblSubTitle.textColor=[UIColor darkTextColor];
    self.lblSubTitle.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
    self.lblSubTitle.textAlignment = NSTextAlignmentCenter;
        self.lblSubTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lblSubTitle];
        

//    self.lblImage = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
//     self.lblImage.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1];
//    self.lblImage.contentMode = UIViewContentModeCenter;
//    self.lblImage.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.lblImage];
//
////    lbl.backgroundColor = [UIColor clearColor];
//    self.lblImage.font=[UIFont boldSystemFontOfSize:16];
//    self.lblImage.textColor = [UIColor whiteColor];
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
