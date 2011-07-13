
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

#import "BoxPopupMainViewController.h"


@implementation BoxPopupMainViewController

@synthesize popupDelegate = _popupDelegate;


-(NSString*)getCurrentFolderPath {
	BoxFolder * folderModel = [BoxFolder savedFolder];
	if(folderModel == nil) 
		return @"/All Files";
	else
		return [NSString stringWithFormat:@"/All Files/%@", folderModel.objectName];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:self.navigationController andNavItem:self.navigationItem];
	_fileNameField.delegate = self;
	_loginTableViewController.navigationController = self.navigationController;
	
	[_loginTableViewController.tableView reloadData];
	
	NSString * suggestedFileName = [_popupDelegate suggestedFileName];
	BOOL shouldAppendTimeStamp = [_popupDelegate shouldAppendTimeAndDate];
	
	NSString * timeAndDate = @"";
	
	if(shouldAppendTimeStamp) {
		NSDate * curDate = [NSDate dateWithTimeIntervalSinceNow:0];
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MMM-dd-yyyy HH:mm:ss"];
		
		timeAndDate = [formatter stringFromDate:curDate];
		[formatter release];
		timeAndDate = [@" " stringByAppendingString:timeAndDate];
	}
	
	NSString * fileExtension = [_popupDelegate fileExtension];
	if(fileExtension == nil)
		fileExtension = @"";

	if(suggestedFileName == nil || [suggestedFileName compare:@""] != NSOrderedSame) 
		_fileNameField.text = [NSString stringWithFormat:@"%@%@.%@", suggestedFileName, timeAndDate, fileExtension];
	
	NSLog(@"View Loaded");
	
	UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(doCancelAction)];
	self.navigationItem.leftBarButtonItem = cancelItem;
	[cancelItem release];
	
	_spinnerOverlay = [[BoxSpinnerOverlayViewController alloc] initWithNibName:@"BoxSpinnerOverlayView" bundle:nil]; // in case we need to do a load action

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[_spinnerOverlay release];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"View Will Appear: BoxPopupMainViewController");
	[super viewWillAppear:animated];
	[_loginTableViewController viewWillAppear:animated];
	BoxUser * userModel = [BoxUser savedUser];
	if(![userModel loggedIn]) {
		_navInfoLabel.text = @"Please login to Box.net to upload your file";
	}
	else {
		_navInfoLabel.text = [NSString stringWithFormat:@"Upload a file to Box.net"];
	}
	
}

#pragma mark Text Help code

/*
 * Example code for moveView 
 * taken from post: http://de-co-de.blogspot.com/2009/03/moving-uitextfield-above-keyboard.html
 */
- (void)moveView:(int)offset
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	// Make changes to the view's frame inside the animation block. They will be animated instead
	// of taking place immediately.
	CGRect rect = self.view.frame;
	rect.origin.y -= offset;
	rect.size.height += offset;
	self.view.frame = rect;
	
	[UIView commitAnimations];
}

#pragma mark UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	NSLog(@"Did Begin Editing");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	_scrollView.frame = CGRectMake(0, 0, 320, 416-216);
	_scrollView.contentSize = CGSizeMake(320,416); 
	[UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"Text Field Should Return");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[textField resignFirstResponder];
	_scrollView.frame = CGRectMake(0, 0, 320, 416);
	_scrollView.contentSize = CGSizeMake(320,416); 
	[UIView commitAnimations];
	return NO;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	NSLog(@"in shouldbeginediting: %@", textField);
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if(textField == _shareEmailsField) {
		if([textField.text length] + [string length] - range.length > 0) {
			[_uploadButton setTitle:@"Upload to Box.net and Share" forState:UIControlStateNormal];
			_uploadButton.titleLabel.textAlignment = UITextAlignmentCenter;

			NSLog(@"text greater than 0");
		}
		else {
			[_uploadButton setTitle:@"Upload to Box.net" forState:UIControlStateNormal];
			_uploadButton.titleLabel.textAlignment = UITextAlignmentCenter;

			NSLog(@"text less than 0");
		}
	}
	return YES;
}


