
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
 * The BoxFlipViewController contains both the Register and Login views (the flip view is not completely decoupled from the specific
 * action of logging in and registering). You create a FlipViewController and pass it two controllers - a login and a view controller
 * Those controllers get passed a pointer to the flipviewcontroller and can call doFlipAction, startSpinnerOverlay, endSpinnerOverlay etc.
 * 
 */

#import <UIKit/UIKit.h>
#import "BoxCommonUISetup.h"
#import "BoxUser.h"
#import "BoxSpinnerOverlayViewController.h"
#import "BoxFolder+SaveableFolder.h"

@protocol BoxFlipViewCompatible;

@interface BoxFlipViewController : UIViewController {
	UIViewController<BoxFlipViewCompatible,NSObject> * _controller1;
	UIViewController<BoxFlipViewCompatible,NSObject> * _controller2;
	
	UIViewController<BoxFlipViewCompatible,NSObject> * _currentController;
	
	IBOutlet UIView  * _sectionTitleView;
	IBOutlet UILabel * _sectionTitleLabel;
	IBOutlet UIView  * _contentView;
		
	BoxSpinnerOverlayViewController * _spinnerOverlay;
}

@property (readonly) UIView  * sectionTitleView;
@property (readonly) UILabel * sectionTitleLabel;

- (id) initWithNibName:(NSString*)name andBundle:(NSBundle*)bundle andInitialController:(UIViewController <BoxFlipViewCompatible> *)controller1 andSecondaryController:(UIViewController <BoxFlipViewCompatible> *)controller2 andPrimaryControllerFirst:(BOOL)first;

-(void)doFlipAction;
-(void)startSpinnerOverlay;
-(void)endSpinnerOverlay;

@end

@protocol BoxFlipViewCompatible

@required 
-(void)setBoxFlipViewController:(BoxFlipViewController*)flipController;

@end
