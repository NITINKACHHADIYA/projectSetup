//
//  NSMutableArray+NT.m
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import "NSMutableArray+NT.h"

@implementation NSMutableArray (NT)
-(NSString*)json{
    
    NSString* json = nil;
    NSError* error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return (error ? nil : json);
}

@end
