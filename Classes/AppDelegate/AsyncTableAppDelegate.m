//
//  AsyncTableAppDelegate.m
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright akosma software 2009. All rights reserved.
//

#import "AsyncTableAppDelegate.h"
#import "FlickrController.h"

@implementation AsyncTableAppDelegate

@synthesize downloadQueue;

+ (AsyncTableAppDelegate *)sharedAppDelegate
{
    return (AsyncTableAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc 
{
    [controller release];
    [downloadQueue release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIApplicationDelegate methods

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    downloadQueue = [[NSOperationQueue alloc] init];
    controller = [[FlickrController alloc] init];
    [window addSubview:controller.navigationController.view];
    [window makeKeyAndVisible];
    [controller reloadFeed];
}

#pragma mark -
#pragma mark Public methods

- (void)showLoadingView
{
    if (loadingView == nil)
    {
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 0.5;

        UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(142.0, 222.0, 37.0, 37.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
        [spinningWheel release];
    }
    
    [window addSubview:loadingView];
}

- (void)hideLoadingView
{
    [loadingView removeFromSuperview];
}

@end
