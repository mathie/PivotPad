//
//  StoriesViewController.h
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ProjectsViewController;
@class Project;
@class ASINetworkQueue;

@interface StoriesViewController : UITableViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
	NSArray *stories;
    Project *project;
    ASINetworkQueue *networkQueue;
	
	UIPopoverController *popoverController;
	ProjectsViewController *projectsViewController;
}

@property (nonatomic, retain) NSArray *stories;
@property (nonatomic, retain) Project *project;

@property (nonatomic, retain) ASINetworkQueue *networkQueue;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, assign) IBOutlet ProjectsViewController *projectsViewController;

- (void)getStoriesFromPivotal;

@end
