//
//  NTApis.h
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import <Foundation/Foundation.h>
/** method Type */
typedef NS_ENUM(NSInteger,KAPIType){
    /** method Type get */
    KAPITypeGet=1,
    /** method Type post */
    KAPITypePost=2,
    /** method Type json post */
    KAPITypePostJson=3,
};

/** response Type */
typedef NS_ENUM(NSInteger,KResponseType){
    /** response Type json */
    KResponseTypeJson=1,
    /** response Type string */
    KResponseTypeString=2,
    /** response Type data */
    KResponseTypeData=3
};

/** block retrun resoponse or error */
typedef void(^KAAPIsCompleted)(NSError *error, id json,NSHTTPURLResponse *response);

@protocol KAAPIDelegate;
@interface NTApis :NSOperation<NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSURLSessionDataDelegate>
{
    NSDate *dateStart;
    NSDate *dateEnd;
    NSMutableString *strLog;
    NSHTTPURLResponse *httpResponse;
}

/** complition block */
@property(nonatomic,copy)   KAAPIsCompleted   complitionBlock;

/** KAAPIs delegate objects*/
@property(nonatomic,retain) id<KAAPIDelegate> delegate;

/** post parameters object*/
@property(nonatomic,weak) NSDictionary      *dictParameters;

/** json string object*/
@property(nonatomic,weak) NSString          *strJsonParameters;

/** get string object*/
@property(nonatomic,weak) NSString          *strGetParameters;

/** string link*/
@property(nonatomic,weak) NSString          *strLink;

/** API call from which screen*/
@property(nonatomic,weak) NSString          *strModuleName;

/** KAAPIs API type*/
@property(nonatomic,assign) NSInteger       iAPIType;

/** API tag no*/
@property(nonatomic,assign) NSInteger       tag;

/** response type*/
@property(nonatomic,assign) NSInteger       responseType;

/** API loading Time*/
@property(nonatomic,assign) float           minutes;


/** API loading show*/
@property(nonatomic,assign) BOOL            hideLoading;

/** @name methods*/
/** after set app parameters then call startRequest method for server call
 *
 * when request finish then KAAPIDelegate methods called
 *
 * @see [-kaApisSuccess:response:]([KAAPIDelegate kaApisSuccess:response:])
 * @see [-kaApisFail:]([KAAPIDelegate kaApisFail:])
 * @see [-kaApisTimeOut:]([KAAPIDelegate kaApisTimeOut:])
 */
-(void)startRequest;
/** you can stop server request*/
-(void)stopRequest;
-(void)clear;

/** after response from server call finishRequest block
 * @param complitionBlock complitionBlock return error, response and json
 */
-(void)finishRequest:(KAAPIsCompleted)complitionBlock;

@end

/** KAAPIs protocol*/
@protocol KAAPIDelegate <NSObject>

/** call method when response status code 200
 * @param apis KAAPIs referance object
 * @param response response object
 */
-(void)kaApisSuccess:(NTApis *)apis response:(id)response;

/** call method when response status code 200
 * @param apis KAAPIs referance object
 */
-(void)kaApisFail:(NTApis *)apis;

/** call method when requestTimepit
 * @param apis KAAPIs referance object
 */
-(void)kaApisTimeOut:(NTApis *)apis;
@end
