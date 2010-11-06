//
//  ProjectsViewController.h
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProjectsViewController : UITableViewController {
	NSArray *projects;
}

@property (nonatomic, retain) NSArray *projects;

@end
