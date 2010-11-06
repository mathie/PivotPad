//
//  ProjectsViewController.h
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface ProjectsViewController : UITableViewController {
    DetailViewController *detailViewController;
    NSManagedObjectContext *managedObjectContext;
	NSArray *projects;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSArray *projects;
@end
