//
//  Project.m
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Project.h"
#import "Story.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "TouchXML.h"

@implementation Project

@synthesize name, projectId, stories, networkQueue;

+(void)initialize {
    projectDelegate = nil;
}

+(void)setDelegate:(id)aDelegate {
    projectDelegate = aDelegate;
}

+(id)delegate {
    return projectDelegate;
}

+(void)findAllAndTell:(id)delegate {
    [self setDelegate:delegate];
    [self findAll];
}

+(void)findAll {
    ASINetworkQueue *networkQueue = [ASINetworkQueue queue];
    [networkQueue setDelegate:self];
    [networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
    [networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    if(token != nil) {
        NSURL *url = [NSURL URLWithString:@"https://www.pivotaltracker.com/services/v3/projects"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"X-TrackerToken" value:token];
        [networkQueue addOperation:request];
        
        [networkQueue go];
    }
}

+ (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Request %@ finished successfully, received response:", [request url]);
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    NSData *responseData = [request responseData];
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:responseData options:0 error:nil] autorelease];
    
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    NSArray *projectNodes = [doc nodesForXPath:@"//project" error:nil];
    for(CXMLElement * projectNode in projectNodes) {
        NSLog(@"Look, ma, a project node: %@", projectNode);
        NSString *projectId = [[[projectNode elementsForName:@"id"] objectAtIndex:0] stringValue];
        NSString *name = [[[projectNode elementsForName:@"name"] objectAtIndex:0] stringValue];
        Project *project = [[Project alloc] initWithProjectId:projectId andName:name];
        [(NSMutableArray *)projects addObject:project];
        [project eagerLoadStories];
    }

    [[self delegate] projectsDidFindAll:[NSArray arrayWithArray:projects]];
}

+ (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Request %@ failed: %@", [request url], error);
}

- (Project *)initWithProjectId:(NSString *)aProjectId andName:(NSString *)aName {
    if(self = [super init]) {
        self.projectId = aProjectId;
        self.name = aName;
    }
    return self;
}

- (void)eagerLoadStories {
    [Story findAllForProject:self andTell:self];
}

- (void)storiesDidFindAll:(NSArray *)someStories {
    self.stories = someStories;
}

- (void) dealloc {
    [super dealloc];

	[name release];
	[projectId release];
} 

@end
