//
//  RSS.h
//  AsyncTable
//
//  Created by Adrian on 3/8/09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RSS.h"
#import "FlickrItem.h"
#import "ASIHTTPRequest.h"
#import "AsyncTableAppDelegate.h"

@implementation RSS

@synthesize url;
@synthesize delegate;
@synthesize newsItems;

- (void)dealloc 
{
    [url release];
    [currentElement release];
    [currentTitle release];
    [currentDate release];
    [currentSummary release];
    [currentLink release];
    [currentImage release];
    [xmlParser release];
	[newsItems release];
    [super dealloc];
}

- (void)fetch
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [AsyncTableAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:request];
    [request release];
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    [newsItems release];
    newsItems = nil;
	newsItems = [[NSMutableArray alloc] init];
    
	xmlParser = [[NSXMLParser alloc] initWithData:data];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
	[xmlParser parse];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];

    if([delegate respondsToSelector:@selector(feed:didFailWithError:)])
    {
        [delegate feed:self didFailWithError:[error description]];
    }
}

#pragma mark NSXMLParserDelegate methods

// The following code is adapted from
// http://theappleblog.com/2008/08/04/tutorial-build-a-simple-rss-reader-for-iphone

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    if([delegate respondsToSelector:@selector(feed:didFailWithError:)])
    {
        NSString *errorMsg = [NSString stringWithFormat:@"Unable to download feed from web site (Error code %i )", [parseError code]];
        [delegate feed:self didFailWithError:errorMsg];
    }    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
                                        namespaceURI:(NSString *)namespaceURI 
                                       qualifiedName:(NSString *)qName 
                                          attributes:(NSDictionary *)attributeDict
{
	currentElement = [elementName copy];
    
	if ([currentElement isEqualToString:@"item"])
    {
        [currentTitle release];
        currentTitle = nil;
        [currentDate release];
        currentDate = nil;
        [currentSummary release];
        currentSummary = nil;
        [currentLink release];
        currentLink = nil;
        [currentImage release];
        currentImage = nil;
        
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
        currentImage = [[NSMutableString alloc] init];
	}
    else if ([currentElement isEqualToString:@"media:thumbnail"]) 
    {
		[currentImage appendString:[attributeDict objectForKey:@"url"]];
    }        
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
                                      namespaceURI:(NSString *)namespaceURI 
                                     qualifiedName:(NSString *)qName
{
    
	if ([elementName isEqualToString:@"item"]) 
    {
        FlickrItem *item = [[FlickrItem alloc] init];
        [currentTitle replaceOccurrencesOfString:@"\n" 
                                      withString:@"" 
                                         options:NSCaseInsensitiveSearch 
                                           range:NSMakeRange(0, [currentTitle length])];
        item.title = currentTitle;
        item.link = currentLink;
        item.summary = currentSummary;
        item.date = currentDate;
        item.imageURL = currentImage;
        
		[newsItems addObject:item];
        [item release];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"title"]) 
    {
		[currentTitle appendString:string];
	} 
    else if ([currentElement isEqualToString:@"link"]) 
    {
		[currentLink appendString:string];
	} 
    else if ([currentElement isEqualToString:@"description"]) 
    {
		[currentSummary appendString:string];
	} 
    else if ([currentElement isEqualToString:@"pubDate"]) 
    {
		[currentDate appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    if ([delegate respondsToSelector:@selector(feed:didFindItems:)])
    {
        [delegate feed:self didFindItems:newsItems];
    }
}

@end
