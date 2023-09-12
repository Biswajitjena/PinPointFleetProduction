//
//  GPSAdminVC.h
//  OpenGTS
//
//  Created by Sandip Rudani on 12/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSAppDelegate.h"
#import "MBProgressHUD.h"
#import "GPSVehInfoDEtailVC.h"
#import "GPSUserAdminEditVC.h"


@interface GPSAdminVC : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    GPSAppDelegate *objDelegate;
    
    NSMutableArray *arrMain;
    
    MBProgressHUD *hud;
    
    
    UIAlertView *alertview;
    
    BOOL isAccountAdmin,isUserAdmin,isVehicleAdmin,isGroupAdmin;
    
    NSMutableDictionary *dicGroupEdit;
    
    BOOL isEdit,isAddDelAllow;
    
 

}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property(strong,nonatomic)IBOutlet UINavigationBar *navigationbar;

@property(strong,nonatomic)NSString *strSegueIdentifier;

-(IBAction)AddDevice:(id)sender;


@end
