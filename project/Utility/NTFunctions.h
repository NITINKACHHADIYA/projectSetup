//
//  NTFunctions.h
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTFunctions : NSObject

+(NSString *)checkNull:(NSString *)str1;

+(void)AlertViewWithTitle:(NSString *)Title subTitle:(NSString *)subTitle actions:(NSArray *)actions;

+(void)somethingWentWrong;
+(void)applicationUnderMantainance;
+(void)Timeout;
+(void)internetConnectionError;

+(void)showLoading;
+(void)hideLoading;


@end