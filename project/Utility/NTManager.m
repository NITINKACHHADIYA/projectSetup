//
//  NTManager.m
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import "NTManager.h"


@implementation NTManager


static NTManager *instance =nil;

+(NTManager *)shareManager{
    
    @synchronized(self){
        
        if(instance==nil){
            
            instance= [NTManager new];
        }
    }
    return instance;
}
@end
