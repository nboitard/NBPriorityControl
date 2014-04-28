//
//  NBAppDelegate.m
//  NBPriorityControl
//
//  Created by Nicolas Boitard on 22/04/2014.
//  Copyright (c) 2014 boitard. All rights reserved.
//

#import "NBAppDelegate.h"
#import "NBPriorityControl.h"

static NSString *const lowPriority = @"Low Priority";
static NSString *const normalPriority = @"Normal Priority";
static NSString *const highPriority = @"High Priority";

@implementation NBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //_priorityControl.orientation = NBPriorityControlHorizontal;
    //_priorityControl.backgroundColor = [NSColor redColor];
    _priorityControl.target = self;
    [_priorityControl setAction:@selector(changePriority:)];
    
    
}

-(void)applicationWillBecomeActive:(NSNotification *)notification {
    
    
    
}

-(void) handleChange {
    NSLog(@"test");
}

-(IBAction)changePriority:(id)sender {
    
    if(sender == _segmentedControl) {
        
        switch (_segmentedControl.selectedSegment) {
            case 0:
                [(_label.cell) setTitle:lowPriority];
                _priorityControl.value = LowPriority;
                break;
            case 1:
                [(_label.cell) setTitle:normalPriority];
                _priorityControl.value = NormalPriority;
                break;
            case 2:
                [(_label.cell) setTitle:highPriority];
                _priorityControl.value = HighPriority;
                break;
            default:
                NSAssert(NO, @"wrong segmentedControl tag..");
                break;
        }
        
    } else if(sender == _priorityControl) {
        
        switch (_priorityControl.value) {
            case HighPriority:
                [(_label.cell) setTitle:highPriority];
                _segmentedControl.selectedSegment = 2;
                break;
            case NormalPriority:
                [(_label.cell) setTitle:normalPriority];
                _segmentedControl.selectedSegment = 1;
                break;
            case LowPriority:
                [(_label.cell) setTitle:lowPriority];
                _segmentedControl.selectedSegment = 0;
                break;
            default:
                NSAssert(NO, @"wrong segmentedControl tag..");
                break;
        }
    }
    
}

@end
