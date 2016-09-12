//
//  NSString+NT.h
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NT)

-(BOOL)validateEmail;
-(BOOL)stringIsEmpty;
-(NSString *)DBSingleQuata;
-(NSDate *)DateFromStringFormat:(NSString *)Format;
-(id)GetJSON;
-(NSString *)convertIntoString;

-(NSString *)encrypt;
-(NSString *)decrypt;

@end
