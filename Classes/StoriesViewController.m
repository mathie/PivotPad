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
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [project name];
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];

	UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Done", @"Current", @"Backlog", @"Icebox", nil]];
	
	segmented.segmentedControlStyle = UISegmentedControlStyleBar;
	segmented.selectedSegmentIndex = 1;
	filter = 1;
	[segmented addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventValueChanged];

	
	UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView:segmented] autorelease];
	UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem *space2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	[self.navigationController setToolbarHidden:NO];
	self.toolbarItems = [NSArray arrayWithObjects:space, item, space2, nil];
	[segmented release];
}

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
	
	hidden = NO;
	self.splitViewController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
	hidden = YES;
}

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
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[stories objectAtIndex:indexPath.row] canMoveStory];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Story *storyToMove = [[stories objectAtIndex:sourceIndexPath.row] retain];
    [stories removeObjectAtIndex:sourceIndexPath.row];
    [stories insertObject:storyToMove atIndex:destinationIndexPath.row];
    [storyToMove release];
}

#pragma mark -
#pragma mark Pivotal requests

- (IBAction)filterChanged:(id)sender {
	UISegmentedControl *segmented = (UISegmentedControl *)sender;
	filter = segmented.selectedSegmentIndex;
	[self getStoriesFromPivotal];
}

- (IBAction)signout:(id)sender {
	[self.stories removeAllObjects];
	[self.tableView reloadData];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults removeObjectForKey:@"token"];
	// Show login
	LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
	[login setParent:self];
	login.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:login animated:YES];	
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
        Story *story = [Story storyFromXMLElement:storyNode];
		
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

- (void)doLogin {
	[self dismissModalViewControllerAnimated:YES];
    [Project findAllAndTell:[self projectsViewController]];
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    if (hidden) {
		//return;
	}
	barButtonItem.title = @"Projects";
	[self.navigationController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
	self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	if (hidden) {
		//return;
	}
	
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
    self.popoverController = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end

