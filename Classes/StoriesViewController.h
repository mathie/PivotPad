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
	NSMutableArray *stories;
    Project *project;
    ASINetworkQueue *networkQueue;
	NSInteger filter;
	
	UIPopoverController *popoverController;
	ProjectsViewController *projectsViewController;
}

@property (nonatomic, retain) NSMutableArray *stories;
@property (nonatomic, retain) Project *project;
@property (nonatomic) NSInteger filter;

@property (nonatomic, retain) ASINetworkQueue *networkQueue;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, assign) IBOutlet ProjectsViewController *projectsViewController;

- (void)getStoriesFromPivotal;

- (IBAction)filterChanged:(id)sender;

@end
