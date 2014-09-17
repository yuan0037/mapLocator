//
//  MLLocationViewerViewController.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import "MLLocationViewerViewController.h"

@interface MLLocationViewerViewController ()

@end

@implementation MLLocationViewerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.curLocation!=nil)
    [self loadLocationValues];
}

#pragma mark - display location details 
//-------------used to display the current location object's values on the controls--------
-(void)loadLocationValues
{
    self.lbLocationDescription.text=self.curLocation.locationDesc;
    self.lbLocationAddress.text=self.curLocation.locationAddress;
}


#pragma mark - delete button handling
- (IBAction)deleteDataConfirmWithActionSheet:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc]
                            initWithTitle:@"Do you really want to delete?"
                            delegate:self
                            cancelButtonTitle:@"Cancel"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"Delete", nil];
    self.actionSheet.tag=1;
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [self.actionSheet showInView:self.view];
    } else {
        [self.actionSheet showInView:window];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
 
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            //do nothing if cancel the delete action
        }
        else
        {
      		//NSLog(@"confirm delete clicked");
            if (buttonIndex==0)
            {
            [self.navigationController popViewControllerAnimated: YES];
             if(self.deleteBtnObjectHandler)
                self.deleteBtnObjectHandler(self.curLocation);
            }
        }
}



@end
