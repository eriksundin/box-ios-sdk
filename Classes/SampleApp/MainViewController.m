
//
// Copyright 2011 Box, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "MainViewController.h"
#import "BoxLoginViewController.h"
#import "BoxNetworkOperationManager.h"
#import "BoxActionTableViewController.h"
#import "BoxCommonUISetup.h"


@interface MainViewController () <BoxLoginViewControllerDelegate> {
    UILabel * __loginLabel;
}

@property (nonatomic, retain) IBOutlet UILabel * loginLabel;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)loginNotModalPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (void)logoutPressed:(id)sender;

@end

@implementation MainViewController

@synthesize loginLabel = __loginLabel;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * logoutButton = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutPressed:)] autorelease];
    self.navigationItem.leftBarButtonItem = logoutButton;
  
#warning You need to set the API key in order for the demo to work.
    [BoxRESTApiFactory setAPIKey:@""];
  
    if ([BoxRESTApiFactory APIKey] == 0) {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Currently the API key is not set so the SDK will not work. Set the API key on the BoxRESTApiFactory." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BoxLoginViewController userSignedIn]) {
        NSString * labelText = [NSString stringWithFormat:@"%@ is currently logged in.\nEmail: %@", [BoxLoginViewController currentUser].userName, [BoxLoginViewController currentUser].email];
        self.loginLabel.text = labelText;
    } else {
        self.loginLabel.text = @"User not logged in.";
    }
}

- (void)dealloc {
    [__loginLabel release];
    __loginLabel = nil;
    [super dealloc];
}

#pragma mark - Buttons

/////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
// Below is the code which you need to login a user. There are two ways to         \\
// get the view controller for login. You can present the view modally and use     \\
// initWithNavBar:YES which includes the nav bar (and should only be used modally  \\
// or use initWithNavBar:NO which only returns the view controller with the login  \\
// view (and no nav bar).                                                          \\

- (IBAction)loginButtonPressed:(id)sender {
    BoxLoginViewController * vc = [BoxLoginViewController loginViewControllerWithNavBar:YES]; //Since YES was passed in here, the view controller MUST be presented modally.
    vc.boxLoginDelegate = self;
    [self presentModalViewController:vc animated:YES];
}

- (IBAction)loginNotModalPressed:(id)sender {
    BoxLoginViewController * vc = [BoxLoginViewController loginViewControllerWithNavBar:NO]; //Since NO was passed in here, the view controller can be presented however you want. However, no navigation bar will be included.
    [BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:vc.navigationController andNavItem:vc.navigationItem]; //Adds the box styling to the navigation item of the view. This is optional.
    vc.boxLoginDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

/////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\


- (IBAction)actionButtonPressed:(id)sender {
    BoxActionTableViewController * vc = [[BoxActionTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)logoutPressed:(id)sender {
    [BoxLoginViewController logoutCurrentUser];
    [self viewWillAppear:NO];
}

#pragma mark - BoxLoginDelegate Methods

/////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
// Since you presented the view controller onto the screen, you are also           \\
// responsible for taking it off. Use this delegate method for that.               \\

- (void)boxLoginViewController:(BoxLoginViewController *)boxLoginViewController didFinishWithResult:(LoginResult)result {
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES]; //Only one of these lines should actually be used depending on how you choose to present it.
}

/////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\å

@end
