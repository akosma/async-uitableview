//
//  FlickrCell.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrItemDelegate.h"

@class FlickrItem;

@interface FlickrCell : UITableViewCell <FlickrItemDelegate>
{
@private
    UILabel *textLabel;
    FlickrItem *item;
    UIImageView *photo;
    UIActivityIndicatorView *scrollingWheel;
}

@property (nonatomic, retain) FlickrItem *item;

- (void)loadImage;
- (void)toggleImage;

@end
