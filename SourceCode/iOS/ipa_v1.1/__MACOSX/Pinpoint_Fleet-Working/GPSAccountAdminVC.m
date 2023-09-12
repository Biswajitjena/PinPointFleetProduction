//
//  GPSAccountAdminVC.m
//  OpenGTS
//
//  Created by Guest User on 16/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSAccountAdminVC.h"

#define SCROLLVIEW_HEIGHT 460
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 1450
#define SCROLLVIEW_CONTENT_WIDTH  320

#define SpeedUnits [NSArray arrayWithObjects: @"km/h",@"mph",nil]

#define DistanceUnits [NSArray arrayWithObjects: @"km",@"miles",nil]

#define VolumUnit [NSArray arrayWithObjects: @"l",@"gal",nil]

#define EconomyUnit [NSArray arrayWithObjects: @"km/l",@"miles",nil]

#define PressureUnit [NSArray arrayWithObjects: @"kpa",@"bar",@"psi",nil]

#define TemperatureUnit [NSArray arrayWithObjects: @"C",@"F",nil]


@interface GPSAccountAdminVC (){
    
    NSString *strAlertString;

}

@end

@implementation GPSAccountAdminVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    objDelegate= (GPSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.arrVehicleData = [[NSMutableArray alloc]init];
    
    arrspeedUnit = [[NSArray alloc]initWithArray:SpeedUnits];
    
    arrDistanceUnits = [[NSArray alloc]initWithArray:DistanceUnits];
    
    arrvolumUnit = [[NSArray alloc]initWithArray:VolumUnit];
    
    arreconomyUnit = [[NSArray alloc]initWithArray:EconomyUnit];
    
    arrpressureUnit = [[NSArray alloc]initWithArray:PressureUnit];
    
    arrtemperatureUnit = [[NSArray alloc]initWithArray:TemperatureUnit];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
    
    self.navigationItem.title = @"Admin Account";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino-bold" size:22]}];
        
    }
    
    else {
        
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
        
        
    }
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save)];
    
    btnSave.tintColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = btnSave;
    
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    
    if(self.txtUDistance){
        
        self.txtUDistance.text = [arrDistanceUnits objectAtIndex:0];
        
        intDistance  = 0;
        
        
	}
	 if (self.txtUEconomy){
        
        self.txtUEconomy.text = [arreconomyUnit objectAtIndex:0];
        
        intEconomy  = 0;
        
	}
    
    if(self.txtUPressure){
        
        self.txtUPressure.text = [arrpressureUnit objectAtIndex:0];
        
        intPressure  = 0;
        
	}
	 if (self.txtUSpeed){
        
        self.txtUSpeed.text = [arrspeedUnit objectAtIndex:0];
        
        intSpeed  = 0;
        
	}
    
    if(self.txtUTemp){
        
        self.txtUTemp.text = [arrtemperatureUnit objectAtIndex:0];
        
        intTemprature  = 0;
        
        
	}
	 if (self.txtUVolume){
        
        self.txtUVolume.text = [arrvolumUnit objectAtIndex:0];
        
        intVolume  = 0;
	}
 
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    [self CheckNetworkAvailability];
    
//    [pickerView setBackgroundColor:[UIColor blueColor]];
    
}

