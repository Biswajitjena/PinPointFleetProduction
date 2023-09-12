//
//  GPSUserRoleVC.h
//  PinPoint
//
//  Created by Sandip Rudani on 04/08/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSUserRoleVC : UITableViewController<UITextFieldDelegate>

@property(nonatomic,retain)NSArray *arrData;
@property(nonatomic,readwrite)BOOL isAdd;


@end
