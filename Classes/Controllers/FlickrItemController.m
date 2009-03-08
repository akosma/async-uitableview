//
//  FlickrItemController.m
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlickrItemController.h"
#import "FlickrItem.h"

@implementation FlickrItemController

@synthesize item;

#pragma mark -
#pragma mark Constructor and destructor

- (id)init
{
    if (self = [super initWithNibName:@"FlickrItem" bundle:nil]) 
    {
    }
    return self;
}

- (void)dealloc 
{
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
            
            // The getter in the FlickrItem class is overloaded...!
            // If the image is not yet downloaded, it returns nil and 
            // begins the asynchronous downloading of the image.
            UIImage *image = item.image;
            if (image == nil)
            {
                [scrollingWheel startAnimating];
            }
            photoView.image = image;            
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
    [scrollingWheel stopAnimating];
}

- (void)flickrItem:(FlickrItem *)item couldNotLoadImageError:(NSError *)error
{
    [scrollingWheel stopAnimating];
}

#pragma mark -
#pragma mark UIViewController overridden methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

@end