-(void)cancelPicker:(id)sender{
    
    if(pickerView.window){
	
        [pickerView resignFirstResponder];

        NSInteger row = [pickerView selectedRowInComponent:0];


        if(i==0){
            
            self.txtUDistance.text = [arrDistanceUnits objectAtIndex:row];
            
            intDistance  = row;
            
            [self textFieldShouldReturn:self.txtUDistance];
        }
        else if (i==1){
            
            self.txtUEconomy.text = [arreconomyUnit objectAtIndex:row];
            
            intEconomy = row;
            
            [self textFieldShouldReturn:self.txtUEconomy];
            
        }

        else if(i==2){
            
            self.txtUPressure.text = [arrpressureUnit objectAtIndex:row];
            intPressure = row;
            
            
            [self textFieldShouldReturn:self.txtUPressure];
        }
        else if (i==3){
            
            self.txtUSpeed.text = [arrspeedUnit objectAtIndex:row];
            intSpeed = row;
            
            [self textFieldShouldReturn:self.txtUSpeed];
            
        }
        else if(i==4){
            
            self.txtUTemp.text = [arrtemperatureUnit objectAtIndex:row];
            intTemprature = row;
            
            [self textFieldShouldReturn:self.txtUTemp];
            
        }
        else if (i==5){
            
            self.txtUVolume.text = [arrvolumUnit objectAtIndex:row];
            intVolume = row;
            
            [self textFieldShouldReturn:self.txtUVolume];
            
        }
    }
    
     else if([self.txtAcc_ID isFirstResponder]|| [self.txtAcc_Name isFirstResponder] || [self.txtAddress isFirstResponder]||[self.txtCity isFirstResponder]|| [self.txtContactPhone isFirstResponder] || [self.txtContEmail isFirstResponder]||[self.txtContPerson isFirstResponder]|| [self.txtcountry isFirstResponder] || [self.txtMaxDevices isFirstResponder]|| [self.txtMaxUsers isFirstResponder] || [self.txtSkype isFirstResponder]||[self.txtWebsite isFirstResponder]|| [self.txtZip isFirstResponder]){
        
            [self.view endEditing:YES];
        
     }
  

}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.view) {
        return YES;
    } else {
        return NO;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSLog(@"Registering for keyboard events");
    
	// Register for the events
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)
												 name: UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:)
												 name: UIKeyboardDidHideNotification object:nil];
    
	//Initially the keyboard is hidden
	keyboardVisible = NO;
}


-(void)CheckNetworkAvailability {
    
    
    
    NSLog(@"identifier is --> %@",objDelegate.strId);
    
    if ([objDelegate isNetworkAvailable]) {
        
      //  [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        [self GetAdminDetail];
        
        
    }
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
}


-(void)viewDidLayoutSubviews{
    
    scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
    
}

-(void)showAlert:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:Title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}

-(void)showAlertForSuccessfullyUpdate:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:Title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}


-(void)GetAdminDetail
{
    
    NSLog(@"GEtAdminDEtail Called !! ");
    

    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=dafaultAccAdmin",LiveURL];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"]];
    
 //   NSString *postString =[NSString stringWithFormat:@"&accountID=226825"];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
    
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
         
    if (error) {
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
        
    }
    else
    { //1
        
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData    = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            NSLog(@"its Dictionary");
            
            self.arrVehicleData= jsonData;
            
              [self performSelectorOnMainThread:@selector(DisplayData) withObject:strAlertString waitUntilDone:NO];
            
            
        }
        
    
    }
    
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
    
}

