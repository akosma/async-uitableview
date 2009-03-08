//
//  AsyncTableAppDelegate.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrController;

@interface AsyncTableAppDelegate : NSObject <UIApplicationDelegate> 
{
@private
    IBOutlet UIWindow *window;
    FlickrController *controller;
    NSOperationQueue *downloadQueue;
    UIView *loadingView;
}

@property (nonatomic, retain) NSOperationQueue *downloadQueue;

+ (AsyncTableAppDelegate *)sharedAppDelegate;

- (void)showLoadingView;
- (void)hideLoadingView;

@end

