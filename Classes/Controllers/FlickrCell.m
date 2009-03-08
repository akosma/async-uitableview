//
//  FlickrCell.m
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlickrCell.h"
#import "FlickrItem.h"

@implementation FlickrCell

@synthesize item;

#pragma mark -
#pragma mark Constructor and destructor

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
    {
        self.backgroundColor = [UIColor blackColor];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 5.0, 290.0, 70.0)];
        textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        textLabel.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:textLabel];
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 75.0)];
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.clipsToBounds = YES;
        [self.contentView addSubview:photo];
        
        scrollingWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0, 27.0, 20.0, 20.0)];
        scrollingWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        scrollingWheel.hidesWhenStopped = YES;
        [scrollingWheel stopAnimating];
        [self.contentView addSubview:scrollingWheel];
        
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)dealloc 
{
    [photo release];
    [textLabel release];
    item.delegate = nil;
    [item release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (void)setItem:(FlickrItem *)newItem
{
    if (newItem != item)
    {
        item.delegate = nil;
        [item release];
        item = nil;
        
        item = [newItem retain];
        [item setDelegate:self];
        
        if (item != nil)
        {
            textLabel.text = item.title;
            photo.image = item.image;
        }
    }
}

- (void)toggleImage
{
    UIImage *akosma = [UIImage imageNamed:@"akosma.png"];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:photo cache:YES];
    [UIView setAnimationDelegate:self];
    
    if (photo.image != item.image)
    {
        photo.image = item.image;
        photo.contentMode = UIViewContentModeScaleAspectFill;
    }
    else
    {
        photo.image = akosma;
        photo.contentMode = UIViewContentModeScaleToFill;
    }
    
    [UIView commitAnimations];
}

- (void)loadImage
{
    // The getter in the FlickrItem class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    UIImage *image = item.image;
    if (image == nil)
    {
        [scrollingWheel startAnimating];
    }
    photo.image = image;
}

#pragma mark -
#pragma mark FlickrItemDelegate methods

- (void)flickrItem:(FlickrItem *)item didLoadImage:(UIImage *)image
{
    photo.image = image;
    [scrollingWheel stopAnimating];
}

- (void)flickrItem:(FlickrItem *)item couldNotLoadImageError:(NSError *)error
{
    // Here we could show a "default" or "placeholder" image...
    [scrollingWheel stopAnimating];
}

@end
