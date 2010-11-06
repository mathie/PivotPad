//
//  Project.h
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject {
	NSString *projectId;
	NSString *name;
}

@property (nonatomic, retain) NSString *projectId;
@property (nonatomic, retain) NSString *name;

@end
