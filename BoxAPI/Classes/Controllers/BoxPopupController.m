
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

#import "BoxPopupController.h"
#import "BoxPopupMainViewController.h"

@implementation BoxPopupController

@synthesize popupDelegate = _popupDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	BoxPopupMainViewController * popupController = [[BoxPopupMainViewController alloc] initWithNibName:@"BoxPopupMainView" bundle:nil];
	//popupController.popupDelegate = _popupDelegate;
	_popupNavigationController = [[UINavigationController alloc] initWithRootViewController:popupController];
	[popupController release];
	
	_popupNavigationController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	[self.view addSubview:_popupNavigationController.view];
	NSLog(@"created login table view controller %@", popupController.loginTableViewController);
	
	NSLog(@"********Getting info");
	// build the needed info and send it to the main view
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[_popupDelegate suggestedFileName], @"filename",
						  [NSNumber numberWithInt:[_popupDelegate shouldAppendTimeAndDate]], @"appendDateTime",
						  [_popupDelegate data], @"data", [_popupDelegate fileExtension], @"fileExtension", nil];
	[popupController selectedAction:BoxActionTypeUpload withInfo:info];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"View Will appear BoxPopupController");
	[_popupNavigationController viewWillAppear:animated];
}

- (void)dealloc {
    [super dealloc];
	[_popupNavigationController release];
}


@end
