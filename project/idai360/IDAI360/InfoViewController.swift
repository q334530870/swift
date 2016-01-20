//
//  InfoViewController.swift
//  IDAI360
//
//  Created by YaoJ on 15/12/8.
//  Copyright © 2015年 YaoJ. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController,UIWebViewDelegate {

    var content = ""
    var segue = ""
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = content
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    @IBAction func agree(sender: AnyObject) {
        self.performSegueWithIdentifier(segue, sender: nil)
    }
    
    @IBAction func goRegisterView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
