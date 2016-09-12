//
//  NSString+NT.m
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import "NSString+NT.h"

@implementation NSString(NT)

-(BOOL)validateEmail{
    
    if( (0 != [self rangeOfString:@"@"].length) &&  (0 != [self rangeOfString:@"."].length) ){
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [self rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        
        NSString *usernamePart = [self substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return FALSE;
        }
        
        NSString *domainPart = [self substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return FALSE;
        }
        
        return TRUE;
    }
    else {// no '@' or '.' present
        return FALSE;
    }
}
-(BOOL)stringIsEmpty{
    
    if ((NSNull *) self == [NSNull null]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if (self == nil) {
            return YES;
        } else if ([self length] == 0) {
            return YES;
        } else {
            NSString *str= [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([str length] == 0) {
                return YES;
            }
        }
    }
    
    return NO;
}
-(NSString *)DBSingleQuata{
    
    if ([self stringIsEmpty]) {
        
        return @"";
    }else{
        
        return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
}
-(NSDate*)DateFromStringFormat:(NSString *)Format{
    
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    formater.dateFormat=Format;
    
    if ([formater dateFromString:self] == nil) {
        
        return [NSDate date];
    }
    
    return [formater dateFromString:self];
}
-(id)GetJSON{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
}
-(NSString *)convertIntoString{
    
    NSString *str=[NSString stringWithFormat:@"%@",self];
    if ( str== (id)[NSNull null] || str.length == 0 || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"]) {
        return @"";
    }else{
        return str;
    }
}
-(NSString *)encrypt{
    NSString *str=(NSString *)self;
    return [FBEncryptorAES encryptBase64String:str keyString:kEncriptionKey separateLines:NO];
}
-(NSString *)decrypt{
    NSString *str=(NSString *)self;
    return [FBEncryptorAES decryptBase64String:str keyString:kEncriptionKey];
}


@end
