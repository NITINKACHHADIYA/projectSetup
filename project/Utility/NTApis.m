//
//  NTApis.m
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import "NTApis.h"

@implementation NTApis

-(void)dealloc{
    
    self.strGetParameters=nil;
    self.strJsonParameters=nil;
    self.strLink=nil;
    
    dateStart=nil;
    dateEnd=nil;
    
    self.dictParameters=nil;
}
-(void)stopRequest{
    
    strLog=nil;
    [self.delegate kaApisFail:self];
}
-(void)clear{
    
    [self.delegate kaApisFail:self];
}
+(NSURLSession *)session{
    
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.URLCache=nil;
        configuration.HTTPCookieStorage=nil;
        [configuration setHTTPMaximumConnectionsPerHost:1];
        session = [NSURLSession sessionWithConfiguration:configuration];
        
    });
    return session;
}
-(void)startRequest{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    dateStart=[NSDate date];
    strLog=[[NSMutableString alloc] init];
    [strLog appendString:@"\n=============================================================="];
    [strLog appendString:[NSString stringWithFormat:@"\n================= %@ ================\n",[dateStart StringFromDateFormat:@"dd MMM yyyy hh:mm:ss:SSS a"]]];
    [strLog appendString:@"==============================================================\n\n"];
    //[strLog appendString:[NSString stringWithFormat:@"Module  \t: %@\n",self.strModuleName]];
    
    NSString *encodedString=@"";
    if(self.iAPIType==KAPITypeGet) {
        encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self.strGetParameters,NULL,(CFStringRef)@"!*'();:@+$,/?%#[]",kCFStringEncodingUTF8));
        self.strLink=[self.strLink stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        //@"!*'();:@&=+$,/?%#[]"
    }
    NSURL *url=nil;
    
    if (KAPITypePost==self.iAPIType || KAPITypePostJson==self.iAPIType) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.strLink]];
    }else if(encodedString==nil){
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.strLink]];
    }else{
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",self.strLink,encodedString]];
    }
    encodedString=nil;
    
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
    [request1 setURL:url];
    [request1 setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request1 setTimeoutInterval:self.minutes==0?2*60:self.minutes*60];
    [request1 setValue:@"ipad" forHTTPHeaderField:@"User-Agent"];
    
    if (self.iAPIType==KAPITypeGet) {
        [request1 setHTTPMethod:@"GET"];
        
        //NSLog(@"\n=================================\nLink\t\t: %@\nMethod\t\t: %@\n=================================\n",url,@"GET");
        
        [strLog appendString:[NSString stringWithFormat:@"Link    \t: %@\nMethod  \t: %@\n",url,@"GET"]];
        
        
    }else if (self.iAPIType==KAPITypePost) {
        
        NSMutableString *postValues=[[NSMutableString alloc] init];
        for (int i=0;i<self.dictParameters.count;i++) {
            
            NSString *keys=self.dictParameters.allKeys[i];
            NSString *values=[NSString stringWithFormat:@"%@",[self.dictParameters valueForKey:self.dictParameters.allKeys[i]]];
            [postValues appendString:keys];
            [postValues appendString:@"="];
            [postValues appendString:values];
            [postValues appendString:@"&"];
        }
        
        [request1 setHTTPMethod:@"POST"];
        if (postValues.length>0) {
            [postValues substringToIndex:postValues.length-1];
            NSData *postData = [postValues dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            [request1 setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request1 setHTTPBody:postData];
        }
        
        //NSLog(@"\n=================================\nLink\t\t: %@\nMethod\t\t: %@\nRequest\t: %@\n=================================\n",url,@"POST",postValues);
        [strLog appendString:[NSString stringWithFormat:@"Link    \t: %@\nMethod  \t: %@\nRequest \t: %@\n",url,@"POST",postValues]];
        postValues=nil;
        
    }else if (self.iAPIType==KAPITypePostJson){
        [request1 setHTTPMethod:@"POST"];
        
        self.strJsonParameters=[self.strJsonParameters stringByReplacingOccurrencesOfString:@"" withString:@""];
        NSData *requestData = [NSData dataWithBytes:[self.strJsonParameters UTF8String] length:[self.strJsonParameters length]];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
        
        [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request1 setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request1 setHTTPBody:requestData];
        
        //NSLog(@"\n=================================\nLink\t\t: %@\nMethod\t\t: %@\nRequest\t: %@\n=================================\n",url,@"POST-JSON",self.strJsonParameters);
        [strLog appendString:[NSString stringWithFormat:@"Link    \t: %@\nMethod  \t: %@\nRequest \t: %@\n",url,@"POST-JSON",self.strJsonParameters]];
    }
    
    
    NSURLSessionDataTask *task=[[[self class] session]  dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
            httpResponse=res;
            if (error) {
                [self PrintLog:error response:nil];
                if (self.complitionBlock)
                    self.complitionBlock(error,nil,nil);
            
                if (error.code==NSURLErrorTimedOut) {
                    [NTFunctions Timeout];
                    [self.delegate kaApisTimeOut:self];
                }else if(error.code==NSURLErrorCannotConnectToHost || error.code==NSURLErrorCannotFindHost || error.code==NSURLErrorNotConnectedToInternet){
                    [NTFunctions internetConnectionError];
                    [self.delegate kaApisTimeOut:self];
                }else{
                    [NTFunctions somethingWentWrong];
                    [self.delegate kaApisFail:self];
                }
                
            }else if (data.length != 0 && res.statusCode==200){
                
                    if (self.complitionBlock)
                        self.complitionBlock(nil,data,res);
                    
                    if (self.responseType==KResponseTypeJson) {
                        
                        NSError* error=nil;
                        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        if (!error && json){
                            [self.delegate kaApisSuccess:self response:json];
                        }else{
                            [self.delegate kaApisFail:self];
                        }
                    }else if(self.responseType==KResponseTypeString) {
                        if (data.length==0) {
                            
                        }else{
                            NSString *json = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                            [self.delegate kaApisSuccess:self response:json];
                        }
                    }else if(self.responseType==KResponseTypeData) {
                        [self.delegate kaApisSuccess:self response:data];
                    }
                [self PrintLog:nil response:data];
            }else if (res.statusCode==401){
                
                if (self.complitionBlock)
                    self.complitionBlock(error,nil,nil);
                [self PrintLog:nil response:data];
                [NTFunctions somethingWentWrong];
            }else{
                if (self.complitionBlock)
                    self.complitionBlock(error,nil,nil);
                [self PrintLog:nil response:data];
                [NTFunctions somethingWentWrong];
            }
            
        }];
    }];
    [task resume];
}
-(void)finishRequest:(KAAPIsCompleted)complitionBlock{
    
    self.complitionBlock=complitionBlock;
}
-(void)block{
    
    /*dispatch_queue_t serialQueue = dispatch_queue_create("com.appcoda.imagesQueue", DISPATCH_QUEUE_SERIAL);
     dispatch_async(serialQueue, ^{
     
     NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
     dispatch_async(dispatch_get_main_queue(),^{
     NSLog(@"1");
     });
     
     });
     dispatch_async(serialQueue, ^{
     
     NSData *img1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
     dispatch_async(dispatch_get_main_queue(),^{
     NSLog(@"1");
     });
     
     });*/
}

