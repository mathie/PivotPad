//
//  Story.h
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;

@interface Story : NSObject {
    Project *project;
	NSString *storyId;
	NSString *title;
	NSString *description;
	NSString *storyType;
	NSString *estimate;
	NSString *labels;
	NSString *requestedBy;
	NSString *createdAt;
	NSString *updatedAt;
	NSString *acceptedAt;
	NSString *ownedBy;
	NSString *tasks;
	NSString *comments;
}

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSString *storyId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *storyType;
@property (nonatomic, retain) NSString *estimate;
@property (nonatomic, retain) NSString *labels;
@property (nonatomic, retain) NSString *requestedBy;
@property (nonatomic, retain) NSString *createdAt;
@property (nonatomic, retain) NSString *updatedAt;
@property (nonatomic, retain) NSString *acceptedAt;
@property (nonatomic, retain) NSString *ownedBy;
@property (nonatomic, retain) NSString *tasks;
@property (nonatomic, retain) NSString *comments;

+ (void)findAllForProject:(Project *)aProject andTell:(id)delegate;

- (Story *)initWithProject:(Project *)aProject andStoryId:(NSString *)aStoryId andTitle:(NSString *)aTitle andDescription:(NSString *)aDescription;

@end
