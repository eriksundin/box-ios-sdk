//
//  BoxPopupExampleController.h
//  BoxPopup
//
//  Created by Michael Smith on 9/8/09.
//  Copyright 2009 Box.net.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
//  See the License for the specific language governing permissions and 
//  limitations under the License. 
//

/*
 * The BoxPopupExampleController gives several examples for how the box popup application can be used and configured.
 * It provides buttons that result in different results returned for the BoxPopupDelegate
 *
 * When using this, remember to change the direct login key in BoxRESTApiFactory.m
 */

#import <UIKit/UIKit.h>
#import "BoxPopupController.h"
#import "BoxPopupDelegate.h"

typedef enum _BoxPopupControllerTestButtonSelected {
	BoxPopupControllerTestButtonImageWithBaseFileAndDate, // Upload an image with a base file name defined and attach a date to the file name
	BoxPopupControllerTestButtonTextFileWithBaseFile,	  // Upload a text file with a base file name defined
	BoxPopupControllerTestButtonWordDocWithNoBaseFile,    // Upload a word document
	BoxPopupControllerTestButtonWordDocWithBaseFile,      // Upload a word document with a base file defined 
	BoxPopupControllerTestButtonImageWithNoBaseFile       // Upload an image
} BoxPopupControllerTestButtonSelected;

@interface BoxPopupExampleController : UIViewController <BoxPopupDelegate> {
	IBOutlet UIButton * _popupBoxImageWithBaseFileAndDate;
	IBOutlet UIButton * _popupBoxTextFileWithBaseFile;
	IBOutlet UIButton * _popupBoxWordDocWithNoBaseFile;
	IBOutlet UIButton * _popupBoxWordDocWithBaseFile;
	IBOutlet UIButton * _popupBoxImageWithNoBaseFile;

	BoxPopupController * _boxPopupController;
}

/*
 * See this function for an example of how to popup the box popup controller
 */
-(IBAction) popupBoxAction:(id)sender;

@end
