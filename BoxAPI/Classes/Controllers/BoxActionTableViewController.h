
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

#import <Foundation/Foundation.h>
#import "BoxActionTextInputController.h"
#import "BoxCommentTableViewController.h"
#import "BoxPopupExampleController.h"

typedef enum _BoxActionType {
	BoxActionTypeUpload = 0,
	BoxActionTypeDelete,
	BoxActionTypeGetComment,
	BoxActionTypeAddComment,
	BoxActionTypeDeleteComment,
	BoxActionTypePublicShare,
	BoxActionTypePublicUnshare,
	BoxActionTypePrivateShare,
	BoxActionTypeCreateFolder,
	BoxActionTypeGetUpdates,
	BoxActionTypeRename,
	BoxActionTypeNoAction = 100
} BoxActionType;

@protocol BoxActionChooserDelegate <NSObject>

- (void)selectedAction:(BoxActionType)action withInfo:(NSDictionary *)info;

@end

@interface BoxActionTableViewController : UITableViewController<BoxActionInputDelegate, BoxCommentTableViewDelegate, BoxPopupExampleControllerDelegate> {
    id<BoxActionChooserDelegate> _delegate;
	
	NSArray *_actionNames;
	
	BoxActionType _actionType;
	
	BOOL _shouldReturn;
}

@property (assign) id<BoxActionChooserDelegate> delegate;
@property (retain) NSArray *actionNames;

@end
