//
//  GPSGroupDetailVC.h
//  PinPoint
//
//  Created by Guest User on 28/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GPSGroupDetailVC : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,readwrite)BOOL isAdd;

@property (nonatomic,retain)NSMutableArray *arrGroupList;

@property(nonatomic,retain)IBOutlet UITextField *txtGroupName;


@end
