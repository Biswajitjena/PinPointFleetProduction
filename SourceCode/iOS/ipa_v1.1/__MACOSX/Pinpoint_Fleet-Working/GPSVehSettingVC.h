//
//  GPSVehSettingVC.h
//  OpenGTS
//
//  Created by Sandip Rudani on 04/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@class GPSMapVC;

@interface GPSVehSettingVC : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPopoverControllerDelegate>

@property(nonatomic,retain)IBOutlet UITextField *txtStartDate,*txtEndDate,*txtVehIDList,*txtTimeZone;

@property(nonatomic,retain)IBOutlet UILabel *lblIDList,*lblDate,*lblTimeZone;


@property (strong, nonatomic) IBOutlet UIButton *btnSave,*btnCancel;

-(IBAction)Save:(id)sender;
@end
