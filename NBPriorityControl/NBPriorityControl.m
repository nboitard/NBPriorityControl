// NBPriorityControl.m
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

#import "NBPriorityControl.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat layerShrinkRatio = 0.25;

@implementation NBPriorityControl {
    
    CGFloat layerWidth,layerHeight;
    
    CALayer *highLayer;
    CALayer *midLayer;
    CALayer *lowLayer;
    
    NSImageView *imageView;
    
}

-(instancetype) initWithFrame:(NSRect)frameRect {
    
    self = [super initWithFrame:frameRect];
    
    if(self) {
        
        [self setWantsLayer:YES];
    
        _backgroundColor = [NSColor colorWithRed:0.20 green:0.596 blue:0.86 alpha:1.0];
        _icon = [NSImage imageNamed:@"ToDo"];
        _orientation = NBPriorityControlVertical;
        _allowsShrinking = YES;
        
        if(_orientation == NBPriorityControlVertical) {
            layerWidth = frameRect.size.width;
            layerHeight = frameRect.size.height/3;
        } else {
            layerWidth = frameRect.size.width/3;
            layerHeight = frameRect.size.height;
        }
        
        _value = NormalPriority;
        
        [self initLayers];
        
        CGRect imageRect = (_orientation==NBPriorityControlVertical)?CGRectMake(0, _value*layerHeight, layerWidth, layerHeight):CGRectMake(_value*layerWidth, 0, layerWidth, layerHeight);
        imageView = [[NSImageView alloc] initWithFrame:imageRect];
        imageView.image = _icon;
        [self addSubview:imageView];
        
        [self setNeedsDisplay];
        
        [self addTrackingArea:[[NSTrackingArea alloc]initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInActiveApp owner:self userInfo:nil]];
        
        
    }
    
    return self;
}

-(void) initLayers {
    
    highLayer = [CALayer layer];
    highLayer.backgroundColor = _backgroundColor.CGColor;
    if(_orientation==NBPriorityControlVertical) {
        highLayer.frame = CGRectMake(0, 2*layerHeight, layerWidth, layerHeight);
    } else {
        highLayer.frame = CGRectMake(2*layerWidth, 0, layerWidth, layerHeight);
    }
    
    [self.layer addSublayer:highLayer];
    
    midLayer = [CALayer layer];
    NSColor *midColor = [NSColor colorWithRed:_backgroundColor.redComponent green:_backgroundColor.greenComponent blue:_backgroundColor.blueComponent alpha:0.66];
    midLayer.backgroundColor = midColor.CGColor;
    if(_orientation==NBPriorityControlVertical) {
        midLayer.frame = CGRectMake(0, layerHeight, layerWidth, layerHeight);
    } else {
        midLayer.frame = CGRectMake(layerWidth, 0, layerWidth, layerHeight);
    }
    
    [self.layer addSublayer:midLayer];
    
    NSColor *lowColor = [NSColor colorWithRed:_backgroundColor.redComponent green:_backgroundColor.greenComponent blue:_backgroundColor.blueComponent alpha:0.33];
    lowLayer = [CALayer layer];
    lowLayer.backgroundColor = lowColor.CGColor;
    lowLayer.frame = CGRectMake(0, 0, layerWidth, layerHeight);
    
    [self.layer addSublayer:lowLayer];
    
    if(_allowsShrinking) {
        [self shrinkLayers];
    }
    
}

-(void)updateLayers {
    
    highLayer.backgroundColor = _backgroundColor.CGColor;
    if(_orientation==NBPriorityControlVertical) {
        highLayer.frame = CGRectMake(0, 2*layerHeight, layerWidth, layerHeight);
    } else {
        highLayer.frame = CGRectMake(2*layerWidth, 0, layerWidth, layerHeight);
    }
    [highLayer setNeedsDisplay];
    
    NSColor *midColor = [NSColor colorWithRed:_backgroundColor.redComponent green:_backgroundColor.greenComponent blue:_backgroundColor.blueComponent alpha:0.66];
    midLayer.backgroundColor = midColor.CGColor;
    if(_orientation==NBPriorityControlVertical) {
        midLayer.frame = CGRectMake(0, layerHeight, layerWidth, layerHeight);
    } else {
        midLayer.frame = CGRectMake(layerWidth, 0, layerWidth, layerHeight);
    }
    [midLayer setNeedsDisplay];
    
    NSColor *lowColor = [NSColor colorWithRed:_backgroundColor.redComponent green:_backgroundColor.greenComponent blue:_backgroundColor.blueComponent alpha:0.33];
    lowLayer.backgroundColor = lowColor.CGColor;
    lowLayer.frame = CGRectMake(0, 0, layerWidth, layerHeight);
    [lowLayer setNeedsDisplay];
    
    if(_allowsShrinking) {
        [self shrinkLayers];
    }
    
    [self setNeedsLayout:YES];
}

// expand non-selected layers when mouse hover
-(void)expandLayers {
    
    CALayer *layer1, *layer2;
    
    if(_value==LowPriority) {
        layer1 = midLayer;
        layer2 = highLayer;
    } else if(_value==NormalPriority) {
        layer1 = lowLayer;
        layer2 = highLayer;
    } else {
        layer1 = lowLayer;
        layer2 = midLayer;
    }
    
    if(_orientation==NBPriorityControlVertical) {
        layer1.frame = CGRectMake(layer1.frame.origin.x, layer1.frame.origin.y,layerWidth,layerHeight);
        layer2.frame = CGRectMake(layer2.frame.origin.x, layer2.frame.origin.y,layerWidth,layerHeight);
    } else {
        layer1.frame = CGRectMake(layer1.frame.origin.x, layer1.frame.origin.y,layerWidth,layerHeight);
        layer2.frame = CGRectMake(layer2.frame.origin.x, layer2.frame.origin.y,layerWidth,layerHeight);
    }
    
}

