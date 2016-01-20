//
//  ViewController.swift
//  Clock
//
//  Created by YaoJ on 15/10/16.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var date: UIDatePicker!
    override func viewDidLoad() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func checkDate(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:00")
        let sourceTimeZone = NSTimeZone.systemTimeZone()
        formatter.timeZone = sourceTimeZone
        let result = formatter.stringFromDate(date.date)
        let setDate = formatter.dateFromString(result)
        saveDefault(setDate!,key: "setDate")
        let alertController = UIAlertController(title: "通知", message: "设置成功", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "关闭", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        self.saveDefault("no",key:"tutustat")
    }
    
    //保存用户数据
    func saveDefault(obj:AnyObject,key:String){
        let dft:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        dft.setObject(obj, forKey: key)
        dft.synchronize()
    }

}