-(void)DisplayData{
    

    
  //  txtAccountID.text = objDelegate.strAccountID;
    
    if([[self.arrVehicleData valueForKey:@"id"]isEqual:[NSNull null]]){
        
        self.txtAcc_ID.text = @"";
    }
    
    else {
        
        self.txtAcc_ID.text = [self.arrVehicleData valueForKey:@"id"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"account_name"]isEqual:[NSNull null]]){
        
        self.txtAcc_Name.text = @"";
    }
    
    else {
        
        self.txtAcc_Name.text = [self.arrVehicleData valueForKey:@"account_name"];
        
    }
    
  
    if([[self.arrVehicleData valueForKey:@"address"]isEqual:[NSNull null]]){
        
        self.txtAddress.text = @"";
    }
    
    else {
        
        self.txtAddress.text = [self.arrVehicleData valueForKey:@"address"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"city"]isEqual:[NSNull null]]){
        
        self.txtCity.text = @"";
    }
    
    else {
        
        self.txtCity.text = [self.arrVehicleData valueForKey:@"city"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"contact_email"]isEqual:[NSNull null]]){
        
        self.txtContEmail.text = @"";
    }
    
    else {
        
        self.txtContEmail.text = [self.arrVehicleData valueForKey:@"contact_email"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"contact_person"]isEqual:[NSNull null]]){
        
        self.txtContPerson.text = @"";
    }
    
    else {
        
        self.txtContPerson.text = [self.arrVehicleData valueForKey:@"contact_person"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"contact_phone"]isEqual:[NSNull null]]){
        
        self.txtContactPhone.text = @"";
    }
    
    else {
        
        self.txtContactPhone.text = [self.arrVehicleData valueForKey:@"contact_phone"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"country"]isEqual:[NSNull null]]){
        
        self.txtcountry.text = @"";
    }
    
    else {
        
        self.txtcountry.text = [self.arrVehicleData valueForKey:@"country"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"max_devices"]isEqual:[NSNull null]]){
        
        self.txtMaxDevices.text = @"";
    }
    
    else {
        
        self.txtMaxDevices.text =[NSString stringWithFormat:@"%@",[self.arrVehicleData valueForKey:@"max_devices"]];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"max_users"]isEqual:[NSNull null]]){
        
        self.txtMaxUsers.text = @"";
    }
    
    else {
        
        self.txtMaxUsers.text =[NSString stringWithFormat:@"%@",[self.arrVehicleData valueForKey:@"max_users"]];
        
    }
    
    
    if([[self.arrVehicleData valueForKey:@"skype"]isEqual:[NSNull null]]){
        
        self.txtSkype.text = @"";
    }
    
    else {
        
        
          self.txtSkype.text = [self.arrVehicleData valueForKey:@"skype"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"website"]isEqual:[NSNull null]]){
        
        self.txtWebsite.text = @"";
    }
    
    else {
        
        self.txtWebsite.text = [self.arrVehicleData valueForKey:@"website"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"zip"]isEqual:[NSNull null]]){
        
        self.txtZip.text = @"";
    }
    
    else {
        
        self.txtZip.text = [self.arrVehicleData valueForKey:@"zip"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"units_distance"]isEqual:[NSNull null]]){
        
        self.txtUDistance.text = @"";
    }
    
    else {
        NSString *str = [self.arrVehicleData valueForKey:@"units_distance"];
        NSString *newStr = [str substringWithRange:NSMakeRange(5, [str length]-5)];
        
        self.txtUDistance.text = [arrDistanceUnits objectAtIndex:[newStr integerValue]];
        intDistance =[[self.arrVehicleData valueForKey:@"units_distance"]integerValue];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"units_economy"]isEqual:[NSNull null]]){
        
        self.txtUEconomy.text = @"";
    }
    
    else {
        NSString *str = [self.arrVehicleData valueForKey:@"units_economy"];
        NSString *newStr = [str substringWithRange:NSMakeRange(5, [str length]-5)];
        
        self.txtUEconomy.text = [arreconomyUnit objectAtIndex:[newStr integerValue]];
        intEconomy = [[self.arrVehicleData valueForKey:@"units_economy"]integerValue];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"units_pressure"]isEqual:[NSNull null]]){
        
        self.txtUPressure.text = @"";
    }
    
    else {
        
        NSString *str = [self.arrVehicleData valueForKey:@"units_pressure"];
        NSString *newStr = [str substringWithRange:NSMakeRange(5, [str length]-5)];
        self.txtUPressure.text = [arrpressureUnit objectAtIndex:[newStr integerValue]];
        intPressure=[[self.arrVehicleData valueForKey:@"units_pressure"]integerValue];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"units_speed"]isEqual:[NSNull null]]){
        
        self.txtUSpeed.text = @"";
    }
    
    else {
        NSString *str = [self.arrVehicleData valueForKey:@"units_speed"];
        NSString *newStr = [str substringWithRange:NSMakeRange(5, [str length]-5)];
        self.txtUSpeed.text =[arrspeedUnit objectAtIndex:[newStr integerValue]];
        intSpeed=[[self.arrVehicleData valueForKey:@"units_speed"]integerValue];

    }
    
    if([[self.arrVehicleData valueForKey:@"units_temp"]isEqual:[NSNull null]]){
        
        self.txtUTemp.text = @"";
    }
    
    else {
        
        NSString *str = [self.arrVehicleData valueForKey:@"units_temp"];
        NSString *newStr = [str substringWithRange:NSMakeRange(5, [str length]-5)];

        self.txtUTemp.text = [arrtemperatureUnit objectAtIndex:[newStr integerValue]];
        intTemprature=[[self.arrVehicleData valueForKey:@"units_temp"]integerValue];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"units_volume"]isEqual:[NSNull null]]){
        
        self.txtUVolume.text = @"";
    }
    
    else {
        NSString *str = [self.arrVehicleData valueForKey:@"units_volume"];
        NSString *newStr = [str substringWithRange:NSMakeRange(5, [str length]-5)];

        self.txtUVolume.text = [arrvolumUnit objectAtIndex:[newStr integerValue]];
        intVolume=[[self.arrVehicleData valueForKey:@"units_volume"]integerValue];

    }
    
}

