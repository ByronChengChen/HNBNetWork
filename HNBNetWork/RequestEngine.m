//
//  RequestEngine.m
//  Pods
//
//  Created by 开发 on 2017/6/28.
//
//

#import "RequestEngine.h"
#import "AFNetworking.h"
#import "NSObject+HNB.h"

@implementation RequestEngine

+ (instancetype)sharedEngine{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSURLSessionTask *)addRequest:(BaseRequest*)baseRequest
                   successBlock:(IdBlock)successBlock
                   requestFailBlock:(RequestFailBlock)failBlock{
    NSURLSessionTask *task = nil;
    task = [self sessionTaskFotRequest:baseRequest successBlock:successBlock requestFailBlock:failBlock];
    return task;
}

- (NSURLSessionTask *)sessionTaskFotRequest:(BaseRequest*)baseRequest successBlock:(IdBlock)successBlock requestFailBlock:(RequestFailBlock)failBlock{
    NSURLSessionTask *task = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseRequest.baseUrl,baseRequest.apiUrl];
    NSDictionary *params = [self assembleParams:(NSMutableDictionary*)baseRequest.keyAndVaules];
    //TODO: chengk 待优化 颜色打印
    NSString *methordStr = nil;
    switch (baseRequest.apiMethord) {
        case APIGet:
            methordStr = @"GET";
            break;
        case APIPost:
            methordStr = @"POST";
            break;
        default:
            break;
    }
    NSLog(@"request:--------------\n method:%@,url:%@,\n params:%@",methordStr,url,[self jsonString:params]);
    switch (baseRequest.apiMethord) {
        case APIGet:
        {
            task = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
                successBlock(responseObject);
                NSLog(@"reponse:++++++++++++++\n url:%@,\n params:%@,\n responseObject:%@",url,params,[self jsonString:responseObject]);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                //取消了就不回调了 ,这里不该这样，应该让用户知道自己取消了网络请求。
                if(NSURLErrorCancelled != error.code){
                    failBlock(error);
                }
            }];
        }
            break;
        case APIPost:{
            task = [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                successBlock(responseObject);
                NSLog(@"reponse:++++++++++++++\n url:%@,\n params:%@,\n responseObject:%@ ",url,params,[self jsonString:responseObject]);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                //取消了就不回调了
                if(NSURLErrorCancelled != error.code){
                    failBlock(error);
                }
            }];
        }
            break;
        default:
            break;
            
    }
    return task;
}

- (NSDictionary *)assembleParams:(NSDictionary*)param{
    NSDictionary *dict = param;
    return dict;
}

- (NSString *)jsonString:(NSDictionary*)dict {
    if(!dict)
        return nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) return nil;
    NSString *json = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    return json;
}

@end
