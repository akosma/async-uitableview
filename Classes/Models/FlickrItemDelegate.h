//
//  FlickrItemDelegate.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class FlickrItem;

@protocol FlickrItemDelegate

@required
- (void)newsItem:(FlickrItem *)item didLoadImage:(UIImage *)image;

@end
