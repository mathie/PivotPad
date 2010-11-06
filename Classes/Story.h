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
}

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSString *storyId;
@property (nonatomic, retain) NSString *title;

- (Story *)initWithProject:(Project *)aProject andStoryId:(NSString *)aStoryId andTitle:(NSString *)aTitle;

@end
