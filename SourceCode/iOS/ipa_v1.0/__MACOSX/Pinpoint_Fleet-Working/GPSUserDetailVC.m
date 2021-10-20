//
//  GPSEditUSerVcViewController.m
//  PinPoint
//
//  Created by Guest User on 28/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSUserDetailVC.h"
#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"

#define SCROLLVIEW_HEIGHT 460
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 900
#define SCROLLVIEW_CONTENT_WIDTH  320


@interface GPSUserDetailVC () {
    
    MBProgressHUD *hud;
    
    GPSAppDelegate *objDelegate;
    
    NSString *strAlertString;
    
    IBOutlet UIScrollView *scrollview;
    
    BOOL keyboardVisible;
    
    CGPoint	offset;
    
    NSArray *arrTimezone;
    
    UIPickerView *pickerView;
    
    UIActionSheet *ac;

}

@property (strong, nonatomic) IBOutlet UITextField *txtAddress,*txtCity,*txtCompany,*txtContact_Person,*txtPassword,*txtPhone,*txtSkype,*txtTimezone,*txtUserName,*txtWebsite,*txtCountry,*txtZip;

@end

@implementation GPSUserDetailVC

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
    
    self.strName = [[NSString alloc]init];
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
    
    if(self.isAdd)
    {
        
        self.navigationItem.title = @"Add User";

    }
    else {
        
        self.navigationItem.title = @"User Detail";

    }
    

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino-bold" size:22]}];
        
    }
    
    else {
        
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
        
        
    }
    UIBarButtonItem *Savebtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    
    Savebtn.enabled = TRUE;
    
    Savebtn.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = Savebtn;
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    
    btnBack.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = btnBack;
    self.arrVehicleData = [[NSArray alloc]init];
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    
    NSString *fileString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"timezone" ofType:@"txt"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    arrTimezone=[NSArray arrayWithArray:[fileString componentsSeparatedByString:@"\n"]];
    
    
    if(!self.isAdd){
        
        self.txtUserName.userInteractionEnabled = FALSE;
        
        [self CheckNetworkAvailability];

    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    
}

-(void)cancelPicker:(id)sender{
	
    
    if(pickerView.window){
        [pickerView resignFirstResponder];
        
        NSInteger row = [pickerView selectedRowInComponent:0];
        
        
        self.txtTimezone.text = [arrTimezone objectAtIndex:row];
        
        [self.txtTimezone resignFirstResponder];
            
        
    }
    
    else if([self.txtAddress isFirstResponder]|| [self.txtCity isFirstResponder] || [self.txtCompany isFirstResponder]||[self.txtContact_Person isFirstResponder]|| [self.txtCountry isFirstResponder] || [self.txtPassword isFirstResponder]||[self.txtPhone isFirstResponder]|| [self.txtSkype isFirstResponder] || [self.txtUserName isFirstResponder]|| [self.txtWebsite isFirstResponder] || [self.txtZip isFirstResponder]){
        
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
    
    scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
    
}

-(void)CheckNetworkAvailability{
    
    if ([objDelegate isNetworkAvailable]) {
        
      
       // [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        
        [self GetDefaultUserDetail];
     
    }
    
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
    
}

-(void)GetDefaultUserDetail
{
    
    NSLog(@"View Vehicle Information Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=dafaultEditUserAdmin",LiveURL];
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&username=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],objDelegate.strUserName];
    
    NSLog(@"Default user-- %@",postString);
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
        id jsonData      = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            NSLog(@"its Dictionary");
            
            self.arrVehicleData= jsonData;
            
            [self performSelectorOnMainThread:@selector(DisplayData) withObject:self.arrVehicleData waitUntilDone:NO];
            
            NSLog(@"arrVehicleData Data %@",[self.arrVehicleData description]);
        }
        
        if ([jsonData isKindOfClass:[NSArray class]]) { //1-2
            
            NSLog(@"its Array");
            
            
            self.arrVehicleData= jsonData;
            
            [self performSelectorOnMainThread:@selector(DisplayData) withObject:strAlertString waitUntilDone:NO];
            
            
            NSLog(@"arrVehicleData Data %@",[self.arrVehicleData description]);
            
        }
        
    }
    
    }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
    
    
}

