//
//  Story.m
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import "Story.h"


@implementation Story

@synthesize project, storyId, title;

- (Story *)initWithProject:(Project *)aProject andStoryId:(NSString *)aStoryId andTitle:(NSString *)aTitle {
    if(self = [super init]) {
        self.project = aProject;
        self.storyId = aStoryId;
        self.title = aTitle;
    }
    return self;
}

@end
