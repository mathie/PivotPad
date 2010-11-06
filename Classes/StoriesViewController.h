//
//  StoriesViewController.h
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;
@class ASINetworkQueue;

@interface StoriesViewController : UITableViewController {
	NSArray *stories;
    Project *project;
    ASINetworkQueue *networkQueue;
}

@property (nonatomic, retain) NSArray *stories;
@property (nonatomic, retain) Project *project;

@property (nonatomic, retain) ASINetworkQueue *networkQueue;

- (void)getStoriesFromPivotal;

@end
