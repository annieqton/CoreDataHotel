//
//  AutoLayout.m
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/24/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "AutoLayout.h"

@implementation AutoLayout

+(NSArray *)fullScreenConstraintswithVFLForView:(UIView *)view{  //use NSArray because it keeps the constraints from being mutable until we meant to
    
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    
    NSDictionary *viewDictionary = @{@"view": view};  //view comes from line 13
    
    
//    NSNumber *padding = @100;
//    NSNumber *paddingMultiplier = @5.0;
//    NSDictionary *metricsDictionary = @{@"padding": padding, @"multiplier": paddingMultipler};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"  //H:|-[view]-|" means default 8 points to the left and right
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewDictionary];

    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewDictionary];

    [constraints addObjectsFromArray:horizontalConstraints];
    [constraints addObjectsFromArray:verticalConstraints];
    
    [NSLayoutConstraint activateConstraints:constraints];  //NSLayout won't work if you don't active them
    
    return constraints.copy;  //use a copy here to make sure that what's being return is immutable array NSArray type
}


//generic with muplitier
+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute
                               andMultiplier:(CGFloat)multiplier{
  
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute: attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superView attribute:attribute
                                                                 multiplier:multiplier constant:0.0];
    
    constraint.active = YES;  //active assigns the constraint to active otherwise the constraints won't be applied to layout
    
    return constraint;
   
}


//generic
+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute{
    
    return [AutoLayout genericConstraintFrom:view toView:superView withAttribute:attribute andMultiplier:1.0];
    
}

//top contraints that takes in value for navigation bar
+(NSLayoutConstraint *)distanceFromView:(UIView *)view
                                 toView:(UIView *)otherView
                          withAttribute:(NSLayoutAttribute)attribute
                               constant:(CGFloat) constant{
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:otherView attribute:attribute multiplier:1.0 constant:constant];
    
    constraint.active = YES;
    return constraint;
}



//height
+(NSLayoutConstraint *)equalHeightConstraintFromView:(UIView *)view
                                              toView:(UIView *)otherView
                                      withMultiplier:(CGFloat)multiplier{
    
    NSLayoutConstraint *heightConstraint = [AutoLayout genericConstraintFrom:view
                                                                      toView:otherView
                                                               withAttribute:NSLayoutAttributeHeight
                                                               andMultiplier:multiplier];
    
    return heightConstraint;
}

//width
+(NSLayoutConstraint *)equalWidthtConstraintFromView:(UIView *)view
                                              toView:(UIView *)otherView
                                      withMultiplier:(CGFloat)multiplier{
    
    NSLayoutConstraint *widthConstraint = [AutoLayout genericConstraintFrom:view
                                                                      toView:otherView
                                                               withAttribute:NSLayoutAttributeWidth
                                                               andMultiplier:multiplier];
    
    return widthConstraint;
}


//leading
+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView{
    
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeLeading];
}


//trailing
+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView{
    
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeTrailing];
}



@end





