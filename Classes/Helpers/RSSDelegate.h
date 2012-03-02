//
//  RSSDelegate.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2008 akosma software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSS;

@protocol RSSDelegate

@required
- (void)feed:(RSS *)feed didFindItems:(NSArray *)items;
- (void)feed:(RSS *)feed didFailWithError:(NSString *)errorMsg;

@end
