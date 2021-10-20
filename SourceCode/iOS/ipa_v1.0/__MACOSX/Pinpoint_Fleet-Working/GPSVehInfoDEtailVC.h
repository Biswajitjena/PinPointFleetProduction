//
//  GPSVehInfoDEtailVC.h
//  OpenGTS
//
//  Created by Sandip Rudani on 12/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"

@interface GPSVehInfoDEtailVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>{
    MBProgressHUD *hud;
    GPSAppDelegate *objAppDelegate;
    
    IBOutlet UITextField *txtDeviceID,*txtAccountID,*txtUiniqueID,*txtDescription,*txtName,*txtVehicleID,*txtLicPlate,*txtEquipType,*txtIMEI,*txtSerialNum,*txtSimPhone,*txtSMSEmail,*txtFuelCap,*txtDriver,*txtRptOdomtr,*txtRptHours,*txtCreationDate;
    
    IBOutlet UIScrollView *scrollview;
    
    IBOutlet UISwitch *swActive;

    BOOL keyboardVisible;
    CGPoint	offset;
    
    NSString *strActive;


}

-(IBAction)Edit:(id)sender;

-(IBAction)Save:(id)sender;

-(void)PullData;

@property(nonatomic,retain)NSMutableArray *arrVehicleData;

@property(nonatomic,retain)NSString *strVehicleID;

@property(nonatomic,readwrite) BOOL isEditable;

@end
