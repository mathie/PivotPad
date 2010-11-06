//
//  Project.h
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASINetworkQueue;

static id projectDelegate;

@interface Project : NSObject {
	NSString *projectId;
	NSString *name;
    ASINetworkQueue *networkQueue;
}

@property (nonatomic, retain) NSString *projectId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) ASINetworkQueue *networkQueue;

- (Project *)initWithProjectId:(NSString *)aProjectId andName:(NSString *)aName;

+(void)initialize;
+(void)findAllAndTell:delegate;

@end