-(void)PrintLog:(NSError *)error response:(NSData*)data{
    
    dateEnd=[NSDate date];
    NSTimeInterval executionTime = [dateEnd timeIntervalSinceDate:dateStart];
    
    if (error) {
        [strLog appendString:[NSString stringWithFormat:@"Loading  \t: %.0f ms\n",executionTime*1000]];
        [strLog appendString:[NSString stringWithFormat:@"Error   \t: %@\n",error.localizedDescription]];
        
    }else if (httpResponse.statusCode==200) {
        
        NSString *json = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        [strLog appendString:[NSString stringWithFormat:@"Response \t: %@\n",json]];
        [strLog appendString:[NSString stringWithFormat:@"Loading  \t: %.0f ms\n",executionTime*1000]];
        //[strLog appendString:[NSString stringWithFormat:@"Response\t: %@\n",json]];
        
    }else if (httpResponse.statusCode!=200) {
        
        [strLog appendString:[NSString stringWithFormat:@"Loading  \t: %.0f ms\n",executionTime*1000]];
        [strLog appendString:[NSString stringWithFormat:@"Error   \t: %@-%@\n",@(httpResponse.statusCode),[NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]]];
    }
    [strLog appendString:@"\n=============================================================="];
    [strLog appendString:[NSString stringWithFormat:@"\n================= %@ ================\n",[dateEnd StringFromDateFormat:@"dd MMM yyyy hh:mm:ss:SSS a"]]];
    [strLog appendString:@"==============================================================\n\n"];
    
    if (httpResponse.statusCode==200) {
        NSLog(@"%@",strLog);
    }else{
        [self WriteLog:strLog];
    }
    strLog=nil;
    
}
-(void)WriteLog:(NSString *)content{
    
    NSLog(@"\n%@",content);
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:@""];
    [file seekToEndOfFile];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
    strLog=nil;
}

@end
