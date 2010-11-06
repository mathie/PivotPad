//
//  StoriesViewController.h
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StoriesViewController : UITableViewController {
	NSArray *stories;
}

@property (nonatomic, retain) NSArray *stories;

@end
