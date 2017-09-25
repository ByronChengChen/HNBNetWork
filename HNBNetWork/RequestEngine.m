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
    
    //设置请求序列
    manager.requestSerializer = [baseRequest hnbRequestSerializerType];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    //设置http头部
    if([baseRequest respondsToSelector:@selector(httpHeaderDict)]){
        NSDictionary *httpHeaderDict = [baseRequest httpHeaderDict];
        if(httpHeaderDict){
            [httpHeaderDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if(key && obj){
                    [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
                }
            }];
        }
    }
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
            task = [self netWorkManager:manager getUrl:url params:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseData) {
                if(successBlock){
                    successBlock(responseData);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(failBlock){
                    failBlock(error);
                }
            }];
        }
            break;
        case APIPost:{
            task = [self netWorkManager:manager postUrl:url params:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseData) {
                if(successBlock){
                    successBlock(responseData);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(failBlock){
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

- (NSURLSessionTask *)netWorkManager:(AFHTTPSessionManager *)manager getUrl:(NSString *)url
                              params:(NSDictionary *)params
                             success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseData))success
                             failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    return [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
        success(task,responseObject);
        NSLog(@"reponse:++++++++++++++\n url:%@,\n params:%@,\n responseObject:%@",url,params,[self jsonString:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        //取消了就不回调了 ,这里不该这样，应该让用户知道自己取消了网络请求。
        if(NSURLErrorCancelled != error.code){
            failure(task,error);
        }
    }];
}

- (NSURLSessionTask *)netWorkManager:(AFHTTPSessionManager *)manager postUrl:(NSString *)url
                              params:(NSDictionary *)paramsDict
                             success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseData))success
                             failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    //AFJSONResponseSerializer 才需要使用到字典，AFPropertyListRequestSerializer 是plist方式，暂不处理
    BOOL paramSouldUseDictFlag = NO;
    if([manager.requestSerializer isKindOfClass:[AFJSONResponseSerializer class]]){
        paramSouldUseDictFlag = YES;
    }
    if([manager.requestSerializer isKindOfClass:[AFPropertyListRequestSerializer class]]){
        //AFPropertyListRequestSerializer 是plist方式，暂不处理
        NSAssert(0,@"hnb net work error,request serial is AFPropertyListRequestSerializer\n");
        return nil;
    }
    id params = nil;
    if(paramSouldUseDictFlag){
        params = paramsDict;
    }else{
        params = [self jsonString:paramsDict];
    }
    return [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        success(task,responseObject);
        NSLog(@"reponse:++++++++++++++\n url:%@,\n params:%@,\n responseObject:%@ ",url,params,[self jsonString:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        //取消了就不回调了
        if(NSURLErrorCancelled != error.code){
            failure(task,error);
        }
    }];
}

- (NSDictionary *)assembleParams:(NSDictionary*)param{
    NSDictionary *dict = param;
    return dict;
}

//TODO: chengk 网络请求，http请求头自定义 1 这里的jsonString方法需要抽出
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
