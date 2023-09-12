//
//  GPSUserDetailVC.m
//  PinPoint
//
//  Created by Guest User on 28/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSVehDetailVC.h"

#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"

#define SCROLLVIEW_HEIGHT 568
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 1000
#define SCROLLVIEW_CONTENT_WIDTH  320

#define DeviceType [NSArray arrayWithObjects: @"SmartOne",@"Teltonika FM5300",@"Xirgo XT-2000",@"Xirgo XT-2150",@"Xirgo XT-4000",@"Xirgo XT-4500",@"Xirgo XT-4700",nil]

#define DeviceTypeId [NSArray arrayWithObjects: @"-9",@"-10",@"-6",@"-4",@"-5",@"-7",@"-8",nil]

@interface GPSVehDetailVC (){
    
    MBProgressHUD *hud;
    
    GPSAppDelegate *objDelegate;
    
    NSString *strAlertString;
    
    IBOutlet UIScrollView *scrollview;
    
    BOOL keyboardVisible;
    
    CGPoint	offset;
    
    NSArray *arrDeviceType,*arrDeviceTypeID;
    
    NSDictionary *dicDeviceType;
    
    UIPickerView *pickerView;
    
    UIActionSheet *ac;
    
    UIDatePicker *MyDatePicker;

    NSDateFormatter *df;

    UIPopoverController *popoverController;
    
    NSString *stroldDeviceId,*stroldDeviceName;

}

@property (strong, nonatomic) IBOutlet UITextField *txtId,*txtDevice_Id,*txtPhone,*txtVehicle_Type,*txtAvg_Consumption,*txtTank_Capacity,*txtMin_Theft,*txtDevice_Type_ID,*txtCompany_Name,*txtName,*txtRegister_Expire_Date,*txtMin_Fuel,*txtVehicle_reg;

@end

