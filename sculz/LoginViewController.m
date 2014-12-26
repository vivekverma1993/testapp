//
//  LoginViewController.m
//  sculz
//
//  Created by veddislabs on 22/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "NearbySchoolViewController.h"
#import "schoolViewController.h"
#import "ViewController.h"
#import "dataModel.h"
#import "ServerManager.h"
#import "user.h"

@interface LoginViewController ()
@property (nonatomic) UIImageView *Logo;
@property (nonatomic) UIView *userAndPass;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UITextField *username;
@property (nonatomic) UITextField *password;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIActivityIndicatorView *mySpinner;




@end

@implementation LoginViewController


-(void)makeAlert:(NSString *) message{
    self.alertController = [UIAlertController
                            alertControllerWithTitle:@""
                            message:[NSString stringWithFormat:@"%@",message]
                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    
    [self.alertController addAction:cancelAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
}


// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
    [textField becomeFirstResponder];
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard{
    if(self.username.isFirstResponder){
        [self.username resignFirstResponder];
    }
    else{
        [self.password resignFirstResponder];
    }
}

-(void)loginAction{
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    if(username.length==0 || password.length==0){
        [self makeAlert:@"please enter valid credentials"];
    }
    else{
        [self.mySpinner startAnimating];
        [[ServerManager sharedManager] isLoggedIn:username :password];
    }
    
}

-(void)loginSuccess:(NSNotification *)loginInfo{
    [self makeAlert:@"logged in"];
    NSDictionary *dict = [loginInfo userInfo];
    int idOfUser = (int)[[dict objectForKey:@"id"] integerValue];
    NSString *name = [dict objectForKey:@"name"];
    user *prUsr = [[user alloc] initWithIdU:idOfUser name:name address:@"" contact:@""];
    [[dataModel sharedManager] setPresentUser:prUsr];
    
    [self setupViewControllers];
    [self customizeInterface];
    [[ServerManager sharedManager] getNearbySchools:28.661039 :77.274277 :[NSString stringWithFormat:@"%d",((user*)[[dataModel sharedManager] presentUser]).idU]];
    [[[dataModel sharedManager] window] setRootViewController:self.viewController];
    [[[dataModel sharedManager] window] makeKeyAndVisible];
}

-(void)loginFaliure:(NSNotification *)loginInfo{
    NSDictionary *dict = [loginInfo userInfo];
    [self makeAlert:[dict objectForKey:@"reason"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UIColor * bColor = [UIColor colorWithRed:255/255.0f green:197/255.0f blue:1/255.0f alpha:1.0f];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG"]];
    self.Logo = [[UIImageView alloc] initWithFrame:CGRectMake(75, 100 ,170 , 80)];
    self.Logo.image = [UIImage imageNamed:@"Logo"];
    
    self.userAndPass = [[UIView alloc] initWithFrame:CGRectMake(35, 200, 250, 150)];
    self.userAndPass.layer.cornerRadius = 75.0f;
    self.userAndPass.backgroundColor = [UIColor colorWithRed:10/255.0f green:122/255.0f blue:252/255.0f alpha:1.0f];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(5, 74.75, 240, 0.5)];
    seperator.backgroundColor = [UIColor brownColor];
  
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(40, 30, 160, 44.75)];
    self.username.userInteractionEnabled = true;
    [self.username setFont:[UIFont boldSystemFontOfSize:16]];
    self.username.placeholder = @"Username";
    self.username.textAlignment = NSTextAlignmentCenter;
    self.username.delegate = self;

    
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(40, 75.25, 160, 44.75)];
    self.password.userInteractionEnabled = true;
    [self.password setFont:[UIFont boldSystemFontOfSize:16]];
    self.password.placeholder = @"Password";
    self.password.textAlignment = NSTextAlignmentCenter;
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    
    
    self.loginButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButton setFrame:CGRectMake(75, 400, 170, 50)];
    self.loginButton.layer.cornerRadius = 15.0f;
    
    UILabel *logText = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 120, 40)];
    logText.text = @"Login";
    logText.textColor = [UIColor whiteColor];
    logText.textAlignment = NSTextAlignmentCenter;
    logText.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
    
    [self.loginButton addSubview:logText];
    
    [self.view addSubview:self.Logo];
    [self.userAndPass addSubview:seperator];
    [self.userAndPass addSubview:self.username];
    [self.userAndPass addSubview:self.password];
    [self.view addSubview:self.userAndPass];
    [self.view addSubview:self.loginButton];
    
    self.mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.mySpinner.center = CGPointMake(160, 240);
    self.mySpinner.hidesWhenStopped = YES;
    [self.view addSubview:self.mySpinner];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:@"loginSuccessful"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginFaliure:)
                                                 name:@"loginUnSuccessful"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"hey!!!!");
    [self setupViewControllers];
    [self customizeInterface];
    if ([[segue identifier] isEqualToString:@"isloggedin"])
    {
        // Get reference to the destination view controller
        ViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.myViewController = self.viewController;
    }
    
}*/

#pragma mark - Methods

- (void)setupViewControllers {
    UIViewController *firstViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"nearby"];
    
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[schoolViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[NearbySchoolViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController]];
    
    self.viewController = tabBarController;
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}


@end
