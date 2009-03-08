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

@implementation FlickrItem

@synthesize title;
@synthesize link;
@synthesize summary;
@synthesize date;
@synthesize imageURL;
@synthesize image;
@synthesize delegate;

- (void)dealloc
{
    [image release];
    [imageURL release];
    [title release];
    [link release];
    [summary release];
    [date release];
    [super dealloc];
}

- (UIImage *)image
{
    if (image == nil)
    {
        NSURL *url = [NSURL URLWithString:self.imageURL];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        NSOperationQueue *queue = [AsyncTableAppDelegate sharedAppDelegate].downloadQueue;
        [queue addOperation:request];
        [request release];
    }
    return image;
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    UIImage *remoteImage = [[UIImage alloc] initWithData:data];
    self.image = remoteImage;
    [remoteImage release];

    if ([delegate respondsToSelector:@selector(newsItem:didLoadImage:)])
    {
        [delegate newsItem:self didLoadImage:self.image];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    // NSError *error = [request error];
    // and then do something...
}

@end
