//
//  GPSLoginVC.m
//  PinPoint
//
//  Created by Sandip Rudani on 22/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSLoginVC.h"

#import "MBProgressHUD.h"

#import "GPSAppDelegate.h"

#import "GPSMapVC.h"

#import "GPSRootViewController.h"

@interface GPSLoginVC (){
    
    IBOutlet UIImageView *imgVw;
    
    GPSAppDelegate *objDelegate;
    
    MBProgressHUD *hud;
    
    NSString *strAlertString;

}

@property(nonatomic,retain)IBOutlet UITextField *txtUserName,*txtPassword;

@end

@implementation GPSLoginVC

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
    
    NSLog(@"Login self.view bound %f %f %f %f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);

    objDelegate= (GPSAppDelegate*)[[UIApplication sharedApplication] delegate];

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Login"]){
        
//        [self performSegueWithIdentifier:@"LogInResponsesegue" sender:self];
//        UIStoryboard *storyboard;
//        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
//           storyboard  = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//        }
//        else {
//           storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        }
        
        objDelegate= [[UIApplication sharedApplication] delegate];
        
//        UIStoryboard *storyboard;
//        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
//            storyboard  = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//        }
//        else {
//            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        }
        UIViewController *maincontroller = (GPSRootViewController*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"rootController"];

        
        objDelegate.window.rootViewController = maincontroller;
        
        [objDelegate.window makeKeyAndVisible];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    objDelegate = (GPSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = YES;
    
    imgVw.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgVw.layer.borderWidth = 1.5;
    imgVw.layer.cornerRadius = 10.0;
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    //    [hud setTintColor:[UIColor lightTextColor]];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Authenticating.."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    self.view.autoresizesSubviews = YES;
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleWidth |
//    UIViewAutoresizingFlexibleRightMargin;
////    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
}


- (IBAction)btnloginClicked:(id)sender {
    
    objDelegate= (GPSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
// static code
//    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Login"];
//    
////    [[NSUserDefaults standardUserDefaults]setValue:@"ROLE_ADMIN" forKey:@"userole"];
//
//
//    
//    UIStoryboard *storyboard;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
//        storyboard  = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//    }
//    else {
//        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//    }
//    UIViewController *maincontroller = (GPSRootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"rootController"];
//    
//    objDelegate.window.rootViewController = maincontroller;
//    
//    [objDelegate.window makeKeyAndVisible];

    
//    if(self.txtUserName.text.length >0 && self.txtPassword.text.length >0){
//        
//        if ([objDelegate isNetworkAvailable]) {
//            
//            [self checkValidUser];
//            
//        }
//        else{
//            
//            strAlertString = @"Please try again later";
//            
//            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
//        
//        }
//    }
//    
//    else {
//        
//        strAlertString = @"Username and Password are required !!";
//        
//        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
//        
//    }
    [self checkValidUser];
    
}

-(void) checkValidUser {

    
    NSLog(@"checkValidUser Called !! ");
    
  
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=auth",LiveURL];
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
//        NSString *postString =[NSString stringWithFormat:@"&userID=elevatedtech2013&password=omar16530"];
    NSString *postString =[NSString stringWithFormat:@"&userID=%@&password=%@",self.txtUserName.text,self.txtPassword.text];
    
    NSLog(@"login poststring -- %@",postString);
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
        
    //start the connection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         
         [hud hide:YES];
         
         if (error) {
             
             [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Login"];
             
             NSLog(@"Its error insode login ");
             
             strAlertString = @"Please try again later";
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
         }
         else{ //1
             
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
             NSLog(@"Return Data for Login %@",[jsonData description]);
             
            if ([jsonData isKindOfClass:[NSDictionary class]]){
                 
                 NSLog(@"its dictionary");

                 
              if([[jsonData valueForKey:@"success"]isEqualToString:@"False"] ){
                  
                  NSLog(@"success false login");

                  
                     [hud hide:YES];
                     
                     [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Login"];
                     
                     strAlertString = @"Please try again later";
                     
                     [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                 }
                
              else if ([[jsonData valueForKey:@"success"]isEqualToString:@"User is not active"]){
                  
                  [hud hide:YES];
                  
                  [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Login"];
                  
                  strAlertString = @"User is not active";
                   [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
              }
             
             else if ([[jsonData valueForKey:@"success"]isEqualToString:@"True"]) {
                 //1-2
                 NSLog(@"success true login");

                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Login"];

                //[[NSUserDefaults standardUserDefaults]setValue:self.txtUserName.text forKey:@"UserID"];
                 [[NSUserDefaults standardUserDefaults]setValue:[jsonData valueForKey:@"userId"]forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults]setValue:[jsonData valueForKey:@"account_id"]forKey:@"account_id"];
                [[NSUserDefaults standardUserDefaults]setValue:[jsonData valueForKey:@"userole"] forKey:@"userole"];
                [[NSUserDefaults standardUserDefaults]setValue:[jsonData valueForKey:@"account_tmz"] forKey:@"timezone"];
               //[[NSUserDefaults standardUserDefaults]setValue:[jsonData valueForKey:@"userId"] forKey:@"loginId"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 
                 
                 //[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Login"];
                 
//                 dispatch_async(dispatch_get_main_queue(), ^(void) { //1-4-4
//                     
//                     [hud hide:YES];
//                     
//                     [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"Login"];
//                     
//                  [self performSegueWithIdentifier:@"LogInResponsesegue" sender:self];
//                 });
                 
                 
//                 UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                 objDelegate= (GPSAppDelegate*)[[UIApplication sharedApplication] delegate];

                 UIStoryboard *storyboard;
                 if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
                     storyboard  = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
                 }
                 else {
                     storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                 }
                 UIViewController *maincontroller = (GPSRootViewController*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                 
                 objDelegate.window.rootViewController = maincontroller;
                 
                 [objDelegate.window makeKeyAndVisible];
                 
                 
                }
             
             }
             
         }
         
     }];
    
    [hud show:YES];
    
}

-(void)showAlert:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Login Failed !!" message:Title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//    GPSMapVC *vc = (GPSMapVC*)[segue destinationViewController];
//    vc.isfromLogin = TRUE;
    
}

#pragma mark -
#pragma mark textField method


//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    if(textField == self.txtUserName){
//        [scroll setContentOffset:CGPointMake(0,40)  animated:TRUE];
//    }
//    
//    if(textField == self.txtAuthentication){
//        [scroll setContentOffset:CGPointMake(0,80)  animated:TRUE];
//    }
//    
//    if(textField == self.txtPassword){
//        [scroll setContentOffset:CGPointMake(0,130)  animated:TRUE];
//    }
//    
//    
//    return YES;
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
	[textField resignFirstResponder];
	return YES;
	
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