@implementation GPSVehDetailVC

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
    
    objDelegate = [[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
    
    
    if(self.isAdd)
    {
        
        self.navigationItem.title = @"Add Vehicle";
        
    }
    else {
        
        self.navigationItem.title = @"Vehicle Detail";
        
    }
    

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino-bold" size:22]}];
        
    }
    
    else {
        
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
        
        
    }
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    
    btnBack.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIBarButtonItem *Savebtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    
    Savebtn.enabled = TRUE;
    
    Savebtn.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = Savebtn;
    
    self.arrVehicleData = [[NSArray alloc]init];
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    if(!self.isAdd){
        
        [self CheckNetworkAvailability];
        
    }
    
    //    arrspeedUnit = [[NSArray alloc]initWithArray:SpeedUnits];
    //
    //    arrDistanceUnits = [[NSArray alloc]initWithArray:DistanceUnits];
    
    dicDeviceType = [[NSDictionary alloc]initWithObjects:DeviceType forKeys:DeviceTypeId];
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    if(self.txtDevice_Type_ID){
        
        NSArray *values = [dicDeviceType allValues];
        
        if ([values count] != 0)
            self.txtDevice_Type_ID.text = [values objectAtIndex:0];
        
        NSString *strDeviceTypeID;
        
        NSArray *arrKeys = [dicDeviceType allKeysForObject:self.txtDevice_Type_ID.text];
        
        if([arrKeys count]>0){
            strDeviceTypeID =  [arrKeys objectAtIndex:0];
        }
        
        NSLog(@"Key ID for selected device type is -- %@ ",strDeviceTypeID);
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
//    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] init];
////    touchGesture.cancelsTouchesInView = NO;
//    [touchGesture setDelegate:self];
//    [self.view addGestureRecognizer:touchGesture];

}

-(void)cancelPicker:(id)sender{
	
    
    if(pickerView.window){
        [pickerView resignFirstResponder];
        
        NSInteger row = [pickerView selectedRowInComponent:0];
        
        NSArray *values = [dicDeviceType allValues];
        
        if ([values count] != 0)
            self.txtDevice_Type_ID.text = [values objectAtIndex:row];
        
        [self.txtDevice_Type_ID resignFirstResponder];
            
    }
    
    else if(self.txtRegister_Expire_Date.inputView.window){
        
        [df setDateFormat:@"MM/dd/yyyy"];
        
        
        self.txtRegister_Expire_Date.text= [NSString stringWithFormat:@"%@",
                                 [df stringFromDate:MyDatePicker.date]];
        
        
        [self textFieldShouldReturn:self.txtRegister_Expire_Date];
        
    }
    
    else if([self.txtAvg_Consumption isFirstResponder]|| [self.txtCompany_Name isFirstResponder] || [self.txtDevice_Id isFirstResponder]||[self.txtId isFirstResponder]|| [self.txtMin_Fuel isFirstResponder] || [self.txtMin_Theft isFirstResponder]||[self.txtName isFirstResponder]|| [self.txtPhone isFirstResponder] || [self.txtTank_Capacity isFirstResponder]|| [self.txtVehicle_reg isFirstResponder] || [self.txtVehicle_Type isFirstResponder]){
        
          [self.view endEditing:YES];
            
        }
    
    
    
}



-(void)Back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void)viewDidLayoutSubviews{
    
    
//    scrollview.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 4.0);

    int type = [UIApplication sharedApplication].statusBarOrientation;
    
    NSLog(@"UIDevice orientation %ld and type = %d",[[UIDevice currentDevice] orientation],type);
    if (type == 1 || type == 2 ) {
        NSLog(@"portrait default");
        
        [scrollview setContentSize:CGSizeMake(SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT)];
        
    }
   
    else if(type ==3 || type ==4){
        NSLog(@"Landscape right");
        [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
        
    }
   
    
}


-(void)CheckNetworkAvailability{
    
    if ([objDelegate isNetworkAvailable]) {
        
        
       // [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        
        [self GetDefaultVehicleData];
        
        
    }
    
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
    
}

-(void)GetDefaultVehicleData
{
    
    NSLog(@"View Vehicle Information Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=getEditVehicleData",LiveURL];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&id=%@",objDelegate.strVehID];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    //start the connection
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
         
         if (error) {
             
             NSLog(@"--Its error inside  default veh detail  ---");
             
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
             
             
             if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                 
                 NSLog(@"its Dictionary");
                 
                 self.arrVehicleData= [jsonData valueForKey:@"vehicleData"];
                 
                  [self performSelectorOnMainThread:@selector(DisplayData) withObject:self.arrVehicleData waitUntilDone:NO];
                 
                 NSLog(@"arrVehicleData Data %@",[self.arrVehicleData description]);

             }
             
             if ([jsonData isKindOfClass:[NSArray class]]) { //1-2
                 
                 NSLog(@"its Array");
                 
                 
                 self.arrVehicleData= [jsonData valueForKey:@"vehicleData"];
                 
                
                  [self performSelectorOnMainThread:@selector(DisplayData) withObject:self.arrVehicleData waitUntilDone:NO];
                 
                 
             }
             
         }
         
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
    
    
}

-(void)DisplayData{
    
    
    
    if([[self.arrVehicleData valueForKey:@"device_id"]isEqual:[NSNull null]]){
        
        self.txtDevice_Id.text = @"";
        stroldDeviceId = @"";
        
    }
    
    else {
        
        self.txtDevice_Id.text = [self.arrVehicleData valueForKey:@"device_id"];
        stroldDeviceId = [self.arrVehicleData valueForKey:@"device_id"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"phone_number"]isEqual:[NSNull null]]){
        
        self.txtPhone.text = @"";
    }
    
    else {
        
        self.txtPhone.text = [self.arrVehicleData valueForKey:@"phone_number"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"vehicle_type"]isEqual:[NSNull null]]){
        
        self.txtVehicle_Type.text = @"";
    }
    
    else {
        
        self.txtVehicle_Type.text = [self.arrVehicleData valueForKey:@"vehicle_type"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"avg_consumption"]isEqual:[NSNull null]]){
        
        self.txtAvg_Consumption.text = @"";
    }
    
    else {
        
        self.txtAvg_Consumption.text = [self.arrVehicleData valueForKey:@"avg_consumption"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"tank_capacity"]isEqual:[NSNull null]]){
        
        self.txtTank_Capacity.text = @"";
    }
    
    else {
        
        self.txtTank_Capacity.text = [self.arrVehicleData valueForKey:@"tank_capacity"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"min_theft"]isEqual:[NSNull null]]){
        
        self.txtMin_Theft.text = @"";
    }
    
    else {
        
        self.txtMin_Theft.text = [self.arrVehicleData valueForKey:@"min_theft"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"device_type_id"]isEqual:[NSNull null]]){
        
        self.txtDevice_Type_ID.text = @"";
    }
    
    else {
        
        self.txtDevice_Type_ID.text = [dicDeviceType valueForKey:[self.arrVehicleData valueForKey:@"device_type_id"]];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"company_name"]isEqual:[NSNull null]]){
        
        self.txtCompany_Name.text = @"";
    }
    
    else {
        
        self.txtCompany_Name.text = [self.arrVehicleData valueForKey:@"company_name"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"name"]isEqual:[NSNull null]]){
        
        self.txtName.text = @"";
        stroldDeviceName = @"";
    }
    
    else {
        
        self.txtName.text = [self.arrVehicleData valueForKey:@"name"];
        stroldDeviceName = [self.arrVehicleData valueForKey:@"name"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"registr_expir_date"]isEqual:[NSNull null]]){
        
        self.txtRegister_Expire_Date.text = @"";
    }
    
    else {
        
        self.txtRegister_Expire_Date.text = [self.arrVehicleData valueForKey:@"registr_expir_date"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"min_fuelfill"]isEqual:[NSNull null]]){
        
        self.txtMin_Fuel.text = @"";
    }
    
    else {
        
        self.txtMin_Fuel.text = [self.arrVehicleData valueForKey:@"min_fuelfill"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"vehicle_reg"]isEqual:[NSNull null]]){
        
        self.txtVehicle_reg.text = @"";
    }
    
    else {
        
        self.txtVehicle_reg.text = [self.arrVehicleData valueForKey:@"vehicle_reg"];
        
    }
    
    
}

