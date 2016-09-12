//
//  NTDefines.h
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTManager.h"
#import "NTApis.h"
#import "NTFunctions.h"
#import "NTWebServices.h"
#import "NSData+NT.h"
#import "NSDate+NT.h"
#import "NSMutableArray+NT.h"
#import "NSMutbleDictionary+NT.h"
#import "NSString+NT.h"
#import "UIImageView+NT.h"
#import "UIView+NT.h"
#import "UIImage+NT.h"
#import "UIButton+NT.h"
#import "UITextField+NT.h"
#import "UIAlertViewController+NT.h"
#import "UILabel+NT.h"
#import "FBEncryptorAES.h"
#import "iCarousel.h"

#define STORYBOARD_WIDTH 1024

#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
 
#define APP_DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define IS_IPAD_PRO ( SCREEN_WIDTH == 1024.000000 && SCREEN_HEIGHT == 1366.000000)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
#define IS_IOS_7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IS_IOS_8    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define IS_IOS_8_LOWER    ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)

#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IOS_VERSION_LOWER_THAN_8 (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
#define SCREEN_WIDTH_FRAME (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.width)

#define SCREEN_HEIGHT_FRAME (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.height)

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__) //#   define NSLog(...) NSLog(__VA_ARGS__)

#else
#   define NSLog(...)
#endif

#define Release(x) [x release]

#define safeRelease(x) [x release], x = nil

@interface NTDefines : NSObject

@end
