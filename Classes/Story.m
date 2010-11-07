//
//  Story.m
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import "Story.h"


@implementation Story

@synthesize project, storyId, title, description, type, deadline, estimate, labels, reporter, created, owner, tasks, comments;

+ (void)findAllForProject:(Project *)aProject andTell:(id)delegate {
}


- (Story *)initWithProject:(Project *)aProject andStoryId:(NSString *)aStoryId andTitle:(NSString *)aTitle andDescription:(NSString *)aDescription {
    if(self = [super init]) {
        self.project = aProject;
        self.storyId = aStoryId;
        self.title = aTitle;
		self.description = aDescription;
    }
    return self;
}

@end
