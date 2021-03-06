//
//  Project.h
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASINetworkQueue;

@interface Project : NSObject {
	NSString *projectId;
	NSString *name;
    NSArray *stories;
    ASINetworkQueue *networkQueue;
}

@property (nonatomic, retain) NSString *projectId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) ASINetworkQueue *networkQueue;
@property (nonatomic, retain) NSArray *stories;

- (Project *)initWithProjectId:(NSString *)aProjectId andName:(NSString *)aName;

+(void)initialize;
+(void)findAllAndTell:delegate;

@end
