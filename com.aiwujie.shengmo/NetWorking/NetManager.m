//
//  NetManager.m
//  ShiXiNetwork
//
//  Created by Karl on 16/5/31.
//  Copyright © 2016年 Shixi.com. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

+(AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager= [AFHTTPSessionManager manager];
    });
    return manager;
}

+ (void)requestDataWithUrlString:(NSString *)urlString contentType:(NSString *)type finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock{
    AFHTTPSessionManager *manager = [self shareManager]; 
    if (type.length) {
        //jason
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:type, nil];
    }else{
        //xml自动解析
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failedBlock(error.localizedDescription);
      
    }];
}

+ (void)afPostRequest:(NSString *)urlString parms:(NSDictionary *)dic finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock{
    [NetManager showURLStringWithURL:urlString AndParameters:dic];
    AFHTTPSessionManager *manager = [self shareManager]; //[AFHTTPSessionManager manager];
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];
  //  [manager.requestSerializer setValue:kReferer forHTTPHeaderField:@"Referer"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain",@"text/html" , nil];// [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error.localizedDescription);
       
    }];
    
}

+ (void)afGetRequest:(NSString *)urlString parms:(NSDictionary *)dic finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock{
    [NetManager showURLStringWithURL:urlString AndParameters:dic];
    AFHTTPSessionManager *manager = [self shareManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
  //     manager.responseSerializer = [AFHTTPResponseSerializer serializer];

   // [manager.requestSerializer setValue:kReferer forHTTPHeaderField:@"Referer"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain",@"text/html" , nil];//[NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];

    [manager GET:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject);
//        NSInteger statusCode = [(NSString *)responseObject[@"code"] integerValue];
//        if (statusCode == 88591) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:sameTimeLogin object:nil];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error.localizedDescription);
    }];
    
}

#pragma mark - 图片上传
+(void)uploadImages:(NSString *)url images:(NSArray *)images parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer.timeoutInterval = 30;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    //设置请求头
    [manager.requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"Content-Type"];

    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        
        for (UIImage *image in images) {
            
            //压缩图片
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            //多张图片是需要在name中加“[]”，单张上传时不用
            [formData appendPartWithFileData:data name:@"file[]" fileName:[NSString stringWithFormat:@"%@.jpg",[NSDate date]] mimeType:@"image/jpeg"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}



+ (void)SetCalcaultorRequest:(NSString *)urlString parms:(id)dicData finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock{
 //   [NetManager showURLStringWithURL:urlString AndParameters:dicData];
    AFHTTPSessionManager *manager = [self shareManager]; //

    manager.requestSerializer.timeoutInterval = 5;
   // [manager.requestSerializer setValue:kReferer forHTTPHeaderField:@"Referer"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain",@"text/html" , nil];//[NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    
    [manager GET:urlString parameters:dicData progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject);
        //        NSInteger statusCode = [(NSString *)responseObject[@"code"] integerValue];
        //        if (statusCode == 88591) {
        //            [[NSNotificationCenter defaultCenter] postNotificationName:sameTimeLogin object:nil];
        //        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error.localizedDescription);
    }];
    
}




+ (void)showURLStringWithURL:(NSString *)URL AndParameters:(NSDictionary *)parameters {
    NSMutableString *para = [NSMutableString new];
    for (NSString *key in [parameters allKeys]) {
        NSString *value = parameters[key];
        if (para.length == 0) {
            [para appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else
            [para appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
    }
    NSLog(@"🐶🐻URLString == %@?%@", URL, para);
}

@end