-(IBAction)Save:(id)sender{
    
    if([objDelegate isNetworkAvailable]) {
        
//        [self UploadData];
        
        
        for (UIView *subview in [scrollview subviews]) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subview;
                textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                NSLog(@"Trim string -->%@.",textField.text);
                
            }
        }
        
        if(self.txtDevice_Id.text.length >0 && self.txtName.text.length > 0 && self.txtDevice_Type_ID.text.length > 0)
            
            [self UploadData];
        
        else
        {
            
            strAlertString = @"Enter Device Name, Id and Type !!";
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        }
        
    }
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
}

-(void)CheckValidation{
    
    for (UIView *view in scrollview.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if([textField.text length]==0){
                
                int tag = (int)textField.tag;
    
                    switch (tag) {
                        case 104:{
                            
                            NSArray *values = [dicDeviceType allValues];
                            
                            if ([values count] != 0)
                                self.txtDevice_Type_ID.text = [values objectAtIndex:0];

                            break;
                        }
                            
                        case 109:
                            self.txtMin_Fuel.text = @"0";
                            break;
                            
                        case 110 :
                            
                            self.txtMin_Theft.text = @"0";
                            break;
                        case 111 :
                            
                            self.txtTank_Capacity.text = @"0";
                            break;
                        case 112 :
                            
                            self.txtAvg_Consumption.text = @"0";
                            break;
                        default:
                            break;
                    }
            }
        }
    }
}

