//
//  CustomTableViewCell.m
//  PinPoint
//
//  Created by Sandip Rudani on 03/09/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(180,0,30,30);
//    self.textLabel.frame = CGRectMake(250, 0, 200, 40);   //change this to your needed
    
//    self.imageView.backgroundColor  = [UIColor yellowColor];
//    self.textLabel.backgroundColor = [UIColor blueColor];
    
    self.lblAssignment=[[UILabel alloc]initWithFrame:CGRectMake(125, 7, 200, 25)];
    self.lblAssignment.textColor=[UIColor whiteColor];
    self.lblAssignment.font=[UIFont fontWithName:@"Palatino" size:17];
    self.lblAssignment.textAlignment = NSTextAlignmentLeft;
    self.lblAssignment.backgroundColor = [UIColor purpleColor];
//    [self addSubview:self.lblAssignment];
    [self.lblAssignment setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];

    self.lblGroup=[[UILabel alloc]initWithFrame:CGRectMake(150, 7, 200, 25)];
    self.lblGroup.textColor=[UIColor orangeColor];
    self.lblGroup.font=[UIFont fontWithName:@"Helvetica Neue" size:16];
    self.lblGroup.textAlignment = NSTextAlignmentLeft;
    self.lblGroup.backgroundColor = [UIColor yellowColor];
//    [self addSubview:self.lblGroup];
    [self.lblGroup setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    

    self.lblDevice=[[UILabel alloc]initWithFrame:CGRectMake(180, 7, 200, 25)];
    self.lblDevice.textColor=[UIColor greenColor];
    self.lblDevice.font=[UIFont fontWithName:@"Helvetica Neue" size:15];
    self.lblDevice.textAlignment = NSTextAlignmentLeft;
    self.lblDevice.backgroundColor = [UIColor darkGrayColor];
//    [self addSubview:self.lblDevice];
    [self.lblDevice setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    
    
    
}



- (void)awakeFromNib
{
    // Initialization code
}


@end
