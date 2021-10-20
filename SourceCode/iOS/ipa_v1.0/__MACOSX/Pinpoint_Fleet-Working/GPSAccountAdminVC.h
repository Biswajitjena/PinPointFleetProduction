//
//  GPSAccountAdminVC.h
//  OpenGTS
//
//  Created by Guest User on 16/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"

@interface GPSAccountAdminVC : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIScrollViewDelegate>{
  
    
    IBOutlet UIScrollView *scrollview;
    
    
    MBProgressHUD *hud;
    GPSAppDelegate *objDelegate;
    
    UIPickerView *pickerView;
    UIActionSheet *ac;
    
    int i;
    
    NSArray *arrspeedUnit,*arrDistanceUnits,*arrvolumUnit,*arreconomyUnit,*arrpressureUnit,*arrtemperatureUnit;
    
    
    NSInteger intSpeed,intDistance,intEconomy,intPressure,intTemprature,intVolume;
    
    BOOL keyboardVisible;
    CGPoint	offset;


}
@property (strong, nonatomic) IBOutlet UITextField *txtAcc_ID,*txtAcc_Name,*txtAddress,*txtCity,*txtContEmail,*txtContPerson,*txtContactPhone,*txtcountry,*txtMaxDevices,*txtMaxUsers,*txtSkype,*txtWebsite,*txtZip,*txtUDistance,*txtUEconomy,*txtUPressure,*txtUSpeed,*txtUTemp,*txtUVolume;

@property(nonatomic,retain)NSMutableArray *arrVehicleData;

@property(nonatomic,retain)NSString *strVehicleID;



@end
