//
//  FlickrCellDelegate.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrCell;

@protocol FlickrCellDelegate

@required
- (void)flickrCellAnimationFinished:(FlickrCell *)cell;

@end
