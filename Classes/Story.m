//
//  Story.m
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import "Story.h"
#import "TouchXML.h"

@implementation Story

@synthesize project, storyId, title, description, storyType, estimate, labels, requestedBy, createdAt, updatedAt, acceptedAt, ownedBy, tasks, comments, currentState;

+ (void)findAllForProject:(Project *)aProject andTell:(id)delegate {
}

+ (Story *)storyFromXMLElement:(CXMLElement *)storyElement {
    return [[Story alloc] initFromXMLElement:storyElement];
}

- (Story *)initFromXMLElement:(CXMLElement *)storyElement {
    if (self = [self init]) {
        // Mandatory elements
        self.storyId      = [[[storyElement elementsForName:@"id"] objectAtIndex:0] stringValue];
        self.title        = [[[storyElement elementsForName:@"name"] objectAtIndex:0] stringValue];
		self.description  = [[[storyElement elementsForName:@"description"] objectAtIndex:0] stringValue];
		self.storyType    = [[[storyElement elementsForName:@"story_type"] objectAtIndex:0] stringValue];
        self.currentState = [[[storyElement elementsForName:@"current_state"] objectAtIndex:0] stringValue];
		self.createdAt    = [[[storyElement elementsForName:@"created_at"] objectAtIndex:0] stringValue];
		self.updatedAt    = [[[storyElement elementsForName:@"updated_at"] objectAtIndex:0] stringValue];
		
		//the following set are optional, or potentially optional
        NSArray *estimateEls = [storyElement elementsForName:@"estimate"];
		if ([estimateEls count]>0) {
			self.estimate = [[estimateEls objectAtIndex:0] stringValue];
		}
		
		NSArray *labelEls = [storyElement elementsForName:@"labels"];
		if ([labelEls count]>0) {
			self.labels = [[labelEls objectAtIndex:0] stringValue];
		}
		
		NSArray *requestedEls = [storyElement elementsForName:@"requested_by"];
		if ([requestedEls count]>0) {
			self.requestedBy = [[requestedEls objectAtIndex:0] stringValue];
		}
		
		NSArray *acceptedEls = [storyElement elementsForName:@"accepted_at"];
		if ([acceptedEls count]>0) {
			self.acceptedAt = [[acceptedEls objectAtIndex:0] stringValue];
		}
		
		NSArray *ownedEls = [storyElement elementsForName:@"owned_by"];
		if ([ownedEls count]>0) {
			self.ownedBy = [[ownedEls objectAtIndex:0] stringValue];
		}
		
        
    }
    return self;
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

-(BOOL)done {
    return [currentState isEqualToString:@"accepted"];
}

-(BOOL)canMoveStory {
    return ![self done];
}

@end
