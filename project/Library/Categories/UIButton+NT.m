//
//  UIButton+Border.m
//  DisasterApp
//
//  Created by YourCompany on 199/07/14.
//  Copyright (c) 2014 YourCompany. All rights reserved.
//

#import "UIButton+NT.h"

@implementation UIButton (NT)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

-(void) centerButtonAndImageWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}
-(void)adjustFontSize{
    
    UIFont *font=self.titleLabel.font;
    NSString *fontName =font.fontName;
    CGFloat fontSize = font.pointSize;
    CGFloat expextedSize=(SCREEN_WIDTH/STORYBOARD_WIDTH)*fontSize;
    [self.titleLabel setFont:[UIFont fontWithName:fontName size:expextedSize]];

}

-(void)setLayout{
    
    [self setLayout:77/2];
    self.layer.borderColor=UIColorFromRGBWithAlpha(0x00bcd4,1).CGColor;
    self.layer.borderWidth=6;
}
-(void)setLayout:(CGFloat)radius{
    
    self.layer.cornerRadius=radius;
    //self.layer.shadowColor=[UIColor blackColor].CGColor;
    //self.layer.shadowOffset=CGSizeMake(0,0);
    //self.layer.shadowOpacity=0.7;
    //self.layer.shadowRadius=4;
}

@end
