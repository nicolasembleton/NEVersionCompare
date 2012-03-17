NEVersionCompare
================

A tiny Obj-c library for easy version comparisons.
Current version: *1.0.0*

Setup 
-----

1. Drag&drop the NEVersionCompare folder to your XCode project  
2. Import the .h file using: *#import "NEVersionCompare.h"*

You're done!

Typical Usage
-------------

This is how you create a typical NEVersionCompare object:

	NEVersionCompare *myVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.0.3.550"];

Advanced Use Case on iOS project
--------------------------------

### Popup an Alert View to your iOS app user when you release a new version and redirect them to the AppStore


	// Use Case: Test version at application opening time
	// File: AppDelegate.m
	// Requirement: Your class has to register to UIAlertViewDelegate by using <UIAlertViewDelegate>
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	/*  Test cases //
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.0"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.3"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.399"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.0.33"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.0.2.5339"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.0.3"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"I made a mistake!!! :)"];
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	 */
		// This line gets the current Application version number ( useful to compare against new versions ) 
	    NEVersionCompare *appVersion = [[NEVersionCompare alloc] initWithFullTextVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	
		// Typically get the latest available version from a .txt file somewhere on your server, 
	    // Remember to take care if Internet is available or not!
	    NSString *onlineVersionString = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.myserver.com/apps/myapp/version.txt"] encoding:NSUTF8StringEncoding error:nil];
	    NEVersionCompare *updatedVersion = [[NEVersionCompare alloc] initWithFullTextVersion:onlineVersionString];
	
	    // Or simply enter by hand ( not recommended though )
	    // NEVersionCompare *updatedVersion = [[NEVersionCompare alloc] initWithFullTextVersion:@"1.0.3.550"];
	
	
	    NSLog(@"Compare gave the result: %i ", [appVersion compareWith:updatedVersion withBuild:NO]);
	
	    if([appVersion compareWith:updatedVersion] == NEVersionSmallerThan) {
	        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Your Version is outdated" 
	                                                      message:@"A newer, greater version is available on the appStore, please click \"Open AppStore\" to go to the update process. Enjoy!" 
	                                                      delegate:self 
	                                                      cancelButtonTitle:@"Close" 
	                                                      otherButtonTitles:@"Open AppStore", nil];
	        [alertView show];
	    }
	
	
	// Then you can easily implement UIAlertView delegate to open the AppStore with your application
	
	#pragma mark -
	#pragma mark UIAlertViewDelegate implementation
	
	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	    NSLog(@"A button was clicked: %i", buttonIndex);
	    if(buttonIndex == 1) {
	        // Opens the appStore
	        NSURL *appStore = [[NSURL alloc] initWithString:@"itms-apps://itunes.com/apps/{APPLICATION-NAME}"];
	        [[UIApplication sharedApplication] openURL:appStore];
	    }
	}


Supported Patterns
------------------

Pretty much all patterns are supported, except that you have to use periods (".") as a separator
Like:
*	XXX 
*	XXX.XXX
* 	XXX.XXX.XX
*	XXX.XXX.XXX.XXX
*	XXX.Whateverwillnotbetakenintoaccountanyway
