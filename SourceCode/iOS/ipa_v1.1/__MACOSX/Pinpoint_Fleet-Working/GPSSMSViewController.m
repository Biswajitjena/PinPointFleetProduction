//
//  GPSSMSViewController.m
//  PinPoint
//
//  Created by Sandip Rudani on 01/08/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSSMSViewController.h"

#define SCROLLVIEW_HEIGHT 460
#define SCROLLVIEW_WIDTH  320

#define SCROLLVIEW_CONTENT_HEIGHT 650
#define SCROLLVIEW_CONTENT_WIDTH  320

#define OutputType [NSArray arrayWithObjects: @"short with GSM override",@"open",@"short",nil]

#define ResponseVia [NSArray arrayWithObjects: @"UDP/TCP",@"SMS",nil]



@interface GPSSMSViewController (){
    
    GPSAppDelegate *objDelegate;
    
    UIPickerView *pickerView;
    UIActionSheet *ac;
    
    int i;
    
    NSArray *arrOPType,*arrResponseType;
    
    NSInteger intOPType1,intOPType2,intResponseType;
    
    IBOutlet UIScrollView *scrollview;
    
     NSString *strBody;

    NSString *strAlertString;

}

@property (strong, nonatomic) IBOutlet UITextField *txtPhone,*txtOPType1,*txtOPType2,*txtMin,*txtResponseType;


@end

@implementation GPSSMSViewController

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
    
    
    arrOPType = [[NSArray alloc]initWithArray:OutputType];
    
    arrResponseType = [[NSArray alloc]initWithArray:ResponseVia];
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
        [barAppearance setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
        self.navigationItem.standardAppearance = barAppearance;
        self.navigationItem.scrollEdgeAppearance = barAppearance;
    }
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
    
    self.navigationItem.title = @"Send Command";
    
    UIBarButtonItem *btnMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuView)];
    
    self.navigationItem.leftBarButtonItem = btnMenu;
    
    btnMenu.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *btnSMS = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sms.png"] style:UIBarButtonItemStyleDone target:self action:@selector(MessagePopUp:)];
    
    
    btnSMS.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = btnSMS;
    

    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino-bold" size:22]}];
        
    }
    
    else {
        
       
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
        
        
    }
    
    if(self.txtOPType1){
        

        
        self.txtOPType1.text = [arrOPType objectAtIndex:0];
        
        intOPType1  = 0;
        
//        i=0;
        
        
	}
    if (self.txtOPType2){
        

        
        self.txtOPType2.text = [arrOPType objectAtIndex:0];
        
        intOPType2  = 0;
        
//        i=1;
        
	}
    
     if(self.txtResponseType){
         

        
        self.txtResponseType.text = [arrResponseType objectAtIndex:0];
        
        intResponseType  = 1;
         
//         i=2;
        
	}
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    
}

-(void)cancelPicker:(id)sender{
	
    
    [pickerView resignFirstResponder];
    
    NSInteger row = [pickerView selectedRowInComponent:0];

    
	if(i==0){
        
        intOPType1 = row;
        
        self.txtOPType1.text = [arrOPType objectAtIndex:row];

        
        [self textFieldShouldReturn:self.txtOPType1];
        

        
    }
   else if(i==1){
        
        intOPType2 = row;
        
        self.txtOPType2.text = [arrOPType objectAtIndex:row];

        [self textFieldShouldReturn:self.txtOPType2];
        

    }
    
    else if(i==2){
        
        intResponseType = row;
        
        self.txtResponseType.text = [arrResponseType objectAtIndex:row];
        
        [self textFieldShouldReturn:self.txtResponseType];
        

    }
    
    
	
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.view) {
        return YES;
    } else {
        return NO;
    }
}
-(void)presentLeftMenuView{
    
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

-(void)viewDidLayoutSubviews{
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.5);
    
    NSLog(@"device orientaion %ld",[UIApplication sharedApplication].statusBarOrientation);
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication]  statusBarOrientation];
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown)
    {
        [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.5)];
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2.0)];
    }
    
//    int type = [[UIDevice currentDevice] orientation];
    
    int type = [UIApplication sharedApplication].statusBarOrientation;
    
    NSLog(@"UIDevice orientation %ld and type = %d",[[UIDevice currentDevice] orientation],type);
    if (type == 1) {
        NSLog(@"portrait default");
        
        [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100)];

    }
    else if(type ==2){
        NSLog(@"portrait upside");
        [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100)];

    }
    else if(type ==3){
        NSLog(@"Landscape right");
        [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2.0+50)];

    }
    else if(type ==4){
        NSLog(@"Landscape left");
        [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2.0+50)];

    }

