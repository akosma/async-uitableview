//
//  FlickrItemDelegate.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 akosma software. All rights reserved.
//

@class FlickrItem;

@protocol FlickrItemDelegate <NSObject>

@required
- (void)flickrItem:(FlickrItem *)item couldNotLoadImageError:(NSError *)error;

@optional
- (void)flickrItem:(FlickrItem *)item didLoadImage:(UIImage *)image;
- (void)flickrItem:(FlickrItem *)item didLoadThumbnail:(UIImage *)image;

@end
