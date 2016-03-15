//
//  EnterpriseTableViewController.swift
//  IDAI360
//
//  Created by YaoJ on 16/2/26.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class EnterpriseTableViewController: UITableViewController,MWPhotoBrowserDelegate{
    
    var productId:Int = 0
    var titleList = [(title:String,value:String)]()
    var browser:MWPhotoBrowser?
    var imageList = [UIImage?]()
    var photo = [MWPhoto]()
    var model:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleList = [("注册资本",model!["RegisteredCapital"].stringValue),("净 资 产",model!["NetAssets"].stringValue),("所属行业",model!["Industry"].stringValue),("近两年销售额",model!["SalesTurnoverForLast2Years"].stringValue),("法人代表",model!["Representative"].stringValue),("企业介绍",model!["GeneralIntroduction"].stringValue)]
        getData()
    }
    
    func getData() {
        //测试
        let dataList = [NSData(contentsOfURL: NSURL(string: MAIN_URL + model!["FundRaiserImages"][0].stringValue)!),
            NSData(contentsOfURL: NSURL(string: MAIN_URL + model!["FundRaiserImages"][1].stringValue)!),
            NSData(contentsOfURL: NSURL(string: MAIN_URL + model!["FundRaiserImages"][2].stringValue)!)]
        imageList =  [
            dataList[0] == nil ? UIImage() : UIImage(data:dataList[0]!),
            dataList[1] == nil ? UIImage() :UIImage(data: dataList[1]!),
            dataList[2] == nil ? UIImage() :UIImage(data: dataList[2]!)]
        
        photo =  [
            MWPhoto(image: imageList[0]),
            MWPhoto(image: imageList[1]),
            MWPhoto(image: imageList[2])]
        
        photo[0].caption = "管理层申明"
        photo[1].caption = "审计报告"
        photo[2].caption = "律师信"
        
        let footView = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.width/3+10))
        let width = self.view.frame.width/3 - 10
        
        let image1 = UIButton(frame: CGRectMake(5,10,width,width))
        image1.setBackgroundImage(imageList[0], forState: UIControlState.Normal)
        image1.tag = 0
        image1.addTarget(self, action: "ViewPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let image2 = UIButton(frame: CGRectMake(10+(width+5),10,width,width))
        image2.setBackgroundImage(imageList[1], forState: UIControlState.Normal)
        image2.tag = 1
        image2.addTarget(self, action: "ViewPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let image3 = UIButton(frame: CGRectMake(15+(width+5)*2,10,width,width))
        image3.setBackgroundImage(imageList[2], forState: UIControlState.Normal)
        image3.tag = 2
        image3.addTarget(self, action: "ViewPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        footView.addSubview(image1)
        footView.addSubview(image2)
        footView.addSubview(image3)
        self.tableView.tableFooterView = footView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScrollCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = titleList[indexPath.row].title
        cell.detailTextLabel!.text = titleList[indexPath.row].value
        return cell
    }
    
    
    func ViewPhoto(btn:UIButton){
        //初始化照片浏览
        browser = MWPhotoBrowser(delegate: self)
        browser!.modalTransitionStyle = .CrossDissolve
        browser!.alwaysShowControls = true
        browser!.displayNavArrows = true
        browser?.setCurrentPhotoIndex(UInt(btn.tag))
        self.presentViewController(browser!, animated: true, completion: nil)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt((photo.count))
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(self.photo.count) {
            return self.photo[Int(index)]
        }
        return nil
    }
    
}
