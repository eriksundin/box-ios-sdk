
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

#import "BoxFlipViewController.h"


@implementation BoxFlipViewController

@synthesize sectionTitleView = _sectionTitleView;
@synthesize sectionTitleLabel = _sectionTitleLabel;

- (void)doLogoutAction {
	[BoxUser clearSavedUser];
	[BoxFolder clearSavedFolder];
	NSLog(@"Cleared saved folder");
	self.navigationItem.rightBarButtonItem = nil;
	
	_sectionTitleLabel.text = @"Please login/register to upload your file";
}

- (id) initWithNibName:(NSString*)nibNameOrNil andBundle:(NSBundle*)nibBundleOrNil andInitialController:(UIViewController <BoxFlipViewCompatible> *)controller1 andSecondaryController:(UIViewController <BoxFlipViewCompatible> *)controller2 andPrimaryControllerFirst:(BOOL)first {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		_controller1 = [controller1 retain];
		_controller2 = [controller2 retain];
		
		if(first)
			_currentController = _controller1;
		else
			_currentController = _controller2;
		
		[_controller1 setBoxFlipViewController:self];
		[_controller2 setBoxFlipViewController:self];
		
		_spinnerOverlay = [[BoxSpinnerOverlayViewController alloc] initWithNibName:@"BoxSpinnerOverlayView" bundle:nil]; // in case we need to do a load action
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[_contentView addSubview:_currentController.view];
	self.parentViewController.view.backgroundColor = [UIColor blackColor];
	[BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:self.navigationController andNavItem:self.navigationItem];
	BoxUser * userModel = [BoxUser savedUser];
	if (![userModel loggedIn]) {
		_sectionTitleLabel.text = @"Please login or register to upload your file";
	}
	else {
		_sectionTitleLabel.text = [NSString stringWithFormat:@"Currently logged in as %@", userModel.userName];
		UIBarButtonItem * logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(doLogoutAction)];
		self.navigationItem.rightBarButtonItem = logoutItem;
		[logoutItem release];		
	}
}

-(void)doFlipAction {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	UIViewController * prevCntlr;
		
	NSLog(@"Flip");
	if(_currentController == _controller1) {
		_currentController = _controller2;
		prevCntlr = _controller1;
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:_contentView cache:YES];
	}
	else { // these means _currentController == _controller2
		_currentController = _controller1;
		prevCntlr = _controller2;
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:_contentView cache:YES];
	}
	
	[prevCntlr.view removeFromSuperview];
	[_contentView addSubview:_currentController.view];
	
	[UIView commitAnimations];
}
-(void)startSpinnerOverlay {
	[self.navigationController.view addSubview:_spinnerOverlay.view];
	[_spinnerOverlay startSpinner];

}
-(void)endSpinnerOverlay{
	[_spinnerOverlay stopSpinner];
	[_spinnerOverlay.view removeFromSuperview];

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[_spinnerOverlay release];
}


@end
