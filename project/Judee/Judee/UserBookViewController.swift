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
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default)
        //初始化照片浏览
        browser = MWPhotoBrowser(delegate: self)
        browser!.alwaysShowControls = false
        browser!.modalTransitionStyle = .crossDissolve
        //模拟数据
        data = ["1：语文书抄一遍","2：倒过来在抄一遍","3：用英语翻译一遍"]
        //初始化表格尾部
        foot = UIScrollView()
        foot?.isHidden = true
        tv.tableFooterView = foot!
    }
    
    func getInfo(_ index:Int){
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
            let imgView = UIButton(frame: CGRect(x: i*(imgWidth + leftMargin) + leftMargin,y: top,width: imgWidth,height: imgWidth))
            imgView.setBackgroundImage(bookImageList![index], for: UIControlState())
            imgView.addTarget(self, action: #selector(UserBookViewController.ViewPhoto(_:)), for: UIControlEvents.touchUpInside)
            foot?.addSubview(imgView)
            i += 1
        }
        foot?.frame = CGRect(x: rightMargin/2,y: tv.contentSize.height,width: tv.frame.width,height: tv.frame.height - tv.contentSize.height)
        //五角星评分
        star = HCSStarRatingView(frame: CGRect(x: (foot?.frame.width)!/2 - 75 - rightMargin/2,y: (foot?.frame.height)! - 30,width: 150,height: 30))
        star!.maximumValue = 5
        star!.minimumValue = 0
        star!.value = 0
        star!.tintColor = UIColor.orange
        star!.addTarget(self, action: #selector(UserBookViewController.setLevel(_:)), for: UIControlEvents.valueChanged)
        foot?.addSubview(star!)
        //评分label
        scoreLabel = UILabel(frame: CGRect(x: (foot?.frame.width)!/2 - 75 - rightMargin/2,y: (foot?.frame.height)! - 60,width: 150,height: 30))
        scoreLabel?.textAlignment = .center
        scoreLabel?.font = UIFont.systemFont(ofSize: 25)
        scoreLabel?.textColor = star!.tintColor
        foot?.addSubview(scoreLabel!)
        foot?.alpha = 0
        foot?.isHidden = false
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.foot?.alpha = 1
        }) 
    }
    
    func setLevel(_ st:HCSStarRatingView){
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
    
    func ViewPhoto(_ btn:UIButton){
        self.present(browser!, animated: true, completion: nil)
    }
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt((bookImageList?.count)!)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        return MWPhoto(image: bookImageList![Int(index)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = data![indexPath.row]
        if indexPath.row > 0{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        getInfo(indexPath.row)
    }
    
    
}
