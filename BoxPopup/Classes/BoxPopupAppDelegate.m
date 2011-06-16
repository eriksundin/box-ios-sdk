//
//  BoxPopupAppDelegate.m
//  BoxPopup
//
//  Created by Michael Smith on 9/7/09.
//  Copyright 2009 Box.net.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
//  See the License for the specific language governing permissions and 
//  limitations under the License. 
//

#import "BoxPopupAppDelegate.h"

@implementation BoxPopupAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	BoxPopupExampleController * exampleController = [[BoxPopupExampleController alloc] initWithNibName:@"BoxPopupExampleView" bundle:nil];
	[window addSubview:exampleController.view];
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
