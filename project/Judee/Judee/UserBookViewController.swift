//
//  UserBookViewController.swift
//  Judee
//
//  Created by YaoJ on 16/1/26.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class UserBookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate {
    
    @IBOutlet weak var tv: UITableView!
    var data:[String]?
    var foot:UIScrollView?
    var star:HCSStarRatingView?
    var bookImageList:[UIImage]?
    var imageCache = [String:[UIImage]]()
    var browser:MWPhotoBrowser?
    var scoreLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决导航栏引起的顶部内容往下bug
        self.automaticallyAdjustsScrollViewInsets = false
        tv.delegate = self
        tv.dataSource = self
        tv.estimatedRowHeight = 100
        //隐藏返回按钮的文字
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        //初始化照片浏览
        browser = MWPhotoBrowser(delegate: self)
        browser!.alwaysShowControls = false
        browser!.modalTransitionStyle = .CrossDissolve
        //模拟数据
        data = ["1：语文书抄一遍","2：倒过来在抄一遍","3：用英语翻译一遍"]
        //初始化表格尾部
        foot = UIScrollView()
        foot?.hidden = true
        tv.tableFooterView = foot!
    }
    
    func getInfo(index:Int){
        for view in (foot?.subviews)!{
            view.removeFromSuperview()
        }
        if let cache = imageCache["\(index)"]{
            bookImageList = cache
        }
        else{
            bookImageList =
                [UIImage(named: "judy.jpg")!,UIImage(named: "judy.jpg")!,UIImage(named: "judy.jpg")!,
                    UIImage(named: "judy.jpg")!,UIImage(named: "judy.jpg")!,UIImage(named: "judy.jpg")!,
                    UIImage(named: "judy.jpg")!,UIImage(named: "judy.jpg")!,UIImage(named: "judy.jpg")!]
        }
        
        let leftMargin:CGFloat = 5
        let topMargin:CGFloat = 5
        var top:CGFloat = topMargin
        var i:CGFloat = 0
        let imgWidth:CGFloat = 80
        var rightMargin:CGFloat = 0
        for index in 0..<bookImageList!.count{
            if((i*(imgWidth+leftMargin) + imgWidth + leftMargin) > self.view.frame.width){
                top += imgWidth + topMargin
                rightMargin = self.view.frame.width - (i*(imgWidth+leftMargin)+leftMargin)
                i = 0
            }
            let imgView = UIButton(frame: CGRectMake(i*(imgWidth + leftMargin) + leftMargin,top,imgWidth,imgWidth))
            imgView.setBackgroundImage(bookImageList![index], forState: .Normal)
            imgView.addTarget(self, action: "ViewPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
            foot?.addSubview(imgView)
            i++
        }
        foot?.frame = CGRectMake(rightMargin/2,tv.contentSize.height,tv.frame.width,tv.frame.height - tv.contentSize.height)
        //五角星评分
        star = HCSStarRatingView(frame: CGRectMake((foot?.frame.width)!/2 - 75 - rightMargin/2,(foot?.frame.height)! - 30,150,30))
        star!.maximumValue = 5
        star!.minimumValue = 0
        star!.value = 0
        star!.tintColor = UIColor.orangeColor()
        star!.addTarget(self, action: "setLevel:", forControlEvents: UIControlEvents.ValueChanged)
        foot?.addSubview(star!)
        //评分label
        scoreLabel = UILabel(frame: CGRectMake((foot?.frame.width)!/2 - 75 - rightMargin/2,(foot?.frame.height)! - 60,150,30))
        scoreLabel?.textAlignment = .Center
        scoreLabel?.font = UIFont.systemFontOfSize(25)
        scoreLabel?.textColor = star!.tintColor
        foot?.addSubview(scoreLabel!)
        foot?.alpha = 0
        foot?.hidden = false
        UIView.animateWithDuration(0.5) { () -> Void in
            self.foot?.alpha = 1
        }
    }
    
    func setLevel(st:HCSStarRatingView){
        var result = "F"
        switch st.value{
        case 1:
            result = "E"
            break
        case 2:
            result = "D"
            break
        case 3:
            result = "C"
            break
        case 4:
            result = "B"
            break
        case 5:
            result = "A"
            break
        default:
            break
        }
        scoreLabel?.text = result
    }
    
    func ViewPhoto(btn:UIButton){
        self.presentViewController(browser!, animated: true, completion: nil)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt((bookImageList?.count)!)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        return MWPhoto(image: bookImageList![Int(index)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = data![indexPath.row]
        if indexPath.row > 0{
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        getInfo(indexPath.row)
    }
    
    
}
