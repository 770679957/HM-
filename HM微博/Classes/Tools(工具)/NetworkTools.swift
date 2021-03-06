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
    //返回token字典
    private var tokenDict:[String:AnyObject]? {
       //判断token是否有效
        if let token = UserAccountViewModel.sharedUserAccount.account?.access_token {
            return["access_token":token as AnyObject]
        }
        return nil
    }
    
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
    /// 使用 token 进行网络请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter finished:   完成回调
    private func tokenRequest(method: HMRequestMethod, URLString: String, parameters: [String: AnyObject]?, finished: @escaping HMRequestCallBack) {
        //设置token参数，将token添加到parameters字典中
        //判断token 是否有效
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else {
            //token无效
            //如果字典为空，通知调用方，token无效
            finished(nil,NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message": "token 为空"]))
            return
        }
        //设置parameters字典
        //将方法参数赋值给局部变量
        var parameters = parameters
        //判断参数字典是否有值
        if parameters == nil {
            parameters = [String:AnyObject]()
        }
        parameters!["access_token"] = token as AnyObject
        //发起网络请求
        request(method: method, URLString: URLString, parameters: parameters, finished: finished)
    }
    
    //上传文件
    private func upload(URLString:String,data:NSData,name:String,parameters:[String:AnyObject]?,finished:@escaping HMRequestCallBack) {
        //设置token参数，将token添加到parameters 字典中
        //判断token是否有效
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else {
            //token无效
            //如果字典为空，通知调用方，token无效
            finished(nil,NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message": "token 为空"]))
            return
        }
        //设置parameters字典
        //将方法参数赋值给局部变量
        var parameters = parameters
        //判断参数字典是否有值
        if parameters == nil {
            parameters = [String:AnyObject]()
        }
         parameters!["access_token"] = token as AnyObject
  
        post(URLString, parameters: parameters, constructingBodyWith: {(formData) -> Void in
            
            formData.appendPart(withFileData: data as Data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
        }, success: { (_, result) -> Void in
            finished(result, nil)
        }) { (_, error) -> Void in
            print(error)
            finished(nil, error)
        }
        
    }
    
    
    
}
/// 发布微博
///
/// - parameter status:   微博文本
/// - parameter image:    微博配图
/// - parameter finished: 完成回调
extension NetworkTools {
    
    func sendStatus(status:String,image:UIImage?,finished:@escaping HMRequestCallBack) {
        //创建参数字典
        var params = [String:AnyObject]()
         params["status"] = status as AnyObject        //设置参数
        //判断是否上传图片
        if image == nil {
           
            //params["status"] = "测试，测试，http://www.mob.com/downloads/" as AnyObject
            let urlString = "https://api.weibo.com/2/statuses/share.json"
            //发起f网络请求
            tokenRequest(method: .POST, URLString: urlString, parameters: params, finished: finished)
        }else {
            let urlString = "https://api.weibo.com/2/statuses/share.json"
            let data = image!.pngData()
            
            upload(URLString: urlString, data: data! as NSData, name: "pic", parameters: params, finished: finished)
            
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
//-用户的相关方法
extension NetworkTools {
    //加载用户信息
    func loadUserInfo(uid: String,finished:@escaping HMRequestCallBack) {
        
        //获取token 字典
        guard var params = tokenDict else {
            //如果字典为空，通知调用方无效
            finished(nil,NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token 为空"]))
            
            return
            
        }
        
        //处理网络参数
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        params["uid"] = uid as AnyObject
        request(method: .GET, URLString: urlString, parameters: params as [String : AnyObject], finished: finished)
    }
//    func loadUserInfo(uid:String,accessToken:String,finished:@escaping HMRequestCallBack) {
//        let urlString = "https://api.weibo.com/2/users/show.json"
//        let params = ["uid":uid,"access_token": accessToken]
//        request(method: .GET, URLString: urlString, parameters: params as [String : AnyObject], finished: finished)
//
//    }
    
}

//微博数据相关方法
extension NetworkTools {
    //加载微博数据
    func loadStatus(since_id:Int,max_id:Int,finished:@escaping HMRequestCallBack) {
        // 1. 创建参数字典
        var params = [String:AnyObject]()
        
        // 判断是否下拉
        guard let p = tokenDict else
        {
            finished(nil,NSError(domain:"cn.itcast.error",code:-1001,userInfo:["message":"token is nil"]))
            return
        }
        
        params["access_token"] = p["access_token"]
        
        if since_id > 0 {
            params["since_id"] = since_id as AnyObject?
        }else if max_id > 0 {
            params["max_id"] = max_id - 1 as AnyObject?
        }
        // 2. 准备网络参数
        let urlString="https://api.weibo.com/2/statuses/home_timeline.json"
        // 3. 发起网络请求
        request(method: .GET, URLString: urlString, parameters: params, finished: finished)
    }
}

