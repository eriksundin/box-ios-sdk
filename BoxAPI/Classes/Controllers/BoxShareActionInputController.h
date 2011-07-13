
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

#import <UIKit/UIKit.h>
#import "BoxActionTextInputController.h"

@interface BoxShareActionInputController : UIViewController<UITextViewDelegate> {
	IBOutlet UILabel *_headerLabel;
    IBOutlet UILabel *_messageLabel;
	IBOutlet UILabel *_emailLabel;
	IBOutlet UILabel *_notifyLabel;
	IBOutlet UILabel *_passwordLabel;

	IBOutlet UITextField *_emailTextField;
	IBOutlet UITextField *_passwordTextField;
	IBOutlet UISwitch    *_notifySwitch;
	IBOutlet UITextView  *_messageTextView;
	
	IBOutlet UIScrollView *_scrollView;
	
	id <BoxActionInputDelegate> _delegate;
}

@property (assign) id<BoxActionInputDelegate> delegate;

- (IBAction)ok;

- (void)setHeaderText:(NSString *)headerText;
- (void)setMessageHidden:(BOOL)yn;
- (void)setEmailHidden:(BOOL)yn;
- (void)setNotifyHidden:(BOOL)yn;
- (void)setPasswordHidden:(BOOL)yn;

@end
