//
//  ProjectsViewController.m
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProjectsViewController.h"
#import "Project.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "TouchXML.h"
#import "StoriesViewController.h"

@implementation ProjectsViewController
@synthesize detailViewController, managedObjectContext, projects, networkQueue;

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
    [self getProjectsFromPivotal];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [projects count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Project";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    Project *p = [projects objectAtIndex:indexPath.row];
	cell.textLabel.text = p.name;
	
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
#pragma mark Pivotal requests
- (void)getProjectsFromPivotal
{
    [[self networkQueue] cancelAllOperations];

    [self setNetworkQueue:[ASINetworkQueue queue]];
    [[self networkQueue] setDelegate:self];
    [[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
    [[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
    [[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    if(token != nil) {
        NSURL *url = [NSURL URLWithString:@"https://www.pivotaltracker.com/services/v3/projects"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

        [request addRequestHeader:@"X-TrackerToken" value:token];
        [[self networkQueue] addOperation:request];

        [[self networkQueue] go];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  if ([[self networkQueue] requestsCount] == 0) {
    [self setNetworkQueue:nil]; 
  }

  NSLog(@"Request %@ finished successfully, received response:", [request url]);
  NSString *responseString = [request responseString];
  NSLog(@"%@", responseString);

  NSData *responseData = [request responseData];
  CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:responseData options:0 error:nil] autorelease];

  self.projects = [[NSMutableArray alloc] init];
  NSArray *projectNodes = [doc nodesForXPath:@"//project" error:nil];
  for(CXMLElement * projectNode in projectNodes) {
    NSLog(@"Look, ma, a project node: %@", projectNode);
    NSString *projectId = [[[projectNode elementsForName:@"id"] objectAtIndex:0] stringValue];
    NSString *name = [[[projectNode elementsForName:@"name"] objectAtIndex:0] stringValue];
    Project *project = [[Project alloc] initWithProjectId:projectId andName:name];
    [(NSMutableArray *)projects addObject:project];
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoriesViewController *storiesViewController = [[StoriesViewController alloc] initWithStyle:UITableViewStylePlain];
    storiesViewController.project = [projects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:storiesViewController animated:YES];
    [storiesViewController release];
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
    [networkQueue release];
	[projects dealloc];
    [super dealloc];
}


@end

