//
//  AppDelegate.m
//  Matrix
//
//  Created by ruibin.chow on 2023/6/22.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MGLRenderView.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSRect frame = CGRectMake(0, 0, 720, 480);
    NSUInteger style =  NSTitledWindowMask | NSClosableWindowMask |NSMiniaturizableWindowMask | NSResizableWindowMask;
    NSWindow *window = [[NSWindow alloc]initWithContentRect:frame styleMask:style backing:NSBackingStoreBuffered defer:YES];
    window.title = @"Matrix";
    window.contentViewController = [[ViewController alloc] initWithFrame:frame];
//    window.contentView = [MGLRenderView new];
    //窗口显示
    [window makeKeyAndOrderFront:self];
    //窗口居中
    [window center];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
