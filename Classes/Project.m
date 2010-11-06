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

- (Project *)initWithProjectId:(NSString *)aProjectId andName:(NSString *)aName {
    if(self = [super init]) {
        self.projectId = aProjectId;
        self.name = aName;
    }
    return self;
}

- (void) dealloc {
    [super dealloc];

	[name release];
	[projectId release];
} 

@end
