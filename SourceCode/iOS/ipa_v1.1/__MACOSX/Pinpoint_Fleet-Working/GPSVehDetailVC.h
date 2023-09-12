//
//  GPSUserDetailVC.h
//  PinPoint
//
//  Created by Guest User on 28/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GPSVehDetailVC : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIScrollViewDelegate,UIPopoverControllerDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,retain)NSArray *arrVehicleData;
@property(nonatomic,readwrite)BOOL isAdd;

@end
