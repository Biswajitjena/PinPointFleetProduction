//
//  GPSVehInfoDEtailVC.m
//  OpenGTS
//
//  Created by Sandip Rudani on 12/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSVehInfoDEtailVC.h"

@interface GPSVehInfoDEtailVC ()

@end

@implementation GPSVehInfoDEtailVC

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
    
    objAppDelegate= (GPSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.arrVehicleData = [[NSMutableArray alloc]init];
    
//    UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(popBack)];
//    _backButton.tintColor = [UIColor whiteColor];
    
    UIImage *imgBack = [UIImage imageNamed:@"back-icon.png"];
    UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnback setFrame:CGRectMake(0, 0, 30, 22)];
    [btnback setBackgroundImage:imgBack forState:UIControlStateNormal];
    UIBarButtonItem *_backButton= [[UIBarButtonItem alloc] initWithCustomView:btnback];
    _backButton.style =UIBarButtonItemStyleDone;
    [btnback addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchDown];
    
  //  self.navigationItem.backBarButtonItem = _backButton;
    
    UIBarButtonItem *EditButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit:)];
    
    EditButton.tintColor = [UIColor whiteColor];
    
       UIBarButtonItem *SaveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    
    SaveButton.tintColor = [UIColor whiteColor];
    
    SaveButton.enabled = FALSE;
    
//    self.navigationItem.rightBarButtonItems = @[EditButton,SaveButton];
    
    self.navigationItem.leftBarButtonItems = @[_backButton,EditButton];
    
    self.navigationItem.rightBarButtonItem = SaveButton;
    
    
//    if ([[UINavigationBar appearance] respondsToSelector:@selector(setBarTintColor:)]) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/256.0 green:172.0/256.0 blue:164.0/256.0 alpha:1]];
//    }
//    else
//        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0/256.0 green:172.0/256.0 blue:164.0/256.0 alpha:1]];
    
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    for (UIView *view in [scrollview subviews] ){
        
        view.userInteractionEnabled = FALSE;
        
        view.alpha = 0.7;
        
    }
    [self PullData];
}


-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews{
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
    
}

-(void)PullData{
    
    if([objAppDelegate isNetworkAvailable]){
        hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
        
        if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
            [[UIView appearance] setTintColor:[UIColor lightTextColor]];
        }
     //   [hud setTintColor:[UIColor lightTextColor]];
        [hud setLabelText:@"Loading Data..."];
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud setAnimationType:MBProgressHUDAnimationFade];
        [self.view addSubview:hud];
        [hud show:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // NSLog(@"From Server !!");
            
            [self GetVehicleDetail];
          //  [self DisplayData];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [hud hide:YES];
                
                [self DisplayData];

                
            });
            
        });
        
    }
    
    else{
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Sorry !" message:@"Network is unavailable.Pleae try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [av show];
            
        });
    }
    
}

-(void)GetVehicleDetail
{
    
    NSLog(@"View Vehicle Information Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=getEditVehicleData"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&deviceID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],self.strVehicleID];
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
    
    
    if (error) {
        
        [hud hide:YES];
        
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        
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
            
            
            self.arrVehicleData=[jsonData valueForKey:@"vehicleData"];
            
            
            NSLog(@"arrVehicleData Data %@",[self.arrVehicleData description]);
            
        }
        
    }
    
    //  }];
    
    [hud show:YES];
    
    
}

