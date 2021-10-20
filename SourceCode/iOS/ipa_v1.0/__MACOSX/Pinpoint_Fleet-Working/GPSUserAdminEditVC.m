//
//  GPSUserAdminEditVC.m
//  OpenGTS
//
//  Created by Guest User on 16/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSUserAdminEditVC.h"

#define SCROLLVIEW_HEIGHT 460
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 900
#define SCROLLVIEW_CONTENT_WIDTH  320


@interface GPSUserAdminEditVC ()

@end

@implementation GPSUserAdminEditVC

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
    
 
    UIImage *imgBack = [UIImage imageNamed:@"back-icon.png"];
    UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnback setFrame:CGRectMake(0, 0, 30, 22)];
    [btnback setBackgroundImage:imgBack forState:UIControlStateNormal];
     UIBarButtonItem *_backButton= [[UIBarButtonItem alloc] initWithCustomView:btnback];
    _backButton.style =UIBarButtonItemStyleDone;
    [btnback addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchDown];
    
    
    
    UIBarButtonItem *EditButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Edit:)];
    
    EditButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *SaveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Done:)];
    
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
  
    scrollview.scrollsToTop=NO;
    
    NSString *fileString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"timezone" ofType:@"txt"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    arrTimezone=[NSMutableArray arrayWithArray:[fileString componentsSeparatedByString:@"\n"]];
    [self PullData];
    
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


-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews{
    
//    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
    
    scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
//    scrollview.frame = CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
//    scrollview.scrollsToTop = NO;

}

