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
#import "LoginViewController.h"
//#import "ProjectsViewController.h"

@implementation StoriesViewController

@synthesize stories, project, networkQueue, popoverController, projectsViewController, filter;

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
    self.navigationItem.title = [project name];

	UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Done", @"Current", @"Backlog", @"Icebox", nil]];
	
	segmented.segmentedControlStyle = UISegmentedControlStyleBar;
	segmented.selectedSegmentIndex = 1;
	filter = 1;
	[segmented addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventValueChanged];

	
	UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView:segmented] autorelease];
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[self.navigationController setToolbarHidden:NO];
	self.toolbarItems = [NSArray arrayWithObjects:space, item, space, nil]; // [NSArray arrayWithObjects:item, nil];
	[segmented release];
	
	//[self getStoriesFromPivotal];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
		
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *token = [userDefaults objectForKey:@"token"];
	if (token == nil || [token length] == 0) {
		// Show login
		LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
		[login setParent:self];
		login.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentModalViewController:login animated:YES];		
	}
	
}

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
    
	// Configure the cell...
    Story *s = [stories objectAtIndex:indexPath.row];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		if ([s.storyType isEqualToString:@"feature"]) {
			cell.imageView.image = [UIImage imageNamed:@"feature_icon.png"];
		}
		else if ([s.storyType isEqualToString:@"bug"]) {
			cell.imageView.image = [UIImage imageNamed:@"bug_icon.png"];
		}
		else if ([s.storyType isEqualToString:@"chore"]) {
			cell.imageView.image = [UIImage imageNamed:@"chore_icon.png"];
		}
		else if ([s.storyType isEqualToString:@"release"]) {
			cell.imageView.image = [UIImage imageNamed:@"release_icon.png"];
		}
    }
    
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
	[detailViewController setStory: [stories objectAtIndex: indexPath.row]];
	
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	// */
}

#pragma mark -
#pragma mark Pivotal requests

- (IBAction)filterChanged:(id)sender {
	UISegmentedControl *segmented = (UISegmentedControl *)sender;
	filter = segmented.selectedSegmentIndex;
	[self getStoriesFromPivotal];
}

- (void)getStoriesFromPivotal
{
	if (project == nil)
		return;
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	self.navigationItem.title = project.name;
	
    [[self networkQueue] cancelAllOperations];
    
    [self setNetworkQueue:[ASINetworkQueue queue]];
    [[self networkQueue] setDelegate:self];
    [[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
    [[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
    [[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];

	NSString *urlString;
	
	switch (filter) {
		case 0:
			urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v3/projects/%@/iterations/done", [project projectId]];	
			break;
		case 1:
			urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v3/projects/%@/iterations/current", [project projectId]];
			break;
		case 2:
			urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v3/projects/%@/iterations/backlog", [project projectId]];
			break;
		case 3:
			urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v3/projects/%@/stories?filter=state:unscheduled", [project projectId]];
			break;
		default:
			urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/services/v3/projects/%@/stories", [project projectId]];
			break;
	}
	
    NSLog(@"Generated URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-TrackerToken" value:token];
    [[self networkQueue] addOperation:request];
    
    [[self networkQueue] go];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if ([[self networkQueue] requestsCount] == 0) {
        [self setNetworkQueue:nil]; 
    }

    NSData *responseData = [request responseData];
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:responseData options:0 error:nil] autorelease];
    
	if (self.stories == nil) {
		self.stories = [[NSMutableArray alloc] init];
	}
	[stories removeAllObjects];
	
    NSArray *storyNodes = [doc nodesForXPath:@"//story" error:nil];
    for(CXMLElement * storyNode in storyNodes) {
		NSLog(@"Look, elmo, a story node: %@", storyNode);
        NSString *storyId = [[[storyNode elementsForName:@"id"] objectAtIndex:0] stringValue];
        NSString *title = [[[storyNode elementsForName:@"name"] objectAtIndex:0] stringValue];
		NSString *description = [[[storyNode elementsForName:@"description"] objectAtIndex:0] stringValue];
        Story *story = [[Story alloc] initWithProject:project andStoryId:storyId andTitle:title andDescription:description];
		story.storyType = [[[storyNode elementsForName:@"story_type"] objectAtIndex:0] stringValue];
		
		//the following set are optional, or potentially optional
        NSArray *estimateEls = [storyNode elementsForName:@"estimate"];
		if ([estimateEls count]>0) {
			story.estimate = [[estimateEls objectAtIndex:0] stringValue];
		}
		
		NSArray *labelEls = [storyNode elementsForName:@"labels"];
		if ([labelEls count]>0) {
			story.labels = [[labelEls objectAtIndex:0] stringValue];
		}
		
		NSArray *requestedEls = [storyNode elementsForName:@"requested_by"];
		if ([requestedEls count]>0) {
			story.requestedBy = [[requestedEls objectAtIndex:0] stringValue];
		}
		
		NSArray *acceptedEls = [storyNode elementsForName:@"accepted_at"];
		if ([acceptedEls count]>0) {
			story.acceptedAt = [[acceptedEls objectAtIndex:0] stringValue];
		}
		
		NSArray *ownedEls = [storyNode elementsForName:@"owned_by"];
		if ([ownedEls count]>0) {
			story.ownedBy = [[ownedEls objectAtIndex:0] stringValue];
		}
		
		story.createdAt = [[[storyNode elementsForName:@"created_at"] objectAtIndex:0] stringValue];
		story.updatedAt = [[[storyNode elementsForName:@"updated_at"] objectAtIndex:0] stringValue];
		
        [stories addObject:story];
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
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	barButtonItem.title = @"Projects";
	[self.navigationController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
	self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
    self.popoverController = nil;
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

