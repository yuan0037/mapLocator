//
//  MLAddLocationViewController.h
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLocations.h"
#import "Location.h"

@interface MLLocationEditorViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *tfLocationDescription;
@property (strong, nonatomic) IBOutlet UITextField *tfAddress;
@property (strong, nonatomic) IBOutlet UILabel *lbStatus;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel; 

//--------------the following scrollview is used to contain all of the data entry controls. If there are
//--------------more controls later and the keyboard can hide some of them during inputting text,
//--------------can set up the scrollview's contentoffset to show the control without being hide by the keyboard
@property (strong, nonatomic) IBOutlet UIScrollView *dataEntryContentView;

@property (strong, nonatomic) IBOutlet UIView *buttonGroupContentView;

//-----------------property for call back function to handle the save button when dealing with the storage--------------------------
@property (copy, readwrite, nonatomic) void (^saveBtnObjectHandler)(Location* location);

//-----------------custom Location object, used to hold the new location object with the description/name/cooridinates after save button is clicked-----------------
@property (strong, nonatomic) Location *curLocation;
@property (nonatomic, assign) BOOL hasCalledBack;

- (IBAction)saveData:(id)sender;
- (IBAction)cancel:(id)sender;

//-----------------dismiss the current view after 1 sec delay once the save button is clicked----------------
-(void)closeView:(NSTimer*)timer;
@end
