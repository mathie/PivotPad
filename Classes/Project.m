//
//  Project.m
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Project.h"

@implementation Project

@synthesize name, projectId;

- (void) dealloc {
	[name release];
	[projectId release];
} 

@end
