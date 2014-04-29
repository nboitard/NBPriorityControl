// NBPriorityControl.h
// 
// Copyright (c) 2014 Nicolas Boitard
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Cocoa/Cocoa.h>

typedef enum : NSInteger {
    LowPriority = 0,
    NormalPriority = 1,
    HighPriority = 2
} Priority;

typedef enum {
    NBPriorityControlVertical,
    NBPriorityControlHorizontal
} NBPriorityControlOrientation;


@interface NBPriorityControl : NSControl

/**
    Contains the current priority. Value could be LowPriority, NormalPriority or HighPriority. Defaults to Normal.
 */
@property (nonatomic,assign) Priority value;


-(void) setValue:(Priority)value animated:(BOOL)animated;

/**
    Specifies the background color
 */
@property (nonatomic,strong) NSColor *backgroundColor;


/**
    Specifies the icon for selected priority
 */
@property (nonatomic,strong) NSImage *icon;

/**
    Specifies the orientation of the control (horizontal or vertical). Defaults to vertical
 */
@property (nonatomic,assign) NBPriorityControlOrientation orientation;

/**
    Specifies if non-selected levels shrink when cursor is not in the control rect. Defaults to YES
 */
@property (nonatomic,assign) BOOL allowsShrinking;

/**
    Contains the selector sent to the target when value changes
 */
@property (nonatomic,assign) SEL action;


@end