-(void)Save{
    
    if([objDelegate isNetworkAvailable]){
        
        
        
        for (UIView *subview in [scrollview subviews]) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subview;
                textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                NSLog(@"Trim string -->%@.",textField.text);
            
            }
        }
        
        if(self.txtAcc_Name.text.length >0)
            
            [self UploadData];
        
        else
        {
            
            
            strAlertString = @"Enter Account Name";
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        }
    
//        [self UploadData];
        
    }
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
     
    }
}




-(void)UploadData{
    
    NSLog(@"Upload Data Called !! ");
    
 
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=editAccAdmin",LiveURL];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    NSString *strSpeed = [NSString stringWithFormat:@"%ld",(long)intSpeed];
    NSString *strDistance = [NSString stringWithFormat:@"%ld",(long)intDistance];
    NSString *strVolume = [NSString stringWithFormat:@"%ld",(long)intVolume];
    NSString *strEconomy = [NSString stringWithFormat:@"%ld",(long)intEconomy];
    NSString *strPressure = [NSString stringWithFormat:@"%ld",(long)intPressure];
    NSString *strTemprature = [NSString stringWithFormat:@"%ld",(long)intTemprature];
    
    
    NSString *postString =[NSString stringWithFormat:@"&account_id=%@&account_name=%@&email=%@&contact_person=%@&phone=%@&skype=%@&max_user=%@&max_device=%@&address=%@&city=%@&country=%@&zip=%@&website=%@&speed=%@&distance=%@&volume=%@&fuel=%@&pressure=%@&temp=%@",[self.arrVehicleData valueForKey:@"id"],self.txtAcc_Name.text,self.txtContEmail.text,self.txtContPerson.text,self.txtContactPhone.text,self.txtSkype.text,self.txtMaxUsers.text,self.txtMaxDevices.text,self.txtAddress.text,self.txtCity.text,self.txtcountry.text,self.txtZip.text,self.txtWebsite.text,strSpeed,strDistance,strVolume,strEconomy,strPressure,strTemprature];
    
    NSLog(@"poststring %@",postString);
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //start the connection
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];

    if (error) {
        
        
        NSLog(@"--Its error inside  upload data ---");
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]){
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                strAlertString = @"Please try again later !!";
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                strAlertString = @"Data Uploded Successfully !!";
                
                [self performSelectorOnMainThread:@selector(showAlertForSuccessfullyUpdate:) withObject:strAlertString waitUntilDone:NO];
            }
        }
        
    }
    
    //  }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
    
}

#pragma mark -
#pragma mark pickerview method