-(void)PullData{
    
    if ([objDelegate isNetworkAvailable]) {
        
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
            
            [self GetDefaultUserDetail];
//            [self DisplayData];
            
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

-(void)GetDefaultUserDetail
{
        
    NSLog(@"View Vehicle Information Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=dafaultEditUserAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&userID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],self.strVehicleID];
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
            
            self.arrVehicleData= jsonData;
        }
        
        if ([jsonData isKindOfClass:[NSArray class]]) { //1-2
            
            NSLog(@"its Array");
            
            
            self.arrVehicleData= jsonData;
            
            
            NSLog(@"arrVehicleData Data %@",[self.arrVehicleData description]);
            
        }
        
    }
    
    //  }];
    
    [hud show:YES];
    
    
}

-(void)DisplayData{
    
//    NSLog(@"objAppDElegate.strAccountID == %@",objDelegate.strAccountID);
//    NSLog(@"NSUserDefaults standardUserDefaults == %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"]);
//
//        ;
//    
//    txtAccountID.text = objDelegate.strAccountID;
    
    
    if([[self.arrVehicleData valueForKey:@"userID"]isEqual:[NSNull null]]){
        
        txtUserID.text = @"";
    }
    
    else {
        
        txtUserID.text = [self.arrVehicleData valueForKey:@"userID"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_name"]isEqual:[NSNull null]]){
        
        txtName.text = @"";
    }
    
    else {
        
        txtName.text = [self.arrVehicleData valueForKey:@"u_name"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_pass"]isEqual:[NSNull null]]){
        
        txtPassword.text = @"";
    }
    
    else {
        
        txtPassword.text = [self.arrVehicleData valueForKey:@"u_pass"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_contact"]isEqual:[NSNull null]]){
        
        txtContact.text = @"";
    }
    
    else {
        
        txtContact.text = [self.arrVehicleData valueForKey:@"u_contact"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_phone"]isEqual:[NSNull null]]){
        
        txtPhone.text = @"";
    }
    
    else {
        
        txtPhone.text = [self.arrVehicleData valueForKey:@"u_phone"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_email"]isEqual:[NSNull null]]){
        
        txtEmail.text = @"";
    }
    
    else {
        
        txtEmail.text = [self.arrVehicleData valueForKey:@"u_email"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_notify"]isEqual:[NSNull null]]){
        
        txtNotify.text = @"";
    }
    
    else {
        
        txtNotify.text = [self.arrVehicleData valueForKey:@"u_notify"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_tmz"]isEqual:[NSNull null]]){
        
        txtTimezone.text = @"";
    }
    
    else {
        
        txtTimezone.text = [self.arrVehicleData valueForKey:@"u_tmz"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_dg_0"]isEqual:[NSNull null]]){
        
        txtAuthGroup.text = @"";
    }
    
    else {
        
        txtAuthGroup.text = [self.arrVehicleData valueForKey:@"u_dg_0"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_1stpage"]isEqual:[NSNull null]]){
        
        txtFistPage.text = @"";
    }
    
    else {
        
        txtFistPage.text = [self.arrVehicleData valueForKey:@"u_1stpage"];
        
    }
    
    
    if([[self.arrVehicleData valueForKey:@"u_active"]isEqualToString:@"Yes"]){
        
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

-(IBAction)Done:(id)sender{
    
    if([objDelegate isNetworkAvailable]) {
    
        [self UploadData];
    
    }
    else{
    
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Sorry !" message:@"Network is unavailable.Pleae try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [av show];
        
        });
    
    
}
}

-(void)UploadData{
    
    NSLog(@"Upload Data Called !! ");
    
//    NSString *strActive;
//    
//    if(swActive.selected == YES)
//        strActive = @"Yes";
//    else
//        strActive = @"No";
    
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=editUserAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    NSString *postString =[NSString stringWithFormat:@"&u_id=%@&userID=%@&u_name=%@&u_pass=%@&u_contact=%@&u_phone=%@&u_email=%@&u_notify=%@&u_tmz=%@&u_dg_0=%@&u_1stpage=%@&u_active=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],self.strVehicleID,txtName.text,txtPassword.text,txtContact.text,txtPhone.text,txtEmail.text,txtNotify.text,txtTimezone.text,txtAuthGroup.text,txtFistPage.text,strActive];
    
    
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
#pragma mark pickerview method

-(IBAction)showPickerView:(UITextField*)sender{
	
	ac=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,50,320,350)];
	pickerView.hidden=NO;
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	[pickerView selectRow:0 inComponent:0 animated:NO];
    
    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
	
	UIButton*btndone = [UIButton buttonWithType:UIButtonTypeCustom];
	btndone.frame = CGRectMake(250, 5, 60, 30);
    [[btndone titleLabel] setFont:[UIFont fontWithName:@"Helvetica Bold " size:15]];
    [btndone setTitle:@"Done" forState:UIControlStateNormal];
    [btndone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btndone setBackgroundImage:[UIImage imageNamed:@"search-criteria.png"] forState:UIControlStateNormal];
	[btndone addTarget:self action:@selector(cancelDiscountPickerView:) forControlEvents:UIControlEventTouchDown];
	
	[ac addSubview:toolbar];
	[toolbar addSubview:btndone];
	
	[ac addSubview:pickerView];
	
	[ac showInView:self.view];
   	[ac setBounds:CGRectMake(0,0,320,400)];
    
}

-(void)cancelDiscountPickerView:(id)sender{
	
	[ac dismissWithClickedButtonIndex:0 animated:YES];

    [self textFieldShouldReturn:txtTimezone];
    
	
}

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
    
    strTitle= [arrTimezone objectAtIndex:row];
    
    return strTitle;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
        txtTimezone.text = [arrTimezone objectAtIndex:row];
    
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
		return [arrTimezone count];
        
    


}



#pragma mark -
#pragma mark textField method


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
//    if(textField == txtUserID){
//        [scrollview setContentOffset:CGPointMake(0,0)  animated:TRUE];
//    }
    
//    if(textField == txtName){
//        [scrollview setContentOffset:CGPointMake(0,0)  animated:TRUE];
//    }
//    
//    if(textField == txtPassword){
//        [scrollview setContentOffset:CGPointMake(0,20)  animated:TRUE];
//    }
//    
//    
//    if(textField == txtContact){
//        [scrollview setContentOffset:CGPointMake(0,30)  animated:TRUE];
//    }
//    
//    if(textField == txtPhone){
//        [scrollview setContentOffset:CGPointMake(0,80)  animated:TRUE];
//    }
//    
//    if(textField == txtEmail){
//        [scrollview setContentOffset:CGPointMake(0,150)  animated:TRUE];
//    }
//    
//    if(textField == txtNotify){
//        [scrollview setContentOffset:CGPointMake(0,150)  animated:TRUE];
//    }
//    
    if(textField == txtTimezone){
        
        [self showPickerView:txtTimezone];
        
        return NO;
    }
//    
//    if(textField == txtAuthGroup){
//        [scrollview setContentOffset:CGPointMake(0,30)  animated:TRUE];
//    }
//    
//    if(textField == txtFistPage){
//        [scrollview setContentOffset:CGPointMake(0,70)  animated:TRUE];
//    }
    
//    CGPoint scrollPoint = CGPointMake( self.view.frame.origin.x, self.view.frame.origin.y-50);
//[scrollview setContentOffset:CGPointZero animated:YES];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if(textField == txtFistPage){
//        
//        [scrollview setContentOffset:CGPointMake(0, self.view.frame.origin.y) animated:YES];
//        
//    }
    
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

@end
