//
//  NSDate+NT.m
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import "NSDate+NT.h"

@implementation NSDate(NT)

-(NSString *)StringFromDateFormat:(NSString *)Format{
    
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    formater.dateFormat=Format;
    
    if ([formater stringFromDate:self] == nil) {
        
        return @"";
    }
    
    return [formater stringFromDate:self];
}

@end
