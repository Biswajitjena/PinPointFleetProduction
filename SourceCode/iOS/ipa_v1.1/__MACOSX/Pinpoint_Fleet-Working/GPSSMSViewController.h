//
//  GPSSMSViewController.h
//  PinPoint
//
//  Created by Sandip Rudani on 01/08/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSAppDelegate.h"

#import <MessageUI/MFMessageComposeViewController.h>

#import "RESideMenu.h"


@interface GPSSMSViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate,RESideMenuDelegate>
    
    

@end
