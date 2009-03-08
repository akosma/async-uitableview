//
//  FlickrItem.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrItemDelegate.h"

@interface FlickrItem : NSObject 
{
@private
    NSString *title;
    NSString *link;
    NSString *summary;
    NSString *date;
    NSString *imageURL;
    UIImage *image;

    // Why NSObject instead of "id"? Because this way
    // we can ask if it "respondsToSelector:" before invoking
    // any delegate method...
    NSObject<FlickrItemDelegate> *delegate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) NSObject<FlickrItemDelegate> *delegate;

@end