//    if(([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)| UIDeviceOrientationPortraitUpsideDown)
//    {
//        
//    }
//    
//    
//    else if(([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft) | UIDeviceOrientationLandscapeRight)
//    
//    {
//    }

    NSLog(@"scroll contentSize %f",scrollview.contentSize.height);
    NSLog(@"scroll size %f",self.view.frame.size.height);
//    NSLog(@"scroll size 1.5 %f",self.view.frame.size.height*1.5);


    
}

#pragma mark -
#pragma mark pickerview method



//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//	
//	
//	int sectionWidth = 320;
//	
//	return sectionWidth;
//}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle;
    
    
    if(i==0){
        
        strTitle= [arrOPType objectAtIndex:row];
        
        
    }
    else if(i==1){
        
        strTitle= [arrOPType objectAtIndex:row];
    }
    
    else if(i==2){
        
        strTitle= [arrResponseType objectAtIndex:row];
    }
    
   
    
    return strTitle;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(i==0){
        
        self.txtOPType1.text = [arrOPType objectAtIndex:row];
        
        intOPType1  = row;
        
//        [self.txtOPType1 resignFirstResponder];
        
	}
	else if (i==1){
        
        self.txtOPType2.text = [arrOPType objectAtIndex:row];
        
        intOPType2 = row;
        
//        [self.txtOPType2 resignFirstResponder];

        
	}
    
    else if(i==2){
        
        self.txtResponseType.text = [arrResponseType objectAtIndex:row];
        
        intResponseType = row+1;
        
//        [self.txtResponseType resignFirstResponder];

        
	}
	
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	NSInteger row =0;
    if(i==0){
		row = [arrOPType count];
        
    }
    
    else if(i==1){
		row = [arrOPType count];
        
    }
    
    else if(i==2){
		row = [arrResponseType count];
        
    }
    
	return row;
	
}

#pragma mark -
#pragma mark MessageController method



-(NSString*)BodyMessage{
    
    strBody = @"";
    
    if(!(self.txtPhone.text.length==0 || self.txtPhone.text.length==0 || self.txtPhone.text.length==0 || self.txtPhone.text.length==0 || self.txtPhone.text.length==0)){
        
        int min =[self.txtMin.text intValue];
        
        NSLog(@"minutes --> %d",min);

        
        if(min ==0 || (min >= 5 && min <= 1440) ){
            
//            +XT:7005,<OT1>,<X>[,<OT2>,<MN >]
            strBody = [NSString stringWithFormat:@"+XT:7005,%ld,%ld[,%ld,%d]",(long)intOPType1,(long)intResponseType,(long)intOPType2,min];
            
            return strBody;
        }
        
        else {
            
            strAlertString = @"Please enter Minutes either 0 for disable or in between 5 - 1440";
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        }
        

    }
    
    else{
        
        strAlertString = @"All fields are required !!";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
    
    
    


    return strBody;
}

-(void)showAlert:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:Title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}


-(IBAction)MessagePopUp:(id)sender {
    
   NSString *strMsg= [self BodyMessage];
    
    if(!strMsg.length == 0){
        
  
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
        if([MFMessageComposeViewController canSendText])
        {
            
            controller.editing = FALSE;
            
            controller.body =strMsg;
            
            controller.recipients = @[self.txtPhone.text];
            
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
            
        }
    }
    
    
    
    
    
    
}
#pragma mark - Message Methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    
    if (result == MessageComposeResultCancelled){
        
        NSLog(@"Message cancelled");
        
    }
    
    else if (result == MessageComposeResultSent){
        
        NSLog(@"Message sent");
        
        
    }
    else  {
        NSLog(@"Message failed");
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -
#pragma mark textField method


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if(textField == self.txtOPType1){
        i=0;
        
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtOPType1.inputView = pickerView;

//        [self ShowPicker:self.txtOPType1];

//        return NO;
        
    }
    
    if(textField == self.txtOPType2){
        i=1;
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.txtOPType2.inputView = pickerView;

//        [self showPickerView:self.txtOPType2];
//        return NO;
        
    }
    
    if(textField == self.txtResponseType){
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        self.txtResponseType.inputView = pickerView;

        i=2;
//        [self showPickerView:self.txtResponseType];
//        return NO;
        
        
    }
    if(textField ==  self.txtMin)
    {
        
        
        [scrollview setContentOffset:CGPointMake(0,170)  animated:TRUE];
    
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField ==  self.txtMin)
    {
    
    [scrollview setContentOffset:CGPointMake(0,0)  animated:TRUE];

    }
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
    
  
    
    return isequal;
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
