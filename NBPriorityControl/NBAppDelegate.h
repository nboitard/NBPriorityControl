//
//  NBAppDelegate.h
//  NBPriorityControl
//
//  Created by Nicolas Boitard on 22/04/2014.
//  Copyright (c) 2014 boitard. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NBPriorityControl;

@interface NBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak) IBOutlet NBPriorityControl *priorityControl;

-(IBAction)changePriority:(id)sender;

@end