//-(IBAction)showPickerView:(UITextField*)sender{
//	
//	ac=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//	pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,50,320,350)];
//	pickerView.hidden=NO;
//	pickerView.delegate = self;
//	pickerView.showsSelectionIndicator = YES;
//	[pickerView selectRow:0 inComponent:0 animated:NO];
//    
//	
//    if(i==0){
//        
//        self.txtUDistance.text = [arrDistanceUnits objectAtIndex:0];
//        
//        intDistance  = 0;
//        
//        
//	}
//	else if (i==1){
//        
//        self.txtUEconomy.text = [arreconomyUnit objectAtIndex:0];
//        
//        intEconomy  = 0;
//        
//	}
//    
//    if(i==2){
//        
//        self.txtUPressure.text = [arrpressureUnit objectAtIndex:0];
//                                  
//        intPressure  = 0;
//        
//	}
//	else if (i==3){
//        
//        self.txtUSpeed.text = [arrspeedUnit objectAtIndex:0];
//        
//        intSpeed  = 0;
//        
//	}
//    
//    if(i==4){
//        
//        self.txtUTemp.text = [arrtemperatureUnit objectAtIndex:0];
//        
//        intTemprature  = 0;
//        
//        
//	}
//	else if (i==5){
//        
//        self.txtUVolume.text = [arrvolumUnit objectAtIndex:0];
//        
//        intVolume  = 0;
//	}
//
//    
//    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
//	
//	UIButton*btndone = [UIButton buttonWithType:UIButtonTypeCustom];
//	btndone.frame = CGRectMake(250, 5, 60, 30);
//    [[btndone titleLabel] setFont:[UIFont fontWithName:@"Helvetica Bold " size:15]];
//    [btndone setTitle:@"Done" forState:UIControlStateNormal];
//    [btndone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btndone setBackgroundImage:[UIImage imageNamed:@"search-criteria.png"] forState:UIControlStateNormal];
//	[btndone addTarget:self action:@selector(cancelDiscountPickerView:) forControlEvents:UIControlEventTouchDown];
//	
//	[ac addSubview:toolbar];
//	[toolbar addSubview:btndone];
//	
//	[ac addSubview:pickerView];
//	
//	[ac showInView:self.view];
//   	[ac setBounds:CGRectMake(0,0,320,400)];
//    
//}
//
//-(void)cancelDiscountPickerView:(id)sender{
//	
//	[ac dismissWithClickedButtonIndex:0 animated:YES];
//    
//    
//	if(i==0){
//        
//        [self textFieldShouldReturn:self.txtUDistance];
//
//    }
//    if(i==1){
//        
//        [self textFieldShouldReturn:self.txtUEconomy];
//    }
//    
//    if(i==2){
//        
//        [self textFieldShouldReturn:self.txtUPressure];
//    }
//    
//    if(i==3){
//        
//        [self textFieldShouldReturn:self.txtUSpeed];
//    }
//    if(i==4){
//        
//        [self textFieldShouldReturn:self.txtUTemp];
//    }
//    
//    if(i==5){
//        
//        [self textFieldShouldReturn:self.txtUVolume];
//    }
//	
//}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	
	int sectionWidth = 320;
	
	return sectionWidth;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle;

    
    if(i==0){
        
        strTitle= [arrDistanceUnits objectAtIndex:row];

        
    }
    if(i==1){
        
        strTitle= [arreconomyUnit objectAtIndex:row];
    }
    
    if(i==2){
        
        strTitle= [arrpressureUnit objectAtIndex:row];
    }
    
    if(i==3){
        
        strTitle= [arrspeedUnit objectAtIndex:row];
    }
    if(i==4){
        
        strTitle= [arrtemperatureUnit objectAtIndex:row];
    }
    
    if(i==5){
        
        strTitle= [arrvolumUnit objectAtIndex:row];
    }
    
    return strTitle;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(i==0){
        
        self.txtUDistance.text = [arrDistanceUnits objectAtIndex:row];
        
        intDistance  = row;

//        [self.txtUDistance resignFirstResponder];
        
	}
	else if (i==1){
        
        self.txtUEconomy.text = [arreconomyUnit objectAtIndex:row];
        
        intEconomy = row;
        
//        [self.txtUEconomy resignFirstResponder];

        
	}
    
    if(i==2){
        
        self.txtUPressure.text = [arrpressureUnit objectAtIndex:row];
        intPressure = row;
        
        
//        [self.txtUPressure resignFirstResponder];

	}
	else if (i==3){
        
        self.txtUSpeed.text = [arrspeedUnit objectAtIndex:row];
        intSpeed = row;
        
//        [self.txtUSpeed resignFirstResponder];

        
	}
    if(i==4){
        
        self.txtUTemp.text = [arrtemperatureUnit objectAtIndex:row];
        intTemprature = row;
        
//        [self.txtUTemp resignFirstResponder];

        
        
	}
	else if (i==5){
        
        self.txtUVolume.text = [arrvolumUnit objectAtIndex:row];
        intVolume = row;
        
//        [self.txtUVolume resignFirstResponder];

        
	}
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
    if(i==0){
		return [arrDistanceUnits count];
        
    }
    
    else if(i==1){
		return [arreconomyUnit count];
        
    }
    
    else if(i==2){
		return [arrpressureUnit count];
        
    }
    
    else if(i==3){
		return [arrspeedUnit count];
        
    }
    
    else if(i==4){
		return [arrtemperatureUnit count];
        
    }
    
    else if(i==5){
		return [arrvolumUnit count];
        
    }
    
	return 0;
	
}