#pragma mark Share Action Methods
-(void) appendEmailAddress:(NSString*)email {
	//NSLog(@"%@ email selected", email);
	NSString * curEmailString = [_shareEmailsField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	int emailStringLength = [curEmailString length];
	if(emailStringLength == 0 || [curEmailString characterAtIndex:emailStringLength - 1] == ',')
		_shareEmailsField.text = [NSString stringWithFormat:@"%@%@", _shareEmailsField.text, email];
	else
		_shareEmailsField.text = [NSString stringWithFormat:@"%@, %@", _shareEmailsField.text, email];

	[_uploadButton setTitle:@"Upload to Box.net and Share" forState:UIControlStateNormal];
	_uploadButton.titleLabel.textAlignment = UITextAlignmentCenter;

}

-(NSArray*) getEmailAddresses:(NSString*)emailsSeparatedByCommas {
	// verify each of the email addresses
	NSString * addresses = emailsSeparatedByCommas;
	NSArray * list = [addresses componentsSeparatedByString:@","];
	NSMutableArray * finalList = [[[NSMutableArray alloc] initWithCapacity:[list count]] autorelease];
	
	if([_shareEmailsField.text length] == 0) {
		// We're not sharing
		return nil;
	}
	
	for(NSString * email in list) {
		NSString * trimmedEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		BOOL isValidEmail = [BoxModelUtilityFunctions isValidEmail:trimmedEmail];
		if(isValidEmail) {
			[finalList addObject:trimmedEmail];
		}
		else {
			[BoxCommonUISetup popupAlertWithTitle:nil andText:[NSString stringWithFormat:@"Please check that the email \"%@\" is valid", trimmedEmail] andDelegate:nil];
			return nil;
		}
	}
	
	return finalList;
}



-(IBAction) addContactAction:(id)sender
{
	ABPeoplePickerNavigationController * peoplePickerController = [[ABPeoplePickerNavigationController alloc] init];
	peoplePickerController.peoplePickerDelegate = self; // setPeoplePickerDelegate:self];
	ABAddressBookRef addressBook = ABAddressBookCreate();
	peoplePickerController.addressBook = addressBook;
	peoplePickerController.displayedProperties = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonEmailProperty], nil];
	//	[self.navigationController pushViewController:peoplePickerController animated:YES];
	[self presentModalViewController:peoplePickerController animated:YES];
	[peoplePickerController release];
}

#pragma mark ABPeoplePicker delegate methods

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
	//	ABPersonViewController * personController = [[ABPersonViewController alloc] init];
	//	personController.displayedPerson = person;
	//	personController.personViewDelegate = self;
	//	personController.displayedProperties = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonEmailProperty], nil];
	//	
	//	[peoplePicker.navigationController pushViewController:personController animated:YES];
	//	
	//	[personController release];
	//	return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	ABMultiValueRef multi = ABRecordCopyValue(person, property);	
	int index = ABMultiValueGetIndexForIdentifier(multi, identifier);
	NSString * selectedEmail = (NSString*)ABMultiValueCopyValueAtIndex(multi, index);
	[self appendEmailAddress:selectedEmail];
	
	[self dismissModalViewControllerAnimated:YES];
	
	return NO;
	//	return NO;
	//	if(property == kABPersonEmailProperty)
	//		return YES;
	//	else
	//		return NO;
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark UI Actions

-(void)doCancelAction {
	[_popupDelegate popupShouldExit];
}

