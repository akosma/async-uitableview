//
//  FlickrController.m
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlickrController.h"
#import "RSS.h"
#import "Definitions.h"
#import "FlickrItem.h"
#import "FlickrCell.h"
#import "FlickrItemController.h"
#import "AsyncTableAppDelegate.h"
#import "Reachability.h"

@interface FlickrController (Private)
- (void)loadContentForVisibleCells;
@end


@implementation FlickrController

@synthesize navigationController;

- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) 
    {
        navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        self.title = @"Flickr RSS Feed";
        rss = [[RSS alloc] init];
        rss.delegate = self;
        NSURL *url = [[NSURL alloc] initWithString:NEWS_FEED_URL];
        rss.url = url;
        [url release];
        
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                      target:self 
                                                                                      action:@selector(reloadFeed)];
        self.navigationItem.rightBarButtonItem = reloadButton;
        [reloadButton release];
    }
    return self;
}

- (void)dealloc 
{
    [navigationController release];
    [flickrItems release];
    [rss setDelegate:nil];
    [rss release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (void)reloadFeed
{
    // Check if the remote server is available
    Reachability *reachManager = [Reachability sharedReachability];
    AsyncTableAppDelegate *appDelegate = [AsyncTableAppDelegate sharedAppDelegate];
    [reachManager setHostName:@"www.flickr.com"];
    NetworkStatus remoteHostStatus = [reachManager remoteHostStatus];
    if (remoteHostStatus == NotReachable)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSString *msg = @"Flickr is not reachable! This requires Internet connectivity.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    else if (remoteHostStatus == ReachableViaWiFiNetwork)
    {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:4];
    }
    else if (remoteHostStatus == ReachableViaCarrierDataNetwork)
    {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    
    [appDelegate showLoadingView];
    [rss fetch];
}

#pragma mark -
#pragma mark RSSDelegate methods

- (void)feed:(RSS *)feed didFindItems:(NSArray *)items
{
    [flickrItems release];
    flickrItems = [items retain];
    [self.tableView reloadData];
    [self loadContentForVisibleCells]; 
    [[AsyncTableAppDelegate sharedAppDelegate] hideLoadingView];
}

- (void)feed:(RSS *)feed didFailWithError:(NSString *)errorMsg
{
    [[AsyncTableAppDelegate sharedAppDelegate] hideLoadingView];
}

#pragma mark -
#pragma mark FlickrCellDelegate methods

- (void)flickrCellAnimationFinished:(FlickrCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FlickrItem *item = [flickrItems objectAtIndex:indexPath.row];
    FlickrItemController *controller = [[FlickrItemController alloc] init];
    controller.item = item;
    controller.title = item.title;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];    
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

// These methods are adapted from
// http://idevkit.com/forums/tutorials-code-samples-sdk/2-dynamic-content-loading-uitableview.html

- (void)loadContentForVisibleCells
{
    NSArray *cells = [self.tableView visibleCells];
    [cells retain];
    for (int i = 0; i < [cells count]; i++) 
    { 
        // Go through each cell in the array and call its loadContent method if it responds to it.
        FlickrCell *flickrCell = (FlickrCell *)[[cells objectAtIndex: i] retain];
        [flickrCell loadImage];
        [flickrCell release];
        flickrCell = nil;
    }
    [cells release];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
    // Method is called when the decelerating comes to a stop.
    // Pass visible cells to the cell loading function. If possible change 
    // scrollView to a pointer to your table cell to avoid compiler warnings
    [self loadContentForVisibleCells]; 
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (!decelerate) 
    {
        [self loadContentForVisibleCells]; 
    }
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [flickrItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    FlickrItem *item = [flickrItems objectAtIndex:indexPath.row];
    static NSString *identifier = @"FlickrItemCell";
    FlickrCell *cell = (FlickrCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) 
    {
        CGRect rect = CGRectMake(0.0, 0.0, 320.0, 75.0);
        cell = [[[FlickrCell alloc] initWithFrame:rect reuseIdentifier:identifier] autorelease];
        cell.delegate = self;
    }
    cell.item = item;
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FlickrCell *flickrCell = (FlickrCell *)cell;
//    [flickrCell loadImage];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    FlickrCell *cell = (FlickrCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell toggleImage];
}

#pragma mark -
#pragma mark UIViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated 
{
    self.tableView.rowHeight = 76.0;

    // Unselect the selected row if any
    // http://forums.macrumors.com/showthread.php?t=577677
    NSIndexPath* selection = [self.tableView indexPathForSelectedRow];
    if (selection)
    {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

@end
