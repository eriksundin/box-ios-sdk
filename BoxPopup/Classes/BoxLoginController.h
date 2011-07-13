
//   Copyright 2011 Box.net, Inc.
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

/*
 * The BoxLoginController handles the content section of the login page. 
 */

#import <UIKit/UIKit.h>
#import "BoxCommonUISetup.h"
#import "BoxFlipViewController.h"

#import "BoxLoginBuilder.h"

@interface BoxLoginController : UIViewController <UITextFieldDelegate,BoxFlipViewCompatible,UIAlertViewDelegate,BoxLoginBuilderDelegate>{
	
	IBOutlet UIWebView *_webView;
	IBOutlet UIView *_loginView;
	
	BoxFlipViewController * _flipViewController;
	
	BoxLoginBuilder *_loginBuilder;
}

@property (assign) BoxFlipViewController *boxFlipViewController;

-(IBAction) didPressLoginButton:(id)sender;
-(IBAction) didPressRegisterButton:(id)sender;

@end
