
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


#import "BoxPopupAppDelegate.h"
#import "MainViewController.h"
#import "BoxCommonUISetup.h"


@interface BoxPopupAppDelegate() {
    UIViewController *__rootViewController;
}

@property (nonatomic, retain) UIViewController *rootViewController;

@end

@implementation BoxPopupAppDelegate

@synthesize window, rootViewController = __rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    MainViewController * exampleController = [[MainViewController alloc] init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:exampleController];
    [BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:navigationController andNavItem:exampleController.navigationItem];
    [exampleController release];
    self.rootViewController = navigationController;
    [navigationController release];
    self.rootViewController.view.frame = [[UIScreen mainScreen] applicationFrame];
	[window addSubview:self.rootViewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    window = nil;
    [__rootViewController release];
    __rootViewController = nil;
    [super dealloc];
}


@end