-(void)UploadData{
    
    [self CheckValidation];
    
    NSString *strURL,*postString,*strDeviceTypeID;
    
   NSArray *arrKeys = [dicDeviceType allKeysForObject:self.txtDevice_Type_ID.text];
    
    if([arrKeys count]>0){
      strDeviceTypeID =  [arrKeys objectAtIndex:0];
    }
    
    NSLog(@"Key ID for selected device type is -- %@ ",strDeviceTypeID);
    
    
    if(self.isAdd){
        
        strURL =[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=addVehicle",LiveURL];
        
        postString =[NSString stringWithFormat:@"&device_id=%@&phone_number=%@&vehicle_type=%@&avg_consumption=%@&tank_capacity=%@&min_theft=%@&device_type_id=%@&company_name=%@&name=%@&registr_expir_date=%@&min_fuelfill=%@&vehicle_reg=%@&account_id=%@",self.txtDevice_Id.text,self.txtPhone.text,self.txtVehicle_Type.text,self.txtAvg_Consumption.text,self.txtTank_Capacity.text,self.txtMin_Theft.text,strDeviceTypeID,self.txtCompany_Name.text,self.txtName.text,self.txtRegister_Expire_Date.text,self.txtMin_Fuel.text,self.txtVehicle_reg.text,[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"]];
        
    }
    
    else{
        
        strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=updateVehicle",LiveURL];
        
        postString =[NSString stringWithFormat:@"&id=%@&device_id=%@&phone_number=%@&vehicle_type=%@&avg_consumption=%@&tank_capacity=%@&min_theft=%@&device_type_id=%@&company_name=%@&name=%@&registr_expir_date=%@&min_fuelfill=%@&vehicle_reg=%@&account_id=%@&oldname=%@&oldDeviceid=%@",[self.arrVehicleData valueForKey:@"id"],self.txtDevice_Id.text,self.txtPhone.text,self.txtVehicle_Type.text,self.txtAvg_Consumption.text,self.txtTank_Capacity.text,self.txtMin_Theft.text,strDeviceTypeID,self.txtCompany_Name.text,self.txtName.text,self.txtRegister_Expire_Date.text,self.txtMin_Fuel.text,self.txtVehicle_reg.text,[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],stroldDeviceName,stroldDeviceId];
    }
    
    NSLog(@"isAdd -> %hhd && strRL -> %@ && postString --> %@",self.isAdd,strURL,postString);
    
    [self UploadData:strURL PostString:postString];
    
}


-(void)UploadData:(NSString*)strURL PostString:(NSString*)postString{
    
    NSLog(@"Upload Data Called !! ");
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    
    //start the connection
    
    //    NSError *error = nil;
    //    NSURLResponse *response = nil;
    //
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];

         if (error) {
             
             strAlertString = @"Please try again later";
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
             
             NSLog(@"--Its error inside  upload data ---");
             
             
         }
         else{ //1
             
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData= [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
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
                 
                 else {
                     
                     [self performSelectorOnMainThread:@selector(showAlert:) withObject:[jsonData valueForKey:@"success"] waitUntilDone:NO];
                 }
                 
                 
             }
             
             
         }
         
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
    
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
//    NSArray *values = [dicDeviceType allValues];
//    
//    if ([values count] != 0)
//        self.txtDevice_Type_ID.text = [values objectAtIndex:0];
//    
//    NSString *strDeviceTypeID;
//    
//    NSArray *arrKeys = [dicDeviceType allKeysForObject:self.txtDevice_Type_ID.text];
//    
//    if([arrKeys count]>0){
//        strDeviceTypeID =  [arrKeys objectAtIndex:0];
//    }
//    
//    NSLog(@"Key ID for selected device type is -- %@ ",strDeviceTypeID);
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
//    [self textFieldShouldReturn:self.txtDevice_Type_ID];
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
    
    NSArray *values = [dicDeviceType allValues];
    
    if ([values count] != 0)
        strTitle = [values objectAtIndex:row];
    
    return strTitle;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
    NSArray *values = [dicDeviceType allValues];
    
    if ([values count] != 0)
        self.txtDevice_Type_ID.text = [values objectAtIndex:row];
    

//    [self.txtDevice_Type_ID resignFirstResponder];
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
    return [dicDeviceType count];
    
	
}


#pragma mark -
#pragma mark datePickerMode method


-(IBAction)showDatePicker:(id)sender{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        
        [sender resignFirstResponder];
        df = [[NSDateFormatter alloc] init];
        
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelDatePicker:)];
        [barItems addObject:doneBtn];
        doneBtn.tintColor = [UIColor whiteColor];

        [pickerToolbar setItems:barItems animated:YES];
        
        MyDatePicker = [[UIDatePicker alloc] init];
        MyDatePicker.datePickerMode = UIDatePickerModeDate;
        MyDatePicker.date = [NSDate date];
        MyDatePicker.maximumDate = [NSDate date];
        
     
        [df setDateFormat:@"yyyy-MM-dd"];
        
        
        self.txtRegister_Expire_Date.text = [df stringFromDate:MyDatePicker.date];
        
        CGRect pickerRect = MyDatePicker.bounds;
        MyDatePicker.bounds = pickerRect;
        
        UIViewController* popoverContent = [[UIViewController alloc] init];
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
        popoverView.backgroundColor = [UIColor whiteColor];
        
        MyDatePicker.frame = CGRectMake(0, 44, 320, 300);
        [MyDatePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
        [popoverView addSubview:pickerToolbar];
        [popoverView addSubview:MyDatePicker];
        popoverContent.view = popoverView;
        
        //resize the popover view shown
        //in the current view to the view's size
        popoverContent.preferredContentSize = CGSizeMake(320, 244);
        
        //create a popover controller
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        CGRect popoverRect = [self.view convertRect:[sender frame]
                                           fromView:[sender superview]];
        
        popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
        popoverRect.origin.x  = popoverRect.origin.x;
        // popoverRect.size.height  = ;
        [popoverController
         presentPopoverFromRect:popoverRect
         inView:self.view
         permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
        
    }
    
    else {
        
        
        MyDatePicker = [[UIDatePicker alloc] init];
        MyDatePicker.datePickerMode = UIDatePickerModeDate;
        [df setDateFormat:@"yyyy-MM-dd"];
        
        MyDatePicker.date = [NSDate date];
        MyDatePicker.maximumDate = [NSDate date];
        
        //        UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        //        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        //        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker:)];
        //        [toolbar setItems:[NSArray arrayWithObjects:btnDone, nil]];
        
        
        self.txtRegister_Expire_Date.inputView = MyDatePicker;
        
        self.txtRegister_Expire_Date.text = [df stringFromDate:MyDatePicker.date];
        
       
        [MyDatePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
        
        // OLD CODE
        
//        ac=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//        
//        MyDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, 320, 350)];
//        
//        MyDatePicker.datePickerMode = UIDatePickerModeDate;
//        [MyDatePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
//        MyDatePicker.hidden = NO;
//        MyDatePicker.date = [NSDate date];
//        MyDatePicker.maximumDate = [NSDate date];
//        //  MyDatePicker.minimumDate=[NSDate date];
//        
//        [df setDateFormat:@"yyyy-MM-dd"];
//        
//        
//        self.txtRegister_Expire_Date.text = [df stringFromDate:MyDatePicker.date];
//        
//        
//        UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
//        
//        UIButton *btndone = [UIButton buttonWithType:UIButtonTypeCustom];
//        btndone.frame = CGRectMake(250, 5, 60, 30);
//        [[btndone titleLabel] setFont:[UIFont fontWithName:@"Helvetica Bold " size:15]];
//        [btndone setTitle:@"Done" forState:UIControlStateNormal];
//        [btndone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btndone setBackgroundImage:[UIImage imageNamed:@"search-criteria.png"] forState:UIControlStateNormal];
//        [btndone addTarget:self action:@selector(cancelDatePicker:) forControlEvents:UIControlEventTouchDown];
//        
//        
//        [ac addSubview:toolbar];
//        [toolbar addSubview:btndone];
//        
//        
//        [ac addSubview:MyDatePicker];
//        
//        [ac showInView:self.view];
//        [ac setBounds:CGRectMake(0,0,320,400)];
    
    }
}


- (void)updateDateField:(UITextField*)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.txtRegister_Expire_Date.inputView;
    self.txtRegister_Expire_Date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:picker.date]];
    
