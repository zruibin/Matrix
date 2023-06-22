//
//  main.m
//  Matrix
//
//  Created by ruibin.chow on 2023/6/22.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [NSApplication sharedApplication].delegate = delegate;
        [NSApp run];
    }

//    return NSApplicationMain(argc, argv);
}
