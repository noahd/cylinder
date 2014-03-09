/*
Copyright (C) 2014 Reed Weichler

This file is part of Cylinder.

Cylinder is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Cylinder is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Cylinder.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "UIView+Cylinder.h"
#import <objc/objc.h>

@interface CLTransformView : UIView

- (instancetype)initByReplacingView:(UIView *)viewToReplace;

/// Only do this once! Returns original view, sets \c usurpedView property to nil
- (UIView *)detransformify;

@property (strong, nonatomic) UIView *usurpedView;

@end

@implementation CLTransformView

+ (Class)layerClass
{
    return [CATransformLayer class];
}

+ (void)replaceView:(UIView *)old withView:(UIView *)new
{
    UIView *superview = old.superview;
    [old removeFromSuperview];
    
    new.bounds = old.bounds;
    new.transform = old.transform;
    new.alpha = old.alpha;
    new.isOnScreen = old.isOnScreen;
    new.hasDifferentSubviews = old.hasDifferentSubviews;
    
    CALayer *oldLayer = old.layer;
    CALayer *newLayer = new.layer;
    
    // HACK: since we can't store the saved position directly, simulate it
    // Who am I kidding? All of this code is a hack anyway :P
    if (oldLayer.hasSavedPosition)
    {
        newLayer.position = oldLayer.savedPosition;
        [newLayer savePosition];
    }
    
    newLayer.position = oldLayer.position;
    newLayer.transform = oldLayer.transform;
    
    // TODO: Apply more properties: alpha, background color, etc.; not necessary atm
    
    for (UIView *subview in old.subviews)
    {
        [subview removeFromSuperview];
        
        // HACK to prevent wiggle mode from inadvertently triggering on icons when scrolling
        // This is necessary because the icon views don't automatically receive the touchesEnded/touchesCancelled message when they're stripped from their superview
        // Somewhat confusing that this doesn't happen automatically. Is this an oversight on Apple's part?
        [subview touchesCancelled: [NSSet set] withEvent: nil];
        
        [new addSubview: subview];
    }
    
    [superview addSubview: new];
}

- (instancetype)initByReplacingView:(UIView *)viewToReplace
{
    if ((self = [super initWithFrame: viewToReplace.frame]))
    {
        if (!viewToReplace) {
            NSLog(@"%s: viewToReplace is nil! We should probably throw an exception here…", __func__);
            [super dealloc];
            return nil; 
        }
        
        NSLog(@"Transformifying %@ -> %@", viewToReplace, self);
        
        self.usurpedView = viewToReplace;
        
        [super.class replaceView: viewToReplace withView: self];
    }
    
    return self;
}

// Category overrides

- (BOOL)isTransformView
{
    return YES;
}

- (UIView *)transformify
{
    return self;
}

- (UIView *)detransformify
{
    UIView *orig = self.usurpedView;
    NSLog(@"Detransformifying %@ -> %@", self, orig);
    [super.class replaceView: self withView: orig];
    self.usurpedView = nil;
    return orig;
}

// Proxying hacks

- (BOOL)isKindOfClass:(Class)cls
{
    return [super isKindOfClass: cls] || [self.usurpedView isKindOfClass: cls];
}

- (Class)class
{
    return self.usurpedView.class ?: super.class;
}

- (void)dealloc
{
    NSLog(@"Deallocating transform view %@", self);
    [_usurpedView release];
    [super dealloc];
}

@end

@implementation UIView(Cylinder)
-(BOOL)isOnScreen
{
    NSNumber *num = objc_getAssociatedObject(self, @selector(isOnScreen));
    return num && num.boolValue;
}

-(void)setIsOnScreen:(BOOL)isOnScreen
{
    NSNumber *num = (isOnScreen ? [NSNumber numberWithBool:true] : nil);
    objc_setAssociatedObject(self, @selector(isOnScreen), num, OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)hasDifferentSubviews
{
    NSNumber *count = objc_getAssociatedObject(self, @selector(hasDifferentSubviews));

    BOOL different = self.subviews.count != count.intValue;

    if(different)
    {
        count = [NSNumber numberWithInt:self.subviews.count];
        objc_setAssociatedObject(self, @selector(hasDifferentSubviews), count, OBJC_ASSOCIATION_RETAIN);
    }

    return different;
}

-(void)setHasDifferentSubviews:(BOOL)different
{
    NSNumber *count = different ? nil : [NSNumber numberWithInt:self.subviews.count];
    objc_setAssociatedObject(self, @selector(hasDifferentSubviews), count, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isTransformView
{
    return NO;
}

- (UIView *)transformify
{
    return [[[CLTransformView alloc] initByReplacingView: self] autorelease];
}

- (UIView *)detransformify
{
    return self;
}

@end
