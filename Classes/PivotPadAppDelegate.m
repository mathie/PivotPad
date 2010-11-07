//
//  PivotPadAppDelegate.m
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import "PivotPadAppDelegate.h"

#import "DetailViewController.h"
#import "ProjectsViewController.h"

@implementation PivotPadAppDelegate

@synthesize window, splitViewController, projectsViewController, detailViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// Add the split view controller's view to the window and display.
	[self.window addSubview:splitViewController.view];
    [self.window makeKeyAndVisible];
	
	return YES;
}

- (void)dealloc {
	[splitViewController release];
	[projectsViewController release];
	[detailViewController release];

	[window release];
	[super dealloc];
}


@end

