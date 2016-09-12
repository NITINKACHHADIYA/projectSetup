//
//  NTWebServices.m
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import "NTWebServices.h"
#import "FBEncryptorAES.h"

@implementation NTWebServices

+(NSString *)APIMainLink{
    
    return @"";
}
+(NSString *)APIImageLink{
    
    return @"";
}
+(NSString *)API:(NSString *)APIs{
    
    return [NSString stringWithFormat:@"%@%@",[self APIMainLink],APIs];
}

+(NSString *)encrypt:(NSString *)text{
    return [FBEncryptorAES encryptBase64String:text keyString:kEncriptionKey separateLines:NO];
}
+(NSString *)decrypt:(NSString *)text{
    return [FBEncryptorAES decryptBase64String:text keyString:kEncriptionKey];
}

@end
