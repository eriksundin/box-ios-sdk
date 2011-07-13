
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

#import "BoxPopupExampleController.h"


@implementation BoxPopupExampleController

static BoxPopupControllerTestButtonSelected selection = 0;

#pragma mark BoxPopupDelegate

-(NSData*)data {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BoxBoxLogo" ofType:@"gif"]];
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Simple Text Format" ofType:@"rtf"]];
			break;			
		case BoxPopupControllerTestButtonWordDocWithNoBaseFile:
			return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Simple Word Doc" ofType:@"docx"]];
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Simple Word Doc" ofType:@"docx"]];
			break;
		case BoxPopupControllerTestButtonImageWithNoBaseFile:
			return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BoxBoxLogo" ofType:@"gif"]];
			break;
		default:
			return nil;
			break;
	}


}
-(NSString*)fileExtension {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return @"gif";
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return @"rtf";
			break;			
		case BoxPopupControllerTestButtonWordDocWithNoBaseFile:
			return @"docx";
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return @"docx";
			break;
		case BoxPopupControllerTestButtonImageWithNoBaseFile:
			return @"gif";
			break;
		default:
			return nil;
			break;
	}
}
-(void)popupShouldExit {
	[self dismissModalViewControllerAnimated:YES];
}

-(NSString*)suggestedFileName {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return @"BoxPopupControllerTestButtonImageWithBaseFileAndDate";
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return @"BoxPopupControllerTestButtonTextFileWithBaseFile";
			break;			
		case BoxPopupControllerTestButtonWordDocWithNoBaseFile:
			return @"";
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return @"BoxPopupControllerTestButtonWordDocWithBaseFile";
			break;
		case BoxPopupControllerTestButtonImageWithNoBaseFile:
			return @"";
			break;
		default:
			return nil;
			break;
	}
	
}

-(BOOL)shouldAppendTimeAndDate {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return YES;
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return NO;
			break;			
		case BoxPopupControllerTestButtonWordDocWithNoBaseFile:
			return NO;
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return NO;
			break;
		case BoxPopupControllerTestButtonImageWithNoBaseFile:
			return NO;
			break;
		default:
			return NO;
			break;
	}
}

#pragma mark Controller Functions
-(IBAction) popupBoxAction:(id)sender
{
	// Initialize the Popup controller, set the delegate and present it as a modal view controller, then release.
	_boxPopupController = [[BoxPopupController alloc] initWithNibName:@"BoxPopupController" bundle:nil];
	_boxPopupController.popupDelegate = self;
	[self presentModalViewController:_boxPopupController animated:YES];
	[_boxPopupController release];
	
	
	////////////////////
	// This code defines the scenario for which the delegate methods return values
	if(sender == _popupBoxImageWithBaseFileAndDate)
		selection = BoxPopupControllerTestButtonImageWithBaseFileAndDate;
	else if(sender == _popupBoxTextFileWithBaseFile)
		selection = BoxPopupControllerTestButtonTextFileWithBaseFile;
	else if(sender == _popupBoxWordDocWithNoBaseFile)
		selection = BoxPopupControllerTestButtonWordDocWithNoBaseFile;
	else if(sender == _popupBoxWordDocWithBaseFile)
		selection = BoxPopupControllerTestButtonWordDocWithBaseFile;
	else if(sender == _popupBoxImageWithNoBaseFile)
		selection = BoxPopupControllerTestButtonImageWithNoBaseFile;
	

}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _boxPopupController = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	if(_boxPopupController)
		[_boxPopupController release];
    [super dealloc];
}


@end