-(void)DisplayData{
    
    
//    txtCreationDate.text = [self.arrVehicleData valueForKey:@"creationDate"];
//    txtDescription.text = [self.arrVehicleData valueForKey:@"description"];
//    txtDeviceID.text = [self.arrVehicleData valueForKey:@"deviceID"];
//    txtDriver.text = [self.arrVehicleData valueForKey:@"driverID"];
//    txtRptHours.text = [self.arrVehicleData valueForKey:@"engineHoursOffset"];
//    txtEquipType.text = [self.arrVehicleData valueForKey:@"equipmentType"];
//    txtFuelCap.text = [self.arrVehicleData valueForKey:@"fuelCapacity"];
//    txtIMEI.text = [self.arrVehicleData valueForKey:@"imeiNumber"];
//    txtLicPlate.text = [self.arrVehicleData valueForKey:@"licensePlate"];
//    txtRptOdomtr.text = [self.arrVehicleData valueForKey:@"odometerOffsetKM"];
//    txtSerialNum.text = [self.arrVehicleData valueForKey:@"serialNumber"];
//    txtName.text = [self.arrVehicleData valueForKey:@"shortName"];
//    txtUiniqueID.text = [self.arrVehicleData valueForKey:@"uniqueID"];
//    txtVehicleID.text = [self.arrVehicleData valueForKey:@"vehicleID"];
    
    if([[self.arrVehicleData valueForKey:@"creationDate"]isEqual:[NSNull null]]){
        
        txtCreationDate.text = @"";
    }
    
    else {
        
        txtCreationDate.text = [self.arrVehicleData valueForKey:@"creationDate"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"description"]isEqual:[NSNull null]]){
        
        txtDescription.text = @"";
    }
    
    else {
        
        txtDescription.text = [self.arrVehicleData valueForKey:@"description"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"deviceID"]isEqual:[NSNull null]]){
        
        txtDeviceID.text = @"";
    }
    
    else {
        
        txtDeviceID.text = [self.arrVehicleData valueForKey:@"deviceID"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"driverID"]isEqual:[NSNull null]]){
        
        txtDriver.text = @"";
    }
    
    else {
        
        txtDriver.text = [self.arrVehicleData valueForKey:@"driverID"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"engineHoursOffset"]isEqual:[NSNull null]]){
        
        txtRptHours.text = @"";
    }
    
    else {
        
        txtRptHours.text = [self.arrVehicleData valueForKey:@"engineHoursOffset"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"equipmentType"]isEqual:[NSNull null]]){
        
        txtEquipType.text = @"";
    }
    
    else {
        
        txtEquipType.text = [self.arrVehicleData valueForKey:@"equipmentType"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"fuelCapacity"]isEqual:[NSNull null]]){
        
        txtFuelCap.text = @"";
    }
    
    else {
        
        txtFuelCap.text = [self.arrVehicleData valueForKey:@"fuelCapacity"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"imeiNumber"]isEqual:[NSNull null]]){
        
        txtIMEI.text = @"";
    }
    
    else {
        
        txtIMEI.text = [self.arrVehicleData valueForKey:@"imeiNumber"];

    }
    
    if([[self.arrVehicleData valueForKey:@"licensePlate"]isEqual:[NSNull null]]){
        
        txtLicPlate.text = @"";
    }
    
    else {
        
        txtLicPlate.text = [self.arrVehicleData valueForKey:@"licensePlate"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"odometerOffsetKM"]isEqual:[NSNull null]]){
        
        txtRptOdomtr.text = @"";
    }
    
    else {
        
        txtRptOdomtr.text = [self.arrVehicleData valueForKey:@"odometerOffsetKM"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"serialNumber"]isEqual:[NSNull null]]){
        
        txtSerialNum.text = @"";
    }
    
    else {
        
        txtSerialNum.text = [self.arrVehicleData valueForKey:@"serialNumber"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"shortName"]isEqual:[NSNull null]]){
        
        txtName.text = @"";
    }
    
    else {
        
        txtName.text = [self.arrVehicleData valueForKey:@"shortName"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"simPhoneNumber"]isEqual:[NSNull null]]){
        
        txtSimPhone.text = @"";
    }
    
    else {
        
        txtSimPhone.text = [self.arrVehicleData valueForKey:@"simPhoneNumber"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"smsEmail"]isEqual:[NSNull null]]){
        
        txtSMSEmail.text = @"";
    }
    
    else {
        
        txtSMSEmail.text = [self.arrVehicleData valueForKey:@"smsEmail"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"uniqueID"]isEqual:[NSNull null]]){
        
        txtUiniqueID.text = @"";
    }
    
    else {
        
        txtUiniqueID.text = [self.arrVehicleData valueForKey:@"uniqueID"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"vehicleID"]isEqual:[NSNull null]]){
        
        txtVehicleID.text = @"";
    }
    
    else {
        
        txtVehicleID.text = [self.arrVehicleData valueForKey:@"vehicleID"];
        
    }
 
    if([[self.arrVehicleData valueForKey:@"isActive"]isEqualToString:@"Yes"]){
        
        swActive.on = YES;
        strActive = @"YES";
    }
    
    else {
        
        swActive.on = NO;
    
        strActive = @"NO";
    }


}

-(IBAction)Edit:(id)sender{
    
    
    
    if (!self.isEditable) {
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You don't have right to edit User Detail !!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [av show];
    }
    
    else {
        
        for (UIView *view in [scrollview subviews] ){
            
            view.userInteractionEnabled = TRUE;
            view.alpha = 1.0;
        }
        
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        
    }
}

