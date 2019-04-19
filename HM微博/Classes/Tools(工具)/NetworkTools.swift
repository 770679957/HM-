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
    
    //网络请求完成回调
    typealias  HMRequestCallBack = (Any?,Error?)->()//新修改
    //单例
    static let sharedTools:NetworkTools = {
        let tools = NetworkTools(baseURL: nil)
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
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
