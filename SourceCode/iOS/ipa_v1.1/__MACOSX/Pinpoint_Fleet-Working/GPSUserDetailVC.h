//
//  GPSEditUSerVcViewController.h
//  PinPoint
//
//  Created by Guest User on 28/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GPSUserDetailVC : UIViewController
    <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIScrollViewDelegate>


@property(nonatomic,retain)NSArray *arrVehicleData;
@property(nonatomic,readwrite)BOOL isAdd;

@property(nonatomic,retain)NSString *strName;

@end
