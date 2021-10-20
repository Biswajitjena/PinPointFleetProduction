//
//  GPSUserAdminEditVC.h
//  OpenGTS
//
//  Created by Guest User on 16/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"

@interface GPSUserAdminEditVC : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIActionSheetDelegate>{
    
    IBOutlet UITextField *txtAccountID,*txtUserID,*txtName,*txtPassword,*txtContact,*txtPhone,*txtEmail,*txtNotify,*txtTimezone,*txtAuthGroup,*txtFistPage;
    
    IBOutlet UIScrollView *scrollview;
    
    IBOutlet UISwitch *swActive;

    MBProgressHUD *hud;
    GPSAppDelegate *objDelegate;
    
    BOOL keyboardVisible;
    CGPoint	offset;
    
    UIPickerView *pickerView;
    
    UIActionSheet *ac;
    
    NSMutableArray *arrTimezone;

    NSString *strActive;
}


@property(nonatomic,retain)NSMutableArray *arrVehicleData;

@property(nonatomic,retain)NSString *strVehicleID;

@property(nonatomic,readwrite) BOOL isEditable;


-(void)PullData;

@end
