
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

#import "BoxFolderChooserTableViewController.h"


@implementation BoxFolderChooserTableViewController

@synthesize filePathSelectorDelegate = _filePathSelectorDelegate;



#pragma mark Folder Methods

-(void)folderRetrievalCallback:(BoxFolder*)folderModel {
	if(!folderModel) {
		[BoxCommonUISetup popupAlertWithTitle:@"Error" andText:@"Could not access your box account at this time. Please check your internet connection and try again" andDelegate:nil];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	_folderModel = [folderModel retain];
	[self.tableView reloadData];
	[_activityIndicator stopAnimating];
}

-(void)getFoldersAsync:(id)object {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	BoxUser * userModel = [BoxUser savedUser];
	
	NSString * ticket = userModel.authToken;
	// Step 2a
	NSNumber * folderIdToDownload = [NSNumber numberWithInt:0];
	// Step 2b
	BoxFolderDownloadResponseType responseType = 0;
	BoxFolder * folderModel = [BoxFolderXMLBuilder folderForId:folderIdToDownload token:ticket responsePointer:&responseType basePathOrNil:nil];

	
	// Step 2c
	if(responseType == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
		//Step 2d
		NSLog(@"%@", [folderModel objectToString]);
	}
	
	[self performSelectorOnMainThread:@selector(folderRetrievalCallback:) withObject:folderModel waitUntilDone:YES];
	
	[pool release];
}

#pragma mark Table Methods

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_activityIndicator.hidesWhenStopped = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:self.navigationController andNavItem:self.navigationItem];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_activityIndicator] autorelease];
	[_activityIndicator startAnimating];
	
	[NSThread detachNewThreadSelector:@selector(getFoldersAsync:) toTarget:self withObject:nil];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // We're hard-coding two sections - all files, and the contents of all-files
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20; // Section headers have a height of 20
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView * headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
	UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)] autorelease];
	headerLabel.textAlignment = UITextAlignmentLeft;
	headerLabel.font = [UIFont boldSystemFontOfSize:14];
	[headerView addSubview:headerLabel];
	headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BoxSectionBarBackground.png"]];
	headerLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
	if(section == 0) { // all files
		headerLabel.text = @"/";
	}
	if(section == 1) { 
		headerLabel.text = @"/All Files/";
	}
	return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 1)
		return [_folderModel getFolderCount];
	else
		return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
	if(indexPath.section == 1) { // standard
		BoxFolder * curModel = (BoxFolder*)[_folderModel.objectsInFolder objectAtIndex:[indexPath row]];
		cell.textLabel.text = curModel.objectName;
		if(curModel.isCollaborated) {
			cell.imageView.image = [UIImage imageNamed:@"BoxCollabFolder.png"];
			NSLog(@"is collaborated image");
		}
		else
			cell.imageView.image = [UIImage imageNamed:@"BoxFolderIcon-old.png"];
		
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ files. %@", curModel.fileCount, curModel.objectDescription];
	}
	else {
		cell.textLabel.text = @"All Files";
		cell.imageView.image = [UIImage imageNamed:@"BoxFolderIcon-old.png"];
		cell.detailTextLabel.text = @"All Files is the top level of your box account";
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 1) {
		BoxFolder * folderModel = [_folderModel.objectsInFolder objectAtIndex:[indexPath row]];
		BOOL folderSaveSuccess = [folderModel saveAsCurrentFolder];
		NSLog(@"Folder Save Success: %d", folderSaveSuccess);
		[_filePathSelectorDelegate setUploadFolderModel:folderModel];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		[BoxFolder clearSavedFolder];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

