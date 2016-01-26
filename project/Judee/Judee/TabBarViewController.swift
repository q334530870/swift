//
//  TabBarViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/22.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBOutlet weak var tb: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tb.tintColor = MAIN_COLOR
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
