//
//  NTFunctions.m
//  POS
//
//  Created by test on 17/05/16.
//  Copyright © 2016 organization. All rights reserved.
//

#import "NTFunctions.h"
#import "AppDelegate.h"

@implementation NTFunctions

+(NSString *)checkNull:(NSString *)str1{
    
    NSString *str=[NSString stringWithFormat:@"%@",str1];
    if ( str== (id)[NSNull null] || str.length == 0 || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"]) {
        return @"";
    }else{
        return str;
    }
}
+(void)AlertViewWithTitle:(NSString *)Title subTitle:(NSString *)subTitle actions:(NSArray *)actions{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:Title message:subTitle preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    [alert show];
}
+(void)somethingWentWrong{
    
    UIAlertAction *Ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [NTFunctions AlertViewWithTitle:@"Server Error" subTitle:@"We're sorry! The RETAILBOX encountered an error and was unable to complete your request. Please try again later." actions:@[Ok]];
}
+(void)applicationUnderMantainance{
    
    UIAlertAction *Ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [NTFunctions AlertViewWithTitle:@"" subTitle:@"Application server is under maintenance, please try after some time" actions:@[Ok]];
    
}
+(void)Timeout{
    
    UIAlertAction *Ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [NTFunctions AlertViewWithTitle:@"Request Timeout" subTitle:@"Request Timeout. Please try again." actions:@[Ok]];

}
+(void)internetConnectionError{
    
    UIAlertAction *Ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [NTFunctions AlertViewWithTitle:@"No Internet Connection" subTitle:@"Sorry, no Internet connectivity detected. Please reconnect and try again." actions:@[Ok]];

}

+(void)showLoading{
    
    if([NTManager shareManager].loadingViewController==nil){
        NSString * storyboardName = @"common";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        [NTManager shareManager].loadingViewController = [storyboard instantiateViewControllerWithIdentifier:@"GPSLoadingViewController"];
        [NTManager shareManager].loadingViewController.view.hidden=NO;
        [NTManager shareManager].loadingViewController.view.bounds=[UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:[NTManager shareManager].loadingViewController.view];
    }
}
+(void)hideLoading{
    [NTManager shareManager].loadingViewController.view.hidden=YES;
    [[NTManager shareManager].loadingViewController.view removeFromSuperview];
    [NTManager shareManager].loadingViewController=nil;
}

-(void)wasDragged:(UITapGestureRecognizer *)tap{
};

@end;
