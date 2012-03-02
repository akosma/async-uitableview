//
//  FlickrItem.m
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import "FlickrItem.h"
#import "ASIHTTPRequest.h"
#import "AsyncTableAppDelegate.h"

@interface FlickrItem (Private)
- (void)loadURL:(NSURL *)url;
@end


@implementation FlickrItem

@synthesize title;
@synthesize link;
@synthesize summary;
@synthesize date;
@synthesize imageURL;
@synthesize thumbnailURL;
@synthesize thumbnail;
@synthesize delegate;

- (void)dealloc
{
    delegate = nil;
    [thumbnail release];
    [imageURL release];
    [thumbnailURL release];
    [title release];
    [link release];
    [summary release];
    [date release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (BOOL)hasLoadedThumbnail
{
    return (thumbnail != nil);
}

#pragma mark -
#pragma mark Overridden setters

- (UIImage *)thumbnail
{
    if (thumbnail == nil)
    {
        NSURL *url = [NSURL URLWithString:self.thumbnailURL];
        [self loadURL:url];
    }
    return thumbnail;
}

#pragma mark -
#pragma mark ASIHTTPRequest delegate methods

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    UIImage *remoteImage = [[UIImage alloc] initWithData:data];
    self.thumbnail = remoteImage;
    if ([delegate respondsToSelector:@selector(flickrItem:didLoadThumbnail:)])
    {
        [delegate flickrItem:self didLoadThumbnail:self.thumbnail];
    }
    [remoteImage release];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if ([delegate respondsToSelector:@selector(flickrItem:couldNotLoadImageError:)])
    {
        [delegate flickrItem:self couldNotLoadImageError:error];
    }
}

#pragma mark -
#pragma mark Private methods

- (void)loadURL:(NSURL *)url
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [AsyncTableAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:request];
    [request release];    
}

@end
