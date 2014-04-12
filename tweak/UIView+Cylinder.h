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

#import <UIKit/UIKit.h>

@interface UIView(Cylinder)
@property (nonatomic, assign) BOOL isOnScreen;
@property (nonatomic, assign) BOOL hasDifferentSubviews;

/// Returns whether the receiver is a transform view; see \c -transformify.
@property (nonatomic, readonly) BOOL isTransformView;

/// Replaces the receiver with a CATransformLayer-backed view — and returns said view — by taking all of its subviews and taking its position in its superview.
/// Does nothing when the receiver is already a transform view.
- (UIView *)transformify;

/// Reverses all actions done in \c -transformify and returns the original receiver.
- (UIView *)detransformify;

/// Returns the furthest ancestor of the receiver that isn't a window (duh).
/// If the receiver doesn't have a superview, returns itself.
- (UIView *)furthestNonWindowAncestor;

@end