#pragma mark -
#pragma mark textField method


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if(textField == self.txtUDistance){
        i=0;
//        [self showPickerView:self.txtUDistance];
//        return NO;
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtUDistance.inputView = pickerView;

    }
    
    if(textField == self.txtUEconomy){
        i=1;
//        [self showPickerView:self.txtUEconomy];
//        return NO;
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtUEconomy.inputView = pickerView;

    }
    
    if(textField == self.txtUPressure){
        i=2;
//        [self showPickerView:self.txtUPressure];
//        return NO;
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtUPressure.inputView = pickerView;
    }
    
    if(textField == self.txtUSpeed){
        i=3;
//        [self showPickerView:self.txtUSpeed];
//        return NO;

        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtUSpeed.inputView = pickerView;

    }
    
    if(textField == self.txtUTemp){
        
        i=4;
        
//        [self showPickerView:self.txtUTemp];
//        return NO;
    
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtUTemp.inputView = pickerView;
    }
    
    if(textField == self.txtUVolume){
        
        i=5;
        
//        [self showPickerView:self.txtUVolume];
//        return NO;
        
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtUVolume.inputView = pickerView;
    }
    
    
    
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if(textField == self.txtContEmail || self.txtSkype){
//        
//        NSString *emailRegex =
//        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
//        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
//        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
//        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
//        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
//        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
//        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
//        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
//        
//        BOOL isSuccess = [emailTest evaluateWithObject:textField.text];
//        
//        if(isSuccess){
//            
//            NSLog(@" Valid Email ");
//        }
//        
//        else {
//            
//            NSLog(@" Invalid Email ");
//
//        }
//        
//    }
    
	[textField resignFirstResponder];
	return YES;
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL isequal = YES;
    
    NSCharacterSet *invalidCharSet = [[NSCharacterSet alloc]init];
    
    if(textField==self.txtAcc_ID || textField==self.txtAcc_Name ||textField==self.txtCity || textField==self.txtcountry || textField==self.txtContPerson){
    
    
       invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "] invertedSet];
        
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        
//        invalidCharSet = [[NSCharacterSet alphanumericCharacterSet]invertedSet];

        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        isequal =  [string isEqualToString:filtered];
    }
    
    if(textField==self.txtContactPhone ){
        
       invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+*#- "] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        isequal =  [string isEqualToString:filtered];
    }
    
    if(textField==self.txtMaxDevices || textField==self.txtMaxUsers||textField==self.txtZip  ){
        
        
        invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        isequal =  [string isEqualToString:filtered];
    }
    
        
    return isequal;
}

-(void) keyboardDidShow: (NSNotification *)notif
{
	// If keyboard is visible, return
	if (keyboardVisible)
    {
		NSLog(@"Keyboard is already visible. Ignore notification.");
		return;
	}
    
	// Get the size of the keyboard.
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
    // Save the current location so we can restore
    // when keyboard is dismissed
    offset = scrollview.contentOffset;
    
	// Resize the scroll view to make room for the keyboard
	CGRect viewFrame = scrollview.frame;
	viewFrame.size.height -= keyboardSize.height;
	scrollview.frame = viewFrame;
    
	// Keyboard is now visible
	keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif
{
	// Is the keyboard already shown
	if (!keyboardVisible)
    {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		return;
	}
	
	// Reset the frame scroll view to its original value
    scrollview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
	// Reset the scrollview to previous location
    scrollview.contentOffset = offset;
    
	// Keyboard is no longer visible
	keyboardVisible = NO;
	
}


-(void) viewWillDisappear:(BOOL)animated
{
	NSLog (@"Unregister for keyboard events");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
