//
//  RSS.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDelegate.h"

@interface RSS : NSObject 
{
@private
    NSMutableArray *newsItems;
    NSObject<RSSDelegate> *delegate;
    NSURL *url;
    NSXMLParser *xmlParser;

    NSString *currentElement;
    NSMutableString *currentTitle;
    NSMutableString *currentDate;
    NSMutableString *currentSummary;
    NSMutableString *currentLink;
    NSMutableString *currentImage;
}

@property (nonatomic, assign) NSObject<RSSDelegate> *delegate;
@property (nonatomic, retain) NSMutableArray *newsItems;
@property (nonatomic, retain) NSURL *url;

- (void)fetch;

@end
