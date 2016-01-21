//
//  ViewController.swift
//  xunzhaodoubiyu
//
//  Created by YaoJ on 15/1/13.
//  Copyright (c) 2015年 YaoJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imgs = [UIImageView]()
    var buttons = [UIButton]()
    var rst = [Int]()
    var animateImg = [AnyObject]()
    var randomImg = UIImage()
    var currentTag = 0
    var winName = "f3.png"
    var totalCount = 0
    var win = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var background = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        background.image = UIImage(named: "sea.jpg")
        self.view.addSubview(background)
        
        var width = 190
        var twoWidth = 95
        var d0 = UIImage(named: "d6.png")
        var d1 = UIImage(named: "d1.png")
        var d2 = UIImage(named: "d2.png")
        var d3 = UIImage(named: "d3.png")
        var d4 = UIImage(named: "d4.png")
        var d5 = UIImage(named: "d5.png")
        var d6 = UIImage(named: "d6.png")
        animateImg = [d1!,d2!,d3!,d4!,d5!,d6!]
        
        for var i = 0; i < 5; i++ {
            var img = UIImageView(frame: CGRectMake((CGFloat)(i*width + 4), 20, 180, 105))
            var btn = UIButton(frame: CGRectMake((CGFloat)(i*width + 4), 20, 180, 105))
            btn.addTarget(self, action: "clickImg:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag = i+1
            self.view.addSubview(btn)
            if(i>2){
                btn.frame = CGRectMake((CGFloat)((i-3)*width + twoWidth + 4), 140, 180, 105)
                img.frame = CGRectMake((CGFloat)((i-3)*width + twoWidth + 4), 140, 180, 105)
            }
            img.image = d0
            self.view.addSubview(img)
            imgs.append(img)
            totalCount++
        }
    }
    
    func clickImg(btn:UIButton){
        var tag = btn.tag
        if tag != 0 && !win{
            currentTag = tag
            var random = (Int)(arc4random() % 5)
            while indexOfArray(rst,obj: random){
                random = (Int)(arc4random() % 5)
            }
            var name = "f\(random+1).png"
            if name == winName {
                win = true
            }
            randomImg = UIImage(named: name)!
            var temp = animateImg
            imgs[tag-1].animationImages = temp
            imgs[tag-1].animationDuration = 1
            imgs[tag-1].animationRepeatCount = 1
            imgs[tag-1].startAnimating()
            NSTimer.scheduledTimerWithTimeInterval(1.1, target: self, selector: "stopImg", userInfo: nil, repeats: false)
            btn.tag = 0
            rst.append(random)
        }
    }
    
    func stopImg(){
       imgs[currentTag-1].image = randomImg
        if win{
            showAlert(self, title: "恭喜你！", message: "成功找到了逗比鱼。。。")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func indexOfArray(array:[Int],obj:Int) -> Bool{
        var bool = false
        for item in array {
            if item == obj{
                bool = true
                break
            }
        }
        return bool
    }

    func showAlert(view:UIViewController,title:String,message:String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var ok = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        view.presentViewController(alert, animated: true, completion: nil)
    }

}
