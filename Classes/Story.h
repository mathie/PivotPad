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
}

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSString *storyId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;

- (Story *)initWithProject:(Project *)aProject andStoryId:(NSString *)aStoryId andTitle:(NSString *)aTitle andDescription:(NSString *)aDescription;

@end
