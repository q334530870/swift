//
//  AppDelegate.swift
//
//  Created by YaoJ on 15/12/7.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var introductionView: ZWIntroductionViewController?
    var viewController: UIViewController?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let dft = NSUserDefaults.standardUserDefaults()
        //let showIntroduction: AnyObject? = dft.objectForKey("showIntroduction")
        let showIntroduction: AnyObject? = dft.objectForKey("showIntroduction")
        if showIntroduction == nil{
            // Do any additional setup after loading the view, typically from a nib.
            let coverImageNames = ["",""]
            let backgroundImageNames = ["guide","guide"]
            self.introductionView = ZWIntroductionViewController(coverImageNames: coverImageNames, backgroundImageNames: backgroundImageNames)
            
            // Example 2
            // var enterButton: UIButton? = UIButton()
            // enterButton?.setBackgroundImage(UIImage(named: "bg_bar"), forState: UIControlState.Normal)
            // self.introductionView = ZWIntroductionViewController(coverImageNames: coverImageNames, backgroundImageNames: backgroundImageNames, button: enterButton)
            
            self.introductionView!.didSelectedEnter = {
                self.introductionView!.view.removeFromSuperview()
                self.introductionView = nil
                self.window?.rootViewController = self.viewController
                dft.setObject("true", forKey: "showIntroduction")
                dft.synchronize()
            }
            viewController = self.window?.rootViewController
            self.window?.rootViewController = introductionView
        }
        
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
            userCategory.identifier = "idai360Notification"
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
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        notification.fireDate = NSDate().dateByAddingTimeInterval(10)
        //setting timeZone as localTimeZone
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.repeatInterval = NSCalendarUnit.Minute
        if #available(iOS 8.2, *) {
            notification.alertTitle = "京西贷"
        }
        notification.alertBody = "本地通知推送"
        notification.alertAction = "确定"
        notification.soundName = UILocalNotificationDefaultSoundName
        //notification.soundName = "qc.caf"
        //setting app‘s icon badge
        notification.applicationIconBadgeNumber = 1
        
        var userInfo:[NSObject : AnyObject] = [NSObject : AnyObject]()
        userInfo["kLocalNotificationID"] = "idai360-message"
        userInfo["key"] = "message"
        notification.userInfo = userInfo
        //application.presentLocalNotificationNow(notification)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let alertController = UIAlertController(title: nil, message: "成功灭火", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "关闭", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,handler:nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        application.cancelAllLocalNotifications()
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