-(IBAction)Save:(id)sender{
    
    [self UploadData];
}

-(void)UploadData{
    
    NSLog(@"Upload Data Called !! ");
    
//    NSString *strActive;
    
//    if(swActive.selected == YES)
//        strActive = @"Yes";
//    else
//        strActive = @"No";
    
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=updateVehicle"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&deviceID=%@&d_uniq=%@&d_actv=%@&d_desc=%@&d_name=%@&d_vehicid=%@&d_licPlate=%@&d_equipt=%@&d_imei=%@&d_sernum=%@&d_simph=%@&d_smsemail=%@&d_fuelcap=%@&d_driver=%@&d_rptodom=%@&d_rpthours=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],self.strVehicleID,txtUiniqueID.text,strActive,txtDescription.text,txtName.text,txtVehicleID.text,txtLicPlate.text,txtEquipType.text,txtIMEI.text,txtSerialNum.text,txtSimPhone.text,txtSMSEmail.text,txtFuelCap.text,txtDriver.text,txtRptOdomtr.text,txtRptHours.text];
    
    NSLog(@"Post String of vehicle info detail --> %@",postString);
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
    
    
    if (error) {
        
        [hud hide:YES];
        
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  upload data ---");
        
        
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
                
                [hud hide:YES];
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                [hud hide:YES];
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Upload Data Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            
        });
        
    }
    
    //  }];
    
    [hud show:YES];
    
}


-(IBAction)CheckSwitch:(id)sender{
    
    
    if(swActive.isOn){
        
        strActive=@"YES";
        
    }
    
    else {
        
        strActive=@"NO";
    }
    
}


#pragma mark -
#pragma mark textField method


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
//    if(textField == txtDeviceID){
//        [scrollview setContentOffset:CGPointMake(0,0)  animated:TRUE];
//    }
//    
//    if(textField == txtAccountID){
//        [scrollview setContentOffset:CGPointMake(0,0)  animated:TRUE];
//    }
//    
//    if(textField == txtUiniqueID){
//        [scrollview setContentOffset:CGPointMake(0,20)  animated:TRUE];
//    }
//    
//     
//    if(textField == txtDescription){
//        [scrollview setContentOffset:CGPointMake(0,30)  animated:TRUE];
//    }
//    
//    if(textField == txtName){
//        [scrollview setContentOffset:CGPointMake(0,80)  animated:TRUE];
//    }
//    
//    if(textField == txtVehicleID){
//        [scrollview setContentOffset:CGPointMake(0,150)  animated:TRUE];
//    }
//    
//    if(textField == txtLicPlate){
//        [scrollview setContentOffset:CGPointMake(0,150)  animated:TRUE];
//    }
//    
//    if(textField == txtEquipType){
//        [scrollview setContentOffset:CGPointMake(0,120)  animated:TRUE];
//    }
//    
//    if(textField == txtIMEI){
//        [scrollview setContentOffset:CGPointMake(0,30)  animated:TRUE];
//    }
//    
//    if(textField == txtSerialNum){
//        [scrollview setContentOffset:CGPointMake(0,70)  animated:TRUE];
//    }
//    
//    if(textField == txtSimPhone){
//        [scrollview setContentOffset:CGPointMake(0,120)  animated:TRUE];
//    }
//    
//    if(textField == txtSMSEmail){
//        [scrollview setContentOffset:CGPointMake(0,30)  animated:TRUE];
//    }
//    
//    if(textField == txtFuelCap){
//        [scrollview setContentOffset:CGPointMake(0,70)  animated:TRUE];
//    }
//    
//    if(textField == txtDriver){
//        [scrollview setContentOffset:CGPointMake(0,120)  animated:TRUE];
//    }
//    
//    if(textField == txtRptOdomtr){
//        [scrollview setContentOffset:CGPointMake(0,120)  animated:TRUE];
//    }
//    
//    if(textField == txtRptHours){
//        [scrollview setContentOffset:CGPointMake(0,30)  animated:TRUE];
//    }
//    
//    if(textField == txtCreationDate){
//        [scrollview setContentOffset:CGPointMake(0,70)  animated:TRUE];
//    }
        
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if(textField == txtCreationDate){
//        
//       [scrollview setContentOffset:CGPointMake(0, self.view.frame.origin.y) animated:YES];
//
//    }
//    
    //[scrollview setContentOffset:CGPointMake(0, self.view.frame.origin.y) animated:YES];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
