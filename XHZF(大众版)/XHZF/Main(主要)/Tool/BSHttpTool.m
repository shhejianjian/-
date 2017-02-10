//
//  BSHttpTool.m
//  busale
//
//  Created by 谢琰 on 15/12/22.
//  Copyright © 2015年 busale. All rights reserved.
//

#import "BSHttpTool.h"
#import "AFNetworking.h"
#import "XHConst.h"
@implementation BSHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];

    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];

    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
         }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    

}
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
     }];
 }
//- (void)setHTTPHeader {
//    [self setUserid:self.userid sessionId:self.sessionId];
//}

//- (NSString *)userid{
//    _userid = [kUserDefaults objectForKey:kUserID];
//    return _userid;
//}
//
//- (NSString *)sessionId{
//    _sessionId = [kUserDefaults objectForKey:kSession];
//    return _sessionId;
//}
//- (void)setUserid:(NSString *)userid sessionId:(NSString *)sessionId{
//    _sessionId = sessionId;
//    _userid = userid;
//    NSString *headUserid = userid.length>0?userid:@"0";
//    NSString *headSessionId = sessionId.length>0?sessionId:@"0";
//    [self.requestSerializer setValue:headUserid forHTTPHeaderField:@"userid"];
//    [self.requestSerializer setValue:headSessionId forHTTPHeaderField:@"session"];
//}

@end
