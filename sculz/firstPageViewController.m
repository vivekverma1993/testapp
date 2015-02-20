//
//  firstPageViewController.m
//  sculz
//
//  Created by vivek verma on 04/02/15.
//  Copyright (c) 2015 self. All rights reserved.
//

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height
#define backcolor [UIColor colorWithRed:255/255.0f green:242/255.0f blue:204/255.0f alpha:1.0f]

#import "firstPageViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ServerManager.h"
#import "dataModel.h"
#import "user.h"
#import "school.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "NearbySchoolViewController.h"
#import "schoolViewController.h"
#import "NeabyMapViewController.h"
#import "DistrictSchoolsViewController.h"


@interface firstPageViewController ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *nSignUpbutton;
@property (strong, nonatomic) UIButton *nLogInButton;
@property (strong, nonatomic) UIImageView *logoView;
@property (strong, nonatomic) UIView *loginviewcontroller;
@property (strong, nonatomic) UIButton *cancelButton;
@property (nonatomic) UITextField *username;
@property (nonatomic) UITextField *password;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIButton *crossButton;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIActivityIndicatorView *mySpinner;
@property (nonatomic) BOOL visited;

// add cancel button in the login view

@end

@implementation firstPageViewController

@synthesize signInButton;

static NSString * const kClientId = @"680636833074-988ticslmk03kjah37ptmfav2t4798um.apps.googleusercontent.com";


#pragma mark alert view

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



#pragma mark keyboard delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"Text field did begin editing");
    [textField becomeFirstResponder];
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //NSLog(@"Text field ended editing");
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

#pragma mark signup view




#pragma mark login view methods


-(void)loginSuccessViaSocial:(NSDictionary *)dict{
    int idOfUser = (int)[[dict objectForKey:@"id"] integerValue];
    NSString *name = [dict objectForKey:@"name"];
    user *prUsr = [[user alloc] initWithIdU:idOfUser name:name address:@"" contact:@"" role:@"student"];
    [[dataModel sharedManager] setPresentUser:prUsr];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupViewControllers];
        [self customizeInterface];
        [[ServerManager sharedManager] getNearbySchools:28.5723769 :77.2274863 :[NSString stringWithFormat:@"%d",((user*)[[dataModel sharedManager] presentUser]).idU]];
    });
    
    
}


-(void)loginSuccess:(NSNotification *)loginInfo{
    NSDictionary *dict = [loginInfo userInfo];
    int idOfUser = (int)[[dict objectForKey:@"id"] integerValue];
    NSString *name = [dict objectForKey:@"name"];
    user *prUsr = [[user alloc] initWithIdU:idOfUser name:name address:@"" contact:@"" role:@"student"];
    [[dataModel sharedManager] setPresentUser:prUsr];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupViewControllers];
        [self customizeInterface];
        [[ServerManager sharedManager] getNearbySchools:28.5723769 :77.2274863 :[NSString stringWithFormat:@"%d",((user*)[[dataModel sharedManager] presentUser]).idU]];
    });
    
    
}

-(void)propertiesFetched{
    //[self makeAlert:@"logged in"];
    [self.mySpinner stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showViewController:self.viewController sender:nil];
    });
}

-(void)loginFaliure:(NSNotification *)loginInfo{
    NSDictionary *dict = [loginInfo userInfo];
    [self makeAlert:[dict objectForKey:@"reason"]];
}


-(void)checkCredentials{
    if(!self.visited){
        NSString *username = self.username.text;
        NSString *password = self.password.text;
        [self.mySpinner startAnimating];
        self.visited = YES;
        [[ServerManager sharedManager] isLoggedIn:username :password];
        
    }
}

-(void)makeLoginView{
    self.loginviewcontroller = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth,screenHeight)];
    self.loginviewcontroller.backgroundColor = backcolor;
    [self.view addSubview:self.loginviewcontroller];
    
    
    self.crossButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.crossButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.crossButton addTarget:self action:@selector(removeLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.crossButton setFrame:CGRectMake(5, 20, 30, 30)];
    
    UIColor * color = [UIColor colorWithRed:218/255.0f green:209/255.0f blue:193/255.0f alpha:1.0f];
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*0.1)];
    topBar.backgroundColor = color;
    [self.loginviewcontroller addSubview:topBar];

    UILabel *topBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, screenWidth-200, screenHeight*0.1-10)];
    topBarLabel.text = @"LOGIN";
    topBarLabel.textAlignment = NSTextAlignmentCenter;
    topBarLabel.textColor = [UIColor whiteColor];
    [topBar addSubview:topBarLabel];
    [topBar addSubview:self.crossButton];
    
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(20, screenHeight*0.15, screenWidth-40, screenHeight*0.1-10)];
    self.username.userInteractionEnabled = true;
    [self.username setFont:[UIFont boldSystemFontOfSize:18]];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@" Email or Username" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.username.attributedPlaceholder = str;
    self.username.delegate = self;
    self.username.backgroundColor = color;
    self.username.layer.borderWidth = 0.5f;
    self.username.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, screenHeight*0.25-5, screenWidth-40, screenHeight*0.1-10)];
    self.password.userInteractionEnabled = true;
    [self.password setFont:[UIFont boldSystemFontOfSize:18]];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@" Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.password.attributedPlaceholder = str2;
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    self.password.backgroundColor = color;
    self.password.layer.borderWidth = 0.5f;
    self.password.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIColor * btncolor = [UIColor colorWithRed:93/255.0f green:61/255.0f blue:67/255.0f alpha:1.0f];
    self.loginButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton addTarget:self action:@selector(checkCredentials) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setFrame:CGRectMake(20, screenHeight*0.35+5, screenWidth-40, screenHeight*0.1-10)];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = btncolor;
    
    [self.loginviewcontroller addSubview:self.username];
    [self.loginviewcontroller addSubview:self.password];
    [self.loginviewcontroller addSubview:self.loginButton];
    
}

