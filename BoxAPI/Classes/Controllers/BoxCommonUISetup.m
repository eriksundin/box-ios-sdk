
//
// Copyright 2011 Box.net, Inc.
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

#import "BoxCommonUISetup.h"


@implementation BoxCommonUISetup

+(void) formatNavigationBarWithBoxIconAndColorScheme:(UINavigationController*)navController andNavItem:(UINavigationItem*)navItem
{
	UIImageView * logo = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 54.0f, 32.0f)];
    logo.image = BOXPOPUP_TOP_BAR_LOGO_IMAGE;
    logo.center = [navController.navigationBar center];
    navItem.titleView = logo;
	navController.navigationBar.tintColor = BOX_NAVIGATION_BAR_COLOR;	
}

+(UIAlertView*) popupAlertWithTitle:(NSString*)title andText:(NSString*)text andDelegate:(id <UIAlertViewDelegate>)delegate
{
	UIAlertView *alert;
	alert = [[UIAlertView alloc] initWithTitle:title message:text
									  delegate:/*self*/delegate cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
	return alert;
}

/*
 * Example code for moveView 
 * taken from post: http://de-co-de.blogspot.com/2009/03/moving-uitextfield-above-keyboard.html
 */
+ (void)moveView:(int)offset andController:(UIViewController*)controller
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	// Make changes to the view's frame inside the animation block. They will be animated instead
	// of taking place immediately.
	CGRect rect = controller.view.frame;
	rect.origin.y -= offset;
	rect.size.height += offset;
	controller.view.frame = rect;
	
	[UIView commitAnimations];
}


@end
