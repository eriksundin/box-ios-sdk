
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

/*
 * The RegisterViewController handles display of the register content view
 */

#import <UIKit/UIKit.h>

#import "BoxFlipViewController.h"
#import "BoxRegisterOperation.h"

@interface BoxRegisterViewController : UIViewController <BoxFlipViewCompatible,UITextFieldDelegate,UIAlertViewDelegate, BoxOperationDelegate>{

	IBOutlet UITextField * _emailAddressField;
	IBOutlet UITextField * _createPasswordField;
	IBOutlet UITextField * _confirmPasswordField;
	
	IBOutlet UIScrollView * _scrollView;
	
	BoxFlipViewController * _flipViewController;
	
	BoxRegisterOperation *_registerOperation;
}

-(IBAction) registerAction:(id)sender;
-(IBAction) loginAction:(id)sender;

@end
