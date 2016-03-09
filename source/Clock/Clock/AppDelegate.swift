//
//  AppDelegate.swift
//  Clock
//
//  Created by YaoJ on 15/10/16.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        let stat = loadDefault("tutustat") as! String
        if stat == "ok"{
            application.cancelAllLocalNotifications()
            application.applicationIconBadgeNumber = 0
        }
        //application.cancelAllLocalNotifications()
        //application.applicationIconBadgeNumber = 0
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8 {
            //            APService.registerForRemoteNotificationTypes(
            //                UIUserNotificationType.Badge.rawValue |
            //                UIUserNotificationType.Sound.rawValue |
            //                UIUserNotificationType.Alert.rawValue,
            //                categories: setting.categories)
            
            //1.创建一组动作
            let userAction = UIMutableUserNotificationAction()
            userAction.identifier = "action"
            userAction.title = "打开"
            userAction.activationMode = UIUserNotificationActivationMode.Foreground
            
            let userAction2 = UIMutableUserNotificationAction()
            userAction2.identifier = "action2"
            userAction2.title = "关闭"
            userAction2.activationMode = UIUserNotificationActivationMode.Background
            userAction2.authenticationRequired = true
            userAction2.destructive = true
            
            //2.创建动作的类别集合
            let userCategory = UIMutableUserNotificationCategory()
            userCategory.identifier = "MyNotification"
            userCategory.setActions([userAction,userAction2], forContext: UIUserNotificationActionContext.Minimal)
            let categories:NSSet = NSSet(object: userCategory)
            
            //3.创建UIUserNotificationSettings，并设置消息的显示类类型
            let userSetting = UIUserNotificationSettings(forTypes:
                [UIUserNotificationType.Badge,
                    UIUserNotificationType.Sound,
                    UIUserNotificationType.Alert]
                , categories: categories as? Set<UIUserNotificationCategory>)
            
            //4.注册推送
            application.registerForRemoteNotifications()
            application.registerUserNotificationSettings(userSetting)
            
        }
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate().dateByAddingTimeInterval(startDate())
        //setting timeZone as localTimeZone
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.repeatInterval = NSCalendarUnit.Minute
        notification.alertTitle = "紧急通知"
        notification.alertBody = "该起床咯~~~"
        notification.alertAction = "好的"
        notification.soundName = "qc.caf"
        //setting app‘s icon badge
        notification.applicationIconBadgeNumber = 0
        
        var userInfo:[NSObject : AnyObject] = [NSObject : AnyObject]()
        userInfo["kLocalNotificationID"] = "tututu"
        userInfo["key"] = "通知"
        notification.userInfo = userInfo
        let stat = loadDefault("tutustat") as! String
        if stat != "ok"{
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        //UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        //application.presentLocalNotificationNow(notification)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.cancelAllLocalNotifications()
        application.applicationIconBadgeNumber = 0
        //let userInfo = notification.userInfo!
        //let title = userInfo["key"] as! String
        
        //        let alert = UIAlertView()
        //        alert.title = title
        //        alert.message = notification.alertBody
        //        alert.addButtonWithTitle(notification.alertAction!)
        //        alert.cancelButtonIndex = 0
        //        alert.show()
        
        //APService.showLocalNotificationAtFront(notification, identifierKey: nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //setting the desk top application icon‘s badge as zero
        //application.applicationIconBadgeNumber = 0
        //        application.cancelAllLocalNotifications()
        //        application.applicationIconBadgeNumber = 0
        
    }
    
    func startDate()->NSTimeInterval{
        let setDate = loadDefault("setDate") as! NSDate
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        let sourceTimeZone = NSTimeZone.systemTimeZone()
        formatter.timeZone = sourceTimeZone
        let currentDateString = formatter.stringFromDate(NSDate())
        let currentDate = formatter.dateFromString(currentDateString)
        let interval = setDate.timeIntervalSinceDate(currentDate!)
        return interval
    }
    
    //保存用户数据
    func saveDefault(obj:AnyObject,key:String){
        let dft:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        dft.setObject(obj, forKey: key)
        dft.synchronize()
    }
    
    //读取用户数据
    func loadDefault(key:String) ->AnyObject?{
        let dft:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        return dft.objectForKey(key)
    }
    
    
    
    
}

