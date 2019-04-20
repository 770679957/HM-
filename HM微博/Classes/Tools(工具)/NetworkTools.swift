//
//  NetworkTools.swift
//  HM微博
//
//  Created by hongmei on 2019/4/19.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit
import AFNetworking

//http 请求方法枚举
enum HMRequestMethod:String {
    case GET = "GET"
    case POST = "POST"
    
}

class NetworkTools: AFHTTPSessionManager {
    
    //应用程序信息
    private let appKey = "2410496155"
    private let appSecret = "42f030373ec9c88c03b841da5742eddd"
    private let redirectUrl = "http://www.baidu.com"
    
    //网络请求完成回调
    typealias  HMRequestCallBack = (Any?,Error?)->()//新修改
    //单例
    static let sharedTools:NetworkTools = {
        let tools = NetworkTools(baseURL: nil)
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
        
    }()

}
/// 网络请求
///
/// - parameter method:     GET / POST
/// - parameter URLString:  URLString
/// - parameter parameters: 参数字典
/// - parameter finished:   完成回调
extension NetworkTools {
    
    func request(method:HMRequestMethod,URLString:String,parameters:[String:AnyObject]?,finished:@escaping HMRequestCallBack)
    {
        //成功回调
        let success={(task:URLSessionDataTask?,result:Any?)->() in finished(result,nil)}//新修改
        //失败回调
        let failure={(task:URLSessionDataTask?,error:Error?)->() in finished(nil,error)}//新修改
        
        if method==HMRequestMethod.GET
        {
            get(URLString, parameters: parameters, progress: nil, success: success,failure:failure)
        }
    
        if method==HMRequestMethod.POST
        {
            post(URLString, parameters: parameters, progress: nil, success: success,failure:failure)
        }
    }
}

//// MARK: - OAuth 相关方法
extension NetworkTools {
    //OAuth授权 URL
    var OAuthURL:NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUrl)"
        
        return NSURL(string: urlString)!
        
    }
    //加载AccessToken
    func loadAccessToken(code:String,finished:@escaping HMRequestCallBack){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id":appKey,
                      "client_secret":appSecret,
                      "grant_type":"authorization_code",
                      "code": code,
                      "redirect_uri":redirectUrl]
        request(method: .POST, URLString: urlString, parameters: params as [String : AnyObject], finished: finished)
        
    }
}

extension NetworkTools {
    //加载用户信息
    func loadUserInfo(uid:String,accessToken:String,finished:@escaping HMRequestCallBack) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid,"access_token":accessToken]
        request(method: .GET, URLString: urlString, parameters: params as [String : AnyObject], finished: finished)
        
    }
    
}