//    [sender resignFirstResponder];

}

-(void)cancelDatePicker:(id)sender{
    
	[ac dismissWithClickedButtonIndex:0 animated:YES];
 
    
//    self.txtRegister_Expire_Date.text= [NSString stringWithFormat:@"%@",
//                           [df stringFromDate:MyDatePicker.date]];

    [self textFieldShouldReturn:self.txtRegister_Expire_Date];
        
   
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
        popoverController=nil;
    }
	
}

-(void)changeDate{
    
    
    self.txtRegister_Expire_Date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:MyDatePicker.date]];
   
    
}


#pragma mark -
#pragma mark textField method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL isequal = YES;
    
    NSCharacterSet *invalidCharSet =[[NSCharacterSet alloc]init];
    
    if(textField==self.txtPhone){
        
        invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+*#- "] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        isequal =  [string isEqualToString:filtered];
    }
    
    
    if(textField==self.txtMin_Fuel || textField==self.txtMin_Theft||textField==self.txtTank_Capacity || textField==self.txtAvg_Consumption ){
        
        
        invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        isequal =  [string isEqualToString:filtered];
    }
    
    return isequal;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == self.txtDevice_Type_ID){
        
//        [self showPickerView:self.txtDevice_Type_ID];
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtDevice_Type_ID.inputView = pickerView;
        
//        return NO;
    }
    
    else if(textField == self.txtRegister_Expire_Date){
        
        [self showDatePicker:self.txtRegister_Expire_Date];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
            return NO;
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
	[textField resignFirstResponder];
	return YES;
	
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
