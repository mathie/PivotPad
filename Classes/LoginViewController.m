    //
//  LoginViewController.m
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "DetailViewController.h"
#import "ProjectsViewController.h"
#import "ASIHTTPRequest.h"
#import "CXMLDocument.h"

@implementation LoginViewController
@synthesize delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction) login:(id)sender {
	
	button.hidden = YES;
	[indicator startAnimating];
	
	//[userDefaults setObject:((UITextField*)login).text forKey:@"username"];
	//[userDefaults setObject:((UITextField*)password).text forKey:@"password"];
	
	NSURL *url = [NSURL URLWithString:@"https://www.pivotaltracker.com/services/v3/tokens/active"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setUsername:login.text]; //@"mathie+pivotpad@woss.name"];
	[request setPassword:password.text]; //@"iev7Quah"];
	[request setDelegate:self];
	[request startAsynchronous];
    NSLog(@"Started HTTP request.");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"Got back a response: %@", [request responseString]);
	NSData *responseData = [request responseData];
	CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:responseData options:0 error:nil] autorelease];
	
	NSArray *nodes = [doc nodesForXPath:@"//guid" error:nil];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[[nodes objectAtIndex:0] stringValue] forKey:@"token"];
	
	button.hidden = NO;
	[indicator stopAnimating];
	[(StoriesViewController*)delegate doLogin];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	button.hidden = NO;
	[indicator stopAnimating];

    
    NSError *error = [request error];
    NSLog(@"Request %@ failed: %@", [request url], error);
}

- (void) setParent:(id)parent{
	self.delegate = parent;
}



- (void)dealloc {
    [super dealloc];
}


@end
