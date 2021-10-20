//
//  SMRootViewController.m
//  SlideMenu
//
//  Created by Sandip Rudani on 21/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSRootViewController.h"
#import "GPSLeftMenuVC.h"
#import "GPSRightMenuVC.h"
#import "GPSAppDelegate.h"
#import "GPSMapVC.h"

@interface GPSRootViewController (){
    
    GPSAppDelegate *objDelegate;
}

@end

@implementation GPSRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Login"]){
        
        
        // RESideMenu Stuff that Must Be Done
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];

        objDelegate = (GPSAppDelegate*)[[UIApplication sharedApplication]delegate];

        GPSMapVC *screen = (GPSMapVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"GPSMapVC"];
        UINavigationController *controller = [objDelegate.storyboard instantiateViewControllerWithIdentifier: @"contentViewController"];
        
        
        [controller setViewControllers:[NSArray arrayWithObject:screen] animated:YES];
        
        self.contentViewController = controller;
        
        self.leftMenuViewController = [objDelegate.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
        self.rightMenuViewController = [objDelegate.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
        
        
    }

    else {
        
        objDelegate = (GPSAppDelegate*)[[UIApplication sharedApplication]delegate];

        
        self.contentViewController = [objDelegate.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
        self.leftMenuViewController = [objDelegate.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
        self.rightMenuViewController = [objDelegate.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    }
    
//    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
//    self.contentViewShadowColor = [UIColor blackColor];
//    self.contentViewShadowOffset = CGSizeMake(0, 0);
//    self.contentViewShadowOpacity = 0.6;
//    self.contentViewShadowRadius = 12;
//    self.contentViewShadowEnabled = YES;
    
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.9;
    self.contentViewShadowRadius = 15;
    self.contentViewShadowEnabled = YES;
    

//    self.backgroundImage = [UIImage imageNamed:@"bg.png"];
    
    
    
    self.delegate = self;


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    objDelegate = [[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
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
