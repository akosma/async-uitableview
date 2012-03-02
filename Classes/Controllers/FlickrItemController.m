//
//  FlickrItemController.m
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import "FlickrItemController.h"
#import "FlickrItem.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@implementation FlickrItemController

@synthesize item;

#pragma mark -
#pragma mark Constructor and destructor

- (id)init
{
    if (self = [super initWithNibName:@"FlickrItem" bundle:nil]) 
    {
        downloadQueue = [[ASINetworkQueue alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [downloadQueue release];
    [item setDelegate:nil];
    [item release];
    [super dealloc];
}

#pragma mark -
#pragma mark Overridden setter

- (void)setItem:(FlickrItem *)newItem
{
    if (item != newItem)
    {
        [item setDelegate:nil];
        [item release];
        item = nil;
        item = [newItem retain];
        
        if (item != nil)
        {
            item.delegate = self;
            saveButton.enabled = NO;
            saveButton.alpha = 0.5;
        }
    }
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)save
{
    UIImageWriteToSavedPhotosAlbum(photoView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -
#pragma mark UIImageWriteToSavedPhotosAlbum delegate method

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved"
                                                    message:@"The image has been saved in your photo album!" 
                                                   delegate:nil 
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark FlickrItemDelegate methods

- (void)flickrItem:(FlickrItem *)item didLoadImage:(UIImage *)image
{
    photoView.image = image;
    saveButton.enabled = YES;
    saveButton.alpha = 1.0;
}

- (void)flickrItem:(FlickrItem *)item couldNotLoadImageError:(NSError *)error
{
}

#pragma mark -
#pragma mark ASINetworkQueue delegate methods

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    UIImage *remoteImage = [[UIImage alloc] initWithData:data];
    photoView.image = remoteImage;
    progressView.hidden = YES;
    [remoteImage release];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
//    NSError *error = [request error];
}

#pragma mark -
#pragma mark UIViewController overridden methods

- (void)viewDidAppear:(BOOL)animated
{
    // Begin the asynchronous downloading of the image.
    progressView.progress = 0.0;
    NSURL *url = [NSURL URLWithString:item.imageURL];
    
    // Somehow, updating the progress view cannot be properly done
    // without a queue (thread issues?), so here we use a local
    // queue which updates the UIProgressView instance.
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
    [downloadQueue setDelegate:self];
    [downloadQueue setRequestDidFinishSelector:@selector(requestDone:)];
    [downloadQueue setRequestDidFailSelector:@selector(requestWentWrong:)];
    [downloadQueue setShowAccurateProgress:YES];
    [downloadQueue setDownloadProgressDelegate:progressView];
    [downloadQueue addOperation:request];
    [downloadQueue go];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

@end
