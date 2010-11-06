//
//  StoriesViewController.m
//  PivotPad
//
//  Created by Graeme Mathieson on 06/11/2010.
//  Copyright 2010 FreeAgent Central. All rights reserved.
//

#import "StoriesViewController.h"
#import "Story.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "TouchXML.h"
#import "Project.h"
#import "DetailViewController.h"

@implementation StoriesViewController

@synthesize stories, project, networkQueue;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Stories";
	
    [self getStoriesFromPivotal];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [stories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Story";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    Story *s = [stories objectAtIndex:indexPath.row];
	cell.textLabel.text = s.title;
	cell.detailTextLabel.text = s.description;

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	// */
}

#pragma mark -
#pragma mark Pivotal requests
- (void)getStoriesFromPivotal
{
	if (project == nil)
		return;
	
	self.navigationItem.title = project.name;
	
    [[self networkQueue] cancelAllOperations];
    
    [self setNetworkQueue:[ASINetworkQueue queue]];
    [[self networkQueue] setDelegate:self];
    [[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
    [[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
    [[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    NSString *urlString = [NSString stringWithFormat:@"http://fakept.heroku.com/services/v3/projects/%@/stories", [project projectId]];
    NSLog(@"Generated URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-TrackerToken" value:@"sometokenstring"];
    [[self networkQueue] addOperation:request];
    
    [[self networkQueue] go];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if ([[self networkQueue] requestsCount] == 0) {
        [self setNetworkQueue:nil]; 
    }

    NSData *responseData = [request responseData];
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:responseData options:0 error:nil] autorelease];
    
    self.stories = [[NSMutableArray alloc] init];
    NSArray *storyNodes = [doc nodesForXPath:@"//story" error:nil];
    for(CXMLElement * storyNode in storyNodes) {
        NSString *storyId = [[[storyNode elementsForName:@"id"] objectAtIndex:0] stringValue];
        NSString *title = [[[storyNode elementsForName:@"name"] objectAtIndex:0] stringValue];
		NSString *description = [[[storyNode elementsForName:@"description"] objectAtIndex:0] stringValue];
        Story *story = [[Story alloc] initWithProject:project andStoryId:storyId andTitle:title andDescription:description];
        [(NSMutableArray *)stories addObject:story];
    }

    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    if ([[self networkQueue] requestsCount] == 0) {
        [self setNetworkQueue:nil]; 
    }
    
    NSError *error = [request error];
    NSLog(@"Request %@ failed: %@", [request url], error);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
    if ([[self networkQueue] requestsCount] == 0) {
        [self setNetworkQueue:nil]; 
    }
    NSLog(@"Queue finished");
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

