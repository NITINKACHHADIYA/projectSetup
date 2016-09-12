//
//  UITextField+NT.h
//  POS
//
//  Created by test on 22/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextField(NT)

-(void)adjustFontSize;
-(void)spacingTextFieldRect:(CGFloat)f;

-(void)setLayout;
-(void)setLayout:(CGFloat)radius;

@end
