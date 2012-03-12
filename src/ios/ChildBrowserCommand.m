//
//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright (c) 2011, IBM Corporation
//  Copyright 2011, Randy McMillan
//  Copyright 2012, Andrew Lunny, Adobe Systems
//

#import "ChildBrowserCommand.h"

#ifdef CORDOVA_FRAMEWORK
	#import <Cordova/CDVViewController.h>
#else
	#import "CDVViewController.h"
#endif


@implementation ChildBrowserCommand

@synthesize callbackId, childBrowser, CLOSE_EVENT, LOCATION_CHANGE_EVENT, OPEN_EXTERNAL_EVENT;

- (id) initWithWebView:(UIWebView*)theWebView
{
    self = [super initWithWebView:theWebView];

    CLOSE_EVENT = [NSNumber numberWithInt:0];
    LOCATION_CHANGE_EVENT = [NSNumber numberWithInt:1];
    OPEN_EXTERNAL_EVENT = [NSNumber numberWithInt:2];

    return self;
}

- (void) showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{	
    self.callbackId = [arguments objectAtIndex:0];
	
    if(childBrowser == NULL)
	{
		childBrowser = [[ ChildBrowserViewController alloc ] initWithScale:FALSE ];
		childBrowser.delegate = self;
	}
    
    //Show location bar
//    if([options objectForKey:@"showLocationBar"]!=nil)
//        [childBrowser showLocationBar:[[options objectForKey:@"showLocationBar"] boolValue]];
    NSLog(@"showLocationBar %d",(int)[[options objectForKey:@"showLocationBar"] boolValue]);
/* // TODO: Work in progress
	NSString* strOrientations = [ options objectForKey:@"supportedOrientations"];
	NSArray* supportedOrientations = [strOrientations componentsSeparatedByString:@","];
*/
    CDVViewController* cont = (CDVViewController*)[ super appViewController ];
    childBrowser.supportedOrientations = cont.supportedOrientations;
    
    if ([cont respondsToSelector:@selector(presentViewController)]) {
        //Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan
        [cont presentViewController:childBrowser animated:YES completion:nil];        
    } else {
        [ cont presentModalViewController:childBrowser animated:YES ];
    }                 
        
    // object 1 is the callback id
    NSString *url = (NSString*) [arguments objectAtIndex:1];
    
    //NSLog(@"showWebPage showLocationBar %@", [options objectForKey:@"showLocationBar"]);    
    [childBrowser resetControls];
    [childBrowser loadURL:url  ];
    if([options objectForKey:@"showAddress"]!=nil)
        [childBrowser showAddress:[[options objectForKey:@"showAddress"] boolValue]];
    if([options objectForKey:@"showLocationBar"]!=nil)
        [childBrowser showLocationBar:[[options objectForKey:@"showLocationBar"] boolValue]];
    if([options objectForKey:@"showNavigationBar"]!=nil)
        [childBrowser showNavigationBar:[[options objectForKey:@"showNavigationBar"] boolValue]];
}

-(void) close:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{
    [ childBrowser closeBrowser];
	
}

-(void) onClose
{
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                      messageAsDictionary:[self dictionaryForEvent:CLOSE_EVENT]];
    [result setKeepCallbackAsBool:YES];

    [self writeJavascript: [result toSuccessCallbackString:self.callbackId]];
}

-(void) onOpenInSafari
{
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                      messageAsDictionary:[self dictionaryForEvent:OPEN_EXTERNAL_EVENT]];
    [result setKeepCallbackAsBool:YES];

    [self writeJavascript: [result toSuccessCallbackString:self.callbackId]];
}


-(void) onChildLocationChange:(NSString*)newLoc
{
	NSString* tempLoc = [NSString stringWithFormat:@"%@",newLoc];
	NSString* encUrl = [tempLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryForEvent:LOCATION_CHANGE_EVENT]];

    [dict setObject:encUrl forKey:@"location"];

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                      messageAsDictionary:dict];
    [result setKeepCallbackAsBool:YES];

    [self writeJavascript: [result toSuccessCallbackString:self.callbackId]];
}

-(NSDictionary*) dictionaryForEvent:(NSNumber*) event
{
    return [NSDictionary dictionaryWithObject:event forKey:@"type"];
}

@end
