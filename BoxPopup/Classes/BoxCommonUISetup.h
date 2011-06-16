//
//  CommonUISetup.h
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 8/7/09.
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

#import <Foundation/Foundation.h>
#import "BoxPopupConstants.h"

@interface BoxCommonUISetup : NSObject {

}
/*
 * Formats look of the Box UINavigation bar
 */
+(void) formatNavigationBarWithBoxIconAndColorScheme:(UINavigationController*)navController andNavItem:(UINavigationItem*)navItem;

/*
 * Convenience method for popping up an alert for a title, some text and a delegate
 */
+(UIAlertView*) popupAlertWithTitle:(NSString*)title andText:(NSString*)text andDelegate:(id <UIAlertViewDelegate>)delegate;

/*
 * This is useful for automatically moving a view above the keyboard.
 */
+ (void)moveView:(int)offset andController:(UIViewController*)controller;

@end
