//
//  UIButton+Border.h
//  DisasterApp
//
//  Created by YourCompany on 199/07/14.
//  Copyright (c) 2014 YourCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (NT)

- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

-(void)centerButtonAndImageWithSpacing:(CGFloat)spacing;

-(void)adjustFontSize;

-(void)setLayout;
-(void)setLayout:(CGFloat)radius;

@end
