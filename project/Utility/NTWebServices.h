//
//  NTWebServices.h
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTWebServices : NSObject

+(NSString *)APIMainLink;
+(NSString *)APIImageLink;
+(NSString *)API:(NSString *)APIs;

+(NSString *)encrypt:(NSString *)text;
+(NSString *)decrypt:(NSString *)text;

@end

#define kEncriptionKey @"POS-(Encription)-Key"