-(void) returnFromUpload:(NSNumber*)response {
	BoxUploadResponseType uploadResponse = [response intValue];
	
	[_spinnerOverlay stopSpinner];
	[_spinnerOverlay.view removeFromSuperview];
	
	if(uploadResponse == boxUploadResponseTypeUploadSuccessful) {
		NSString * fileName = _fileNameField.text;
		if([fileName compare:@""] == NSOrderedSame) {
			fileName = @"Mobile Upload";
		}
		NSString * folderPath = [self getCurrentFolderPath];
		
		UIAlertView *alert;
		if([_shareEmailsField.text length] > 0) {
			alert = [[UIAlertView alloc] initWithTitle:@"Upload Success!" message:[NSString stringWithFormat:@"Your file named \"%@\" has been uploaded successfully to \"%@\" on Box.net and shared with the emails you provided", fileName, folderPath]
											  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", @"Go to Box.net", nil];
		}
		else {
			alert = [[UIAlertView alloc] initWithTitle:@"Upload Success!" message:[NSString stringWithFormat:@"Your file named \"%@\" has been uploaded successfully to \"%@\" on Box.net", fileName, folderPath]
										  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", @"Go to Box.net", nil];
		}
		[alert show];	
		[alert release];
		
		
		
	}
	else {
		[BoxCommonUISetup popupAlertWithTitle:@"Error" andText:@"There was a problem uploading your file. Check your internet connection and login" andDelegate:nil];
	}
	
}

-(void) doUploadAsync:(NSDictionary*)dict {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * folderId = [dict objectForKey:@"folderId"];
	NSData	 * data = [dict objectForKey:@"data"];
	NSString * fileName = [dict objectForKey:@"fileName"];
	NSString * dataContentType = [dict objectForKey:@"dataContentType"];
	BOOL       shouldShare = [((NSNumber*)[dict objectForKey:@"shouldShare"]) boolValue];
	NSString * message = [dict objectForKey:@"message"];
	NSArray  * emails = [dict objectForKey:@"emails"];
	
	BoxUser * userModel = [BoxUser savedUser];
	
	BoxUploadResponseType uploadResponse = [BoxHTTPRequestBuilders advancedUploadForUser:userModel targetFolderId:folderId data:data filename:fileName contentType:dataContentType shouldshare:shouldShare message:message emails:emails];
	
	[self performSelectorOnMainThread:@selector(returnFromUpload:) withObject:[NSNumber numberWithInt:uploadResponse] waitUntilDone:NO];
	
	[pool release];
	
}

-(IBAction) uploadAction:(id)sender {
	NSLog(@"Upload Action");
	
	BoxUser * userModel = [BoxUser savedUser];
	if(![userModel loggedIn]) {
		UIAlertView *alert;
		alert = [[UIAlertView alloc] initWithTitle:@"Please Login or Register" message:@"Login to your Box.net account or register to upload your files"
										  delegate:_loginTableViewController cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", @"Register", nil];
		[alert show];	
		[alert release];
		return;
	}
	
	if([_fileNameField.text length] == 0) {
		_fileNameAlert = [[UIAlertView alloc] initWithTitle:@"Please Enter a Filename" message:@"Enter a filename in the 'Filename' field"
										  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[_fileNameAlert show];	
		[_fileNameAlert release];
		return;
		
	}
	
	NSString * folderId;
	if(_loginTableViewController.folderModel == nil)
		folderId = @"0";
	else
		folderId = [NSString stringWithFormat:@"%@", _loginTableViewController.folderModel.objectId];
	
	if(folderId == nil) {
		NSLog(@"Folder ID should not be nil!!");
		return;
	}
	NSString * dataContentType = @""; // For now, content type is unnecessary on uploads
	
	// Get the data
	NSData * data = [_popupDelegate data]; 
	// Get or generate the filename
	NSString * fileName = _fileNameField.text;
	if([fileName compare:@""] == NSOrderedSame)
		fileName = @"Mobile Upload";
	
	// Make sure the suffix is in the right place
	if(![fileName hasSuffix:[_popupDelegate fileExtension]]) {
		fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@".%@", [_popupDelegate fileExtension]]];
	}
	
	BOOL shouldShare = NO;
	NSString * message = nil;
	NSArray * emails = nil;
	
	if([[_shareEmailsField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] compare:@""] != NSOrderedSame) {
		emails = [self getEmailAddresses:_shareEmailsField.text];
		if(emails == nil) {
			return; // they typed something and it's not a valid email address. The error message is handled by 'getEmailAddresses'
		}
		message = _shareMessageField.text;
		shouldShare = YES;
	}
	
	
	[self.view addSubview:_spinnerOverlay.view];
	[_spinnerOverlay startSpinner];
	[NSThread detachNewThreadSelector:@selector(doUploadAsync:) toTarget:self withObject:[NSDictionary 
																						  dictionaryWithObjectsAndKeys:
																						  folderId, @"folderId",
																						  data, @"data",
																						  fileName, @"fileName",
																						  dataContentType, @"dataContentType",
																						  [NSNumber numberWithBool:shouldShare], @"shouldShare",
																						  message, @"message",
																						  emails, @"emails", 
																						  nil] ];
	
}

#pragma mark UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView == _fileNameAlert) {
		[_fileNameField becomeFirstResponder];
	}
	else {
		// Right now the only alert view with BoxPopupMainViewController as delegate is the successful upload alert
		// 0 represents an "Okay" selection
		// 1 represents a "View File" selection
		NSLog(@"buttonIndex: %d",buttonIndex);
		
		if(buttonIndex == 0)
			[_popupDelegate popupShouldExit];
		if(buttonIndex == 1) {
			UIWebView * webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
			[self.view addSubview:webView];
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.box.net"]]];
			
			self.navigationItem.leftBarButtonItem = nil;
			UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doCancelAction)];
			self.navigationItem.leftBarButtonItem = cancelItem;
			[cancelItem release];
		}
	}
	
}

@end
