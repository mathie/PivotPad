//
//  PivotPadAppDelegate.h
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectsViewController;
@class DetailViewController;
@class ASINetworkQueue;

@interface PivotPadAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;

	UISplitViewController *splitViewController;

	ProjectsViewController *projectsViewController;
	DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet ProjectsViewController *projectsViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
