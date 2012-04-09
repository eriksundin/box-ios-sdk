
//
// Copyright 2011 Box, Inc.
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

#import "BoxUploadActionViewController.h"
#import "BoxNetworkOperationManager.h"
#import "BoxUploadOperation.h"
#import "BoxLoginViewController.h"


typedef enum {
BoxPopupControllerTestButtonImageWithBaseFileAndDate, // Upload an image with a base file name defined and attach a date to the file name
BoxPopupControllerTestButtonTextFileWithBaseFile,	  // Upload a text file with a base file name defined
BoxPopupControllerTestButtonWordDocWithBaseFile,      // Upload a word document with a base file defined 
} FileType;

@interface BoxUploadActionViewController() {
    UIButton * __imageButton;
    UIButton * __rtfButton;
    UIButton * __docButton;
}

@property (nonatomic, retain) IBOutlet UIButton * imageButton;
@property (nonatomic, retain) IBOutlet UIButton * rtfButton;
@property (nonatomic, retain) IBOutlet UIButton * docButton;

-(NSData*)data:(FileType)selection;
-(NSString*)fileExtension:(FileType)selection;
-(NSString*)suggestedFileName:(FileType)selection;

@end

@implementation BoxUploadActionViewController

@synthesize imageButton = __imageButton, rtfButton = __rtfButton, docButton = __docButton;

#pragma mark - Button Methods

-(IBAction)buttonPressed:(id)sender
{
    FileType selection = -1;
	if(sender == self.imageButton) {
		selection = BoxPopupControllerTestButtonImageWithBaseFileAndDate;
	} else if(sender == self.rtfButton) {
		selection = BoxPopupControllerTestButtonTextFileWithBaseFile;
	} else if(sender == self.docButton) {
		selection = BoxPopupControllerTestButtonWordDocWithBaseFile;
    }
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run an upload operation. Any other code \\
    // in this class is for handling the buttons/default values so it can be ignored.  \\
    
    BoxUploadOperation * uploadOperation = [BoxUploadOperation operationForUser:[BoxLoginViewController currentUser] targetFolderId:@"0" data:[self data:selection] fileName:[self suggestedFileName:selection] contentType:[self fileExtension:selection] shouldShare:NO message:nil emails:nil]; //0 refers to the root folder and is used here as a default value. You can designate a different folder using the BoxFolder objectID property.
	BoxOperationCompletionHandler onCompletetionBlock = ^(BoxOperation * op, BoxOperationResponse response) { //This is an example completion block. Your implementation is likely to be different.
        NSString * message = [BoxNetworkOperationManager humanReadableErrorFromResponse:response];
        NSString * title = @"";
        if (response == BoxOperationResponseSuccessful) {
            title = @"Success!";
        } else {
            title = @"Error";
        }
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    };
    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:uploadOperation onCompletetion:onCompletetionBlock]; //sends the request
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Upload";
}

#pragma mark - GetFileInfo Methods

- (NSData*)data:(FileType)selection {
switch (selection) {
    case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
        return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BoxBoxLogo" ofType:@"gif"]];
        break;
    case BoxPopupControllerTestButtonTextFileWithBaseFile:
        return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Simple Text Format" ofType:@"rtf"]];
        break;			
    case BoxPopupControllerTestButtonWordDocWithBaseFile:
        return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Simple Word Doc" ofType:@"docx"]];
        break;
    default:
        return nil;
        break;
    }
}

-(NSString*)fileExtension:(FileType)selection {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return @"gif";
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return @"rtf";
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return @"docx";
			break;
		default:
			return nil;
			break;
	}
}

-(NSString*)suggestedFileName:(FileType)selection {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return @"BoxPopupControllerTestButtonImageWithBaseFileAndDate.gif";
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return @"BoxPopupControllerTestButtonTextFileWithBaseFile.rtf";
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return @"BoxPopupControllerTestButtonWordDocWithBaseFile.docx";
			break;
		default:
			return nil;
			break;
	}
	
}

#pragma mark - View Life Cycle

- (void)dealloc {
    [__imageButton release];
    __imageButton = nil;
    [__rtfButton release];
    __rtfButton = nil;
    [__docButton release];
    __docButton = nil;
    
    [super dealloc];
}

@end
