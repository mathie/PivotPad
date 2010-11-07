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
	NSString *type;
	NSDate *deadline;
	NSInteger *estimate;
	NSArray *labels;
	NSString *reporter;
	NSDate *created;
	NSString *owner;
	NSArray *tasks;
	NSArray *comments;
}

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSString *storyId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSDate *deadline;
@property NSInteger *estimate;
@property (nonatomic, retain) NSArray *labels;
@property (nonatomic, retain) NSString *reporter;
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSArray *tasks;
@property (nonatomic, retain) NSArray *comments;

+ (void)findAllForProject:(Project *)aProject andTell:(id)delegate;

- (Story *)initWithProject:(Project *)aProject andStoryId:(NSString *)aStoryId andTitle:(NSString *)aTitle andDescription:(NSString *)aDescription;

@end
