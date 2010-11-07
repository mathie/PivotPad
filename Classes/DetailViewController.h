//
//  DetailViewController.h
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Story.h"

@class ProjectsViewController;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
	IBOutlet UIWebView *webView;
	
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    NSManagedObject *detailItem;
    ProjectsViewController *projectsViewController;

    Story *story;

    UILabel *ownedByLabel;
    UILabel *requestedByLabel;
    UILabel *createdAtLabel;
    UILabel *labelsLabel;
    UILabel *estimateLabel;
    UITextView *descriptionTextView;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;


@property (nonatomic, retain) Story *story;

@property (nonatomic, assign) IBOutlet ProjectsViewController *projectsViewController;

@property (nonatomic, retain) IBOutlet UILabel    *ownedByLabel;
@property (nonatomic, retain) IBOutlet UILabel    *requestedByLabel;
@property (nonatomic, retain) IBOutlet UILabel    *createdAtLabel;
@property (nonatomic, retain) IBOutlet UILabel    *labelsLabel;
@property (nonatomic, retain) IBOutlet UILabel    *estimateLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;

- (void)doLogin;
@end
