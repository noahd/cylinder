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

#import <QuartzCore/QuartzCore.h>
#import <lua/lua.h>
#import <UIKit/UIKit.h>
#import "CALayer+Cylinder.h"

void close_lua();
BOOL init_lua(NSArray *scripts, BOOL random);
CATransform3D *default_transform();
BOOL manipulate(UIView *view, float offset, u_int32_t rand);
