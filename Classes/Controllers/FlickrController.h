//
//  FlickrController.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDelegate.h"
#import "FlickrCellDelegate.h"

@class RSS;

@interface FlickrController : UITableViewController <RSSDelegate, FlickrCellDelegate>
{
@private
    RSS *rss;
    NSArray *flickrItems;
    UINavigationController *navigationController;
}

@property (nonatomic, readonly) UINavigationController *navigationController;

- (void)reloadFeed;

@end