-(void)addloginToView{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.loginviewcontroller.frame  = CGRectMake(0, 0, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)removeLoginView{
    [self dismissKeyboard];
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.loginviewcontroller.frame  = CGRectMake(0, screenHeight, screenWidth,screenHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}



#pragma mark Application Logo

-(void)makeLogoView{
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, screenWidth-50, screenHeight*0.588)];
    [self.logoView setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:self.logoView];
}



#pragma mark Login Sign up


-(void)loginAction{
//    NSLog(@"login action");
    [self addloginToView];
}

-(void)signupAction{
    NSLog(@"signup action");
}


-(void)makeLoginSignUpButtons{
    self.nLogInButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nLogInButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.nLogInButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nLogInButton setFrame:CGRectMake(20, screenHeight-90, (screenWidth*0.5)-25, 50)];
    self.nLogInButton.layer.cornerRadius = 5.0f;
    self.nLogInButton.backgroundColor = [UIColor whiteColor];
    [self.nLogInButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.nSignUpbutton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nSignUpbutton setTitle:@"Signup" forState:UIControlStateNormal];
    [self.nSignUpbutton addTarget:self action:@selector(signupAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nSignUpbutton setFrame:CGRectMake(screenWidth*0.5+5, screenHeight-90, (screenWidth*0.5)-25, 50)];
    self.nSignUpbutton.layer.cornerRadius = 5.0f;
    self.nSignUpbutton.backgroundColor = [UIColor whiteColor];
    [self.nSignUpbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.nLogInButton];
    [self.view addSubview:self.nSignUpbutton];
    

}

#pragma mark Google Plus delegates

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    
    if (error) {
        NSLog(@"Received error %@",error);
    } else {
        NSLog(@"auth object %@",auth);
        
        [self refreshInterfaceBasedOnSignIn];
    }
}

#pragma mark Google plus additonal methods

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

// for signing out using google +
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}




#pragma mark facebook delegates

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    //self.nameLabel.text = @"You're not logged in!";
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    if (FBSession.activeSession.isOpen)
//    {
//        [FBSession.activeSession closeAndClearTokenInformation];
//    }
   // self.nameLabel.text = user.name;
    NSLog(@"%@",user.objectID);
    NSString *str = user.objectID;
    [[dataModel sharedManager] setProfileIdOfuser:[NSString stringWithFormat:@"%@",str]];
    NSArray *keys = [NSArray arrayWithObjects:@"id",@"name", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",@"1"],[NSString stringWithFormat:@"%@",user.name], nil];
    NSDictionary *loginDesc = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    [self loginSuccessViaSocial:loginDesc];
}


#pragma mark notification handlers and observers

-(void)addObserverForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:@"loginSuccessful"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginFaliure:)
                                                 name:@"loginUnSuccessful"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(propertiesFetched)
                                                 name:@"propertiesFetched"
                                               object:nil];

}

#pragma mark other action handlers

-(void)addLoader{
    self.mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.mySpinner.center = CGPointMake(160, 240);
    self.mySpinner.hidesWhenStopped = YES;
    [self.view addSubview:self.mySpinner];
}


#pragma mark predefined methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backcolor;
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions:
     @[@"public_profile", @"email", @"user_friends"]];
    loginView.delegate = self;
    // Align the button in the center horizontally
    loginView.frame = CGRectMake(20, screenHeight-200, screenWidth-40, 50);
    [self.view addSubview:loginView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight-250, screenWidth-100, 20)];
    
    [self.view addSubview:self.nameLabel];
    
    
    self.signInButton = [[GPPSignInButton alloc] initWithFrame:CGRectMake(20, screenHeight-150, screenWidth-40, 50)];
    
    [self.view addSubview:self.signInButton];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    

    [signIn trySilentAuthentication];
    
    [self makeLogoView];
    [self makeLoginSignUpButtons];
    [self makeLoginView];
    [self addLoader];
    [self addObserverForNotifications];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.loginviewcontroller addGestureRecognizer:tap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tabbed view methods

- (void)setupViewControllers {
    UIViewController *firstViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"nearby"];
    
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[NeabyMapViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[DistrictSchoolsViewController alloc] init];
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
    NSArray *tabBarItenTitle = @[@"Nearby",@"Maps",@"District"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[NSString stringWithFormat:@"%@",[tabBarItenTitle objectAtIndex:index]]];
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
