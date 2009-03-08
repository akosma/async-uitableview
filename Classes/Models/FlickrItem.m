//
//  FlickrItem.m
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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
@synthesize image;
@synthesize thumbnail;
@synthesize delegate;

- (void)dealloc
{
    delegate = nil;
    [image release];
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
#pragma mark Overridden setters

- (UIImage *)image
{
    if (image == nil)
    {
        loadingThumbnail = NO;
        NSURL *url = [NSURL URLWithString:self.imageURL];
        [self loadURL:url];
    }
    return image;
}

- (UIImage *)thumbnail
{
    if (thumbnail == nil)
    {
        loadingThumbnail = YES;
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

    if (loadingThumbnail)
    {
        self.thumbnail = remoteImage;
        if ([delegate respondsToSelector:@selector(flickrItem:didLoadThumbnail:)])
        {
            [delegate flickrItem:self didLoadThumbnail:self.thumbnail];
        }
    }
    else
    {
        self.image = remoteImage;
        if ([delegate respondsToSelector:@selector(flickrItem:didLoadImage:)])
        {
            [delegate flickrItem:self didLoadImage:self.image];
        }
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
