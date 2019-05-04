//
//  AppDelegate.swift
//  HM微博
//
//  Created by hongmei on 2019/4/18.
//  Copyright © 2019年 itheima. All rights reserved.
//

import UIKit

@UIApplicationMain

 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
        
        //监听通知
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), // 通知名称，通知中心用来识别通知的
            object: nil,                           // 发送通知的对象，如果为nil，监听任何对象
            queue: nil)                           // nil，主线程
        { [weak self] (notification) -> Void in // weak self，
            let vc = notification.object != nil ? WelcomeViewController() : MainViewController()
            
            // 切换控制器
            self?.window?.rootViewController = vc
        }
        
        return true
    }
    
    //类在销毁时注销指定的通知
    deinit{
        //注销通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate{
    //判断是否新版本
    private var isNewVersion:Bool{
        //当前的版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        //print("当前版本\(version)")
        // 2. `之前`的版本，把当前版本保存在用户偏好 - 如果 key 不存在，返回 0
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = UserDefaults.standard.double(forKey: sandboxVersionKey)
        //print("之前版本 \(sandboxVersion)")
        // 3. 保存当前版本
        UserDefaults.standard.set(version, forKey:sandboxVersionKey)
        
        return version > sandboxVersion
    }
    
    //启动的跟视图控制器
    private var defaultRootViewController:UIViewController {
        
        //判断是否登录
        if UserAccountViewModel.sharedUserAccount.userLogon {
            return isNewVersion ? NewFeatureViewController() : WelcomeViewController()
            
            
        }
        
        return MainViewController()
        
    }
    
    
}