// shrink non-selected layers when mouse exits the control
-(void)shrinkLayers {
    
    CALayer *layer1, *layer2;
    
    if(_value==LowPriority) {
        layer1 = midLayer;
        layer2 = highLayer;
    } else if(_value==NormalPriority) {
        layer1 = lowLayer;
        layer2 = highLayer;
    } else {
        layer1 = lowLayer;
        layer2 = midLayer;
    }
    
    if(_orientation==NBPriorityControlVertical) {
        layer1.frame = CGRectMake(layer1.frame.origin.x, layer1.frame.origin.y,layerWidth*layerShrinkRatio,layerHeight);
        layer2.frame = CGRectMake(layer2.frame.origin.x, layer2.frame.origin.y,layerWidth*layerShrinkRatio,layerHeight);
    } else {
        layer1.frame = CGRectMake(layer1.frame.origin.x, layer1.frame.origin.y,layerWidth,layerHeight*layerShrinkRatio);
        layer2.frame = CGRectMake(layer2.frame.origin.x, layer2.frame.origin.y,layerWidth,layerHeight*layerShrinkRatio);
    }
    
}

-(void)updateIcon {
    
    imageView.image = _icon;
    if(_orientation==NBPriorityControlVertical) {
        imageView.frame = CGRectMake(0, _value*layerHeight, layerWidth, layerHeight);
    } else {
        imageView.frame = CGRectMake(_value*layerWidth, 0, layerWidth, layerHeight);
    }
}

-(void)setValue:(Priority)value animated:(BOOL)animated {
    
    if(_value != value) {
        [self willChangeValueForKey:@"value"];
        _value = value;
        CGRect newFrame;
        if(_orientation==NBPriorityControlVertical) {
            newFrame = CGRectMake(0, _value*layerHeight, layerWidth, layerHeight);
        } else {
            newFrame = CGRectMake(_value*layerWidth, 0, layerWidth, layerHeight);
        }
        if (!animated) {
            imageView.frame = newFrame;
        } else {
            [[imageView animator] setFrame:newFrame];
        }
        
        _value = value;
        
        [self didChangeValueForKey:@"value"];
    }
    
}

-(void)setValue:(Priority)value {
    
    [self setValue:value animated:NO];
    
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    
    if([key isEqualToString:@"value"]) {
        return NO;
    } else {
        return [super automaticallyNotifiesObserversForKey:key];
    }
    
}

-(void)mouseEntered:(NSEvent *)theEvent {
    
    if(_allowsShrinking) {
        [self expandLayers];
    }
}

-(void)mouseExited:(NSEvent *)theEvent {
    
    if(_allowsShrinking) {
        [self shrinkLayers];
    }
    
}

-(void)mouseDown:(NSEvent *)theEvent {
    
}

-(void)mouseDragged:(NSEvent *)theEvent {
    
}

-(void)mouseUp:(NSEvent *)theEvent {
    
    CGPoint location = [theEvent locationInWindow];
    CGPoint touchPoint = [self convertPoint:location fromView:nil];
    
    if(CGRectContainsPoint(highLayer.frame, touchPoint)) {
        
        [self setValue:HighPriority animated:YES];
        
    } else if(CGRectContainsPoint(midLayer.frame, touchPoint)) {
        
        [self setValue:NormalPriority animated:YES];
        
    } else if(CGRectContainsPoint(lowLayer.frame, touchPoint)) {
        
        [self setValue:LowPriority animated:YES];
        
    }
    
    [self sendAction:self.action to:self.target];
    
}

-(void)setIcon:(NSImage *)icon {
    if(_icon!=icon) {
        _icon = icon;
        [self updateIcon];
    }
}

-(void)setBackgroundColor:(NSColor *)backgroundColor {
    if(_backgroundColor!=backgroundColor) {
        _backgroundColor = backgroundColor;
        [self updateLayers];
    }
    
}

-(void)setOrientation:(NBPriorityControlOrientation)orientation {
    if(_orientation != orientation) {
        _orientation = orientation;
        
        if(_orientation == NBPriorityControlVertical) {
            layerWidth = self.frame.size.width;
            layerHeight = self.frame.size.height/3;
        } else {
            layerWidth = self.frame.size.width/3;
            layerHeight = self.frame.size.height;
        }
        
        //[self.layer setNeedsDisplay];
        //self.layer.frame = self.bounds;
        
        NSLog(@"self.bounds = %@\nself.layer.bounds = %@\nself.frame = %@\nself.layer.frame=%@\nlowLayer.bounds = %@\nlowLayer.frame = %@",NSStringFromRect(self.bounds),NSStringFromRect(self.layer.bounds),NSStringFromRect(self.frame),NSStringFromRect(self.layer.frame),NSStringFromRect(lowLayer.bounds),NSStringFromRect(lowLayer.frame));
        
        
        
        for(NSTrackingArea *area in self.trackingAreas) {
            [self removeTrackingArea:area];
        }
        [self addTrackingArea:[[NSTrackingArea alloc]initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInActiveApp owner:self userInfo:nil]];
        [self updateLayers];
        [self updateIcon];
        [self setNeedsDisplay];
    }
}





@end
