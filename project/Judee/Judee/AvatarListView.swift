//
//  avatarListView.swift
//  Judee
//
//  Created by YaoJ on 16/1/26.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class AvatarListView: UIScrollView {
    
    var bookDetail:BookDetailViewController?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.white
        //左边距
        var left:CGFloat = 0
        //上边距
        var top:CGFloat = 0
        //当前行数
        var line:CGFloat = 0
        //当前行数中当前图片的位置
        var index:CGFloat = 0
        //图片大小
        let size:CGFloat = 48
        //每块高度
        let height = size+15
        //名字label高度
        let nameHeight:CGFloat = 15
        //右边距
        var right:CGFloat = 0
        for i in 0..<10{
            left = CGFloat(index*height + 10)
            if(left + height) > UIScreen.main.bounds.width{
                //计算右边距，后面设置footView内容居中
                right = (UIScreen.main.bounds.width - left)
                //换行
                line += 1
                //换行后初始化当前行数中当前图片的位置
                index = 0
                //换行后初始化左边距
                left = 10
            }
            top = line * (height+nameHeight) + 15
            let v = UIView(frame: CGRect(x: left,y: top,width: size,height: size+nameHeight))
            let avatar = UIButton(frame: CGRect(x: 0,y: 0,width: size,height: size))
            avatar.tag = i
            avatar.layer.cornerRadius = size/2
            avatar.layer.masksToBounds = true
            avatar.setBackgroundImage(UIImage(named: "judy.jpg"), for: UIControlState())
            avatar.addTarget(bookDetail, action: "clickAvatar:", for: UIControlEvents.touchUpInside)
            v.addSubview(avatar)
            let label = UILabel(frame: CGRect(x: 0,y: size,width: size,height: nameHeight))
            label.text = "judy\(i)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            let hub = RKNotificationHub(view: v)
            hub?.scaleCircleSize(by: 0.7)
            hub?.increment(by: 3)
            //临时样式
            if(index.truncatingRemainder(dividingBy: 3) == 0){
                hub?.setCircleColor(MAIN_COLOR, label: UIColor.white)
            }
            v.addSubview(label)
            self.addSubview(v)
            index += 1
        }
        self.frame = CGRect(x: right/2,y: 0,width: UIScreen.main.bounds.width,height: top+height+nameHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func draw(_ rect: CGRect) {
        //        let context = UIGraphicsGetCurrentContext()
        //        CGContextSetLineWidth(context, 0.5)
        //        CGContextSetRGBFillColor(context, 231/255, 231/255, 231/255, 1)
        //        CGContextMoveToPoint(context, -10, 0)
        //        CGContextAddLineToPoint(context, rect.size.width, 0)
        //        CGContextStrokePath(context)
    }
}
