//
//  MLLocationViewerViewController.h
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface MLLocationViewerViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbLocationAddress;
@property (strong, nonatomic) IBOutlet UILabel *lbLocationDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) UIActionSheet *actionSheet;

//-----------------property for call back function
@property (copy, readwrite, nonatomic) void (^deleteBtnObjectHandler)(Location* location);


@property Location *curLocation;


//---display the location values with the controls
-(void)loadLocationValues;
- (IBAction)deleteDataConfirmWithActionSheet:(id)sender;
@end