-(void)DisplayData{

    
    
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
    
    if([[self.arrVehicleData valueForKey:@"company"]isEqual:[NSNull null]]){
        
        self.txtCompany.text = @"";
    }
    
    else {
        
        self.txtCompany.text = [self.arrVehicleData valueForKey:@"company"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"contact_person"]isEqual:[NSNull null]]){
        
        self.txtContact_Person.text = @"";
    }
    
    else {
        
        self.txtContact_Person.text = [self.arrVehicleData valueForKey:@"contact_person"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"password"]isEqual:[NSNull null]]){
        
        self.txtPassword.text = @"";
    }
    
    else {
        
        self.txtPassword.placeholder = @"****";
        
    }
    
    if([[self.arrVehicleData valueForKey:@"phone_number"]isEqual:[NSNull null]]){
        
        self.txtPhone.text = @"";
    }
    
    else {
        
        self.txtPhone.text = [self.arrVehicleData valueForKey:@"phone_number"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"skype"]isEqual:[NSNull null]]){
        
        self.txtSkype.text = @"";
    }
    
    else {
        
        self.txtSkype.text = [self.arrVehicleData valueForKey:@"skype"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"u_tmz"]isEqual:[NSNull null]]){
        
        self.txtTimezone.text = @"";
    }
    
    else {
        
        self.txtTimezone.text = [self.arrVehicleData valueForKey:@"u_tmz"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"username"]isEqual:[NSNull null]]){
        
        self.txtUserName.text = @"";
    }
    
    else {
        
        self.txtUserName.text = [self.arrVehicleData valueForKey:@"username"];
        
    }
    
    if([[self.arrVehicleData valueForKey:@"website"]isEqual:[NSNull null]]){
        
        self.txtWebsite.text = @"";
    }
    
    else {
        
        self.txtWebsite.text = [self.arrVehicleData valueForKey:@"website"];
        
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
        
        if(self.txtUserName.text.length >0 && self.txtPassword.text.length >0)
            
            [self UploadData];
        
        else
        {
            
            strAlertString = @"Enter User Name & Password !!";
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        }
        
    }
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
}

-(void)UploadData{
    
    NSString *strURL,*postString;
    
    // Both Edit and Add have same URL & Pass static Action-Type.
    
    strURL =[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=editAddUserAdmin",LiveURL];
    
    if(self.isAdd){
        
        
       
          postString =[NSString stringWithFormat:@"&accountID=%@&username=%@&password=%@&company=%@&website=%@&contact_person=%@&phone_number=%@&skype=%@&address=%@&account_tmz=%@&city=%@&actiontype=Add&country=%@&zip=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],self.txtUserName.text,self.txtPassword.text,self.txtCompany.text,self.txtWebsite.text,self.txtContact_Person.text,self.txtPhone.text,self.txtSkype.text,self.txtAddress.text,self.txtTimezone.text,self.txtCity.text,self.txtCountry.text,self.txtZip.text];
    }
    
    else{
        
        
      
        
         postString =[NSString stringWithFormat:@"&accountID=%@&username=%@&password=%@&company=%@&website=%@&contact_person=%@&phone_number=%@&skype=%@&address=%@&account_tmz=%@&city=%@&actiontype=Edit",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],[self.arrVehicleData valueForKey:@"username"],self.txtPassword.text,self.txtCompany.text,self.txtWebsite.text,self.txtContact_Person.text,self.txtPhone.text,self.txtSkype.text,self.txtAddress.text,self.txtTimezone.text,self.txtCity.text];
    }
    
//    NSLog(@"isAdd -> %hhd && strRL -> %@ && postString --> %@",self.isAdd,strURL,postString);
    
    [self UploadData:strURL PostString:postString];
    
}


-(void)UploadData:(NSString*)strURL PostString:(NSString*)postString{
    
    NSLog(@"Upload Data Called !! ");
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
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
//    [self textFieldShouldReturn:self.txtTimezone];
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
    
    strTitle= [arrTimezone objectAtIndex:row];
    
    return strTitle;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.txtTimezone.text = [arrTimezone objectAtIndex:row];
    
//    [self.txtTimezone resignFirstResponder];
    
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
    return [arrTimezone count];
    
}

#pragma mark -
#pragma mark textField method

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == self.txtTimezone){
        
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtTimezone.inputView = pickerView;
        
//        [self showPickerView:self.txtTimezone];
//        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
	[textField resignFirstResponder];
	return YES;
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL isequal = YES;
    
    NSCharacterSet *invalidCharSet =[[NSCharacterSet alloc]init];
    
    if(textField==self.txtPhone){
        
        invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+*#- "] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        isequal =  [string isEqualToString:filtered];
    }
    
    if(textField==self.txtZip  ){
        
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
