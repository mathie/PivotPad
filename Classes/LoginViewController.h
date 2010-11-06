//
//  LoginViewController.h
//  PivotPad
//
//  Created by Mihai Anca on 06/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {

	IBOutlet UITextField *login;
	IBOutlet UITextField *password;
	IBOutlet UIButton *button;
	id delegate;
}

@property (nonatomic, assign) id delegate;

- (IBAction) login:(id)sender;
- (void) setParent:(id)parent;

@end
