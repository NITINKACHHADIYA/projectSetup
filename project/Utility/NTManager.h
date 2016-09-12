//
//  NTManager.h
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTLoadingViewController.h"
#import "CoreDatabase.h"

@interface NTManager : NSObject

@property(nonatomic,retain) UIAlertController               *alertViewController;
@property(nonatomic,retain) NTLoadingViewController        *loadingViewController;

+(NTManager *)shareManager;

@end
