//
//  ViewController.swift
//  weizhudoubiyu
//
//  Created by YaoJ on 15/1/12.
//  Copyright (c) 2015年 YaoJ. All rights reserved.
//

import UIKit

var circle = [[UIButton]]()
var manage = [CircleManage]()
var cat:UIImageView?
var currentCircle:CircleManage?
var top:Int?
var left:Int?

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        top = (Int)((self.view.bounds.size.height - 28*9) / 1.2)
        left = (Int)((self.view.bounds.size.width - 28*9 - 14)/2)
        start()
    }
    
    func refresh(){
        cat?.removeFromSuperview()
        circle.removeAll()
        manage.removeAll()
        start()
    }
    
    func start(){
        
        createBackground()
        createCircle()
        createCat()
        createWall()
    }
    
    func createBackground(){
        let background = UIImageView(image: UIImage(named: "background1.png"))
        background.frame = CGRect(x: 0,y: 0,width: self.view.bounds.width,height: self.view.bounds.height)
        self.view.addSubview(background)

    }
    
    func createCircle(){
        let count = 9
        for var i = 0; i < count; i++ {
            var buttons = [UIButton]()
            for var j = 0;j < 9; j++ {
                var l = left!
                if i % 2 != 0{
                    l += 14
                }
                let button = UIButton(frame: CGRectMake((CGFloat)(l+28*j), (CGFloat)(top!+28*i), 28, 28))
                button.setBackgroundImage(UIImage(named: "gray.png"), forState: UIControlState.Normal)
                button.addTarget(self, action: "clickCircle:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(button)
                buttons.append(button)
            }
            circle.append(buttons)
        }
    }
    
    func clickCircle(btn:UIButton){
        btn.setBackgroundImage(UIImage(named: "yellow2.png"), forState: UIControlState.Normal)
        btn.tag = 1
        currentCircle?.findAllRoundCircle()
        let newCircle = currentCircle?.calcRoad()
        if  newCircle != nil {
            currentCircle = newCircle
            var l = left!
            if(currentCircle!.row % 2 != 0){
                l += 14
            }
            cat?.frame = CGRectMake((CGFloat)(l+28*currentCircle!.col), (CGFloat)(top!+28*(currentCircle!.row-1)), 28, 56)
            if(newCircle?.row == 0 || newCircle?.row == 8 || newCircle?.col == 0 || newCircle?.col == 8){
                showAlert(self, title: "糟糕！", message: "兔兔逃跑了。。。",buttonTitle:"重新开始")
            }
        }
        else{
            showAlert(self, title: "抓住兔兔~", message: "x哥哥永远爱你~",buttonTitle:"重新开始")
        }
        
    }
    
    func createCat(){
        cat = UIImageView(frame: CGRectMake((CGFloat)(left!+28*4), (CGFloat)(top!+28*3), 28, 56))
        let leftImage = UIImage(named: "left1.png")
        let middleImage = UIImage(named: "middle1.png")
        let rightImage = UIImage(named: "right1.png")
        cat!.animationImages = [leftImage!,middleImage!,rightImage!]
        cat!.animationDuration = 1
        cat!.startAnimating()
        self.view.addSubview(cat!)
        circle[4][4].tag = 1
        currentCircle = CircleManage(row: 4, col: 4)
    }
    
    func createWall(){
        let random = (Int)(arc4random() % 20 + 10)
        var wallCount = 0
        while wallCount < random {
            let x = (Int)(arc4random() % 9)
            let y = (Int)(arc4random() % 9)
            let button = circle[x][y]
            if button.tag == 0 {
                button.setBackgroundImage(UIImage(named: "yellow2.png"), forState: UIControlState.Normal)
                button.tag = 1
                wallCount++
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(view:UIViewController,title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        view.presentViewController(alert, animated: true, completion: nil)
    }

    func showAlert(view:UIViewController,title:String,message:String,buttonTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            self.refresh()
        }
        alert.addAction(ok)
        view.presentViewController(alert, animated: true, completion: nil)
    }



}

