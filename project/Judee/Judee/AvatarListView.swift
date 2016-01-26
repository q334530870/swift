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
        self.backgroundColor = UIColor.whiteColor()
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
            if(left + height) > UIScreen.mainScreen().bounds.width{
                //计算右边距，后面设置footView内容居中
                right = (UIScreen.mainScreen().bounds.width - left)
                //换行
                line++
                //换行后初始化当前行数中当前图片的位置
                index = 0
                //换行后初始化左边距
                left = 10
            }
            top = line * (height+nameHeight) + 15
            let v = UIView(frame: CGRectMake(left,top,size,size+nameHeight))
            let avatar = UIButton(frame: CGRectMake(0,0,size,size))
            avatar.tag = i
            avatar.layer.cornerRadius = size/2
            avatar.layer.masksToBounds = true
            avatar.setBackgroundImage(UIImage(named: "judy.jpg"), forState: UIControlState.Normal)
            avatar.addTarget(bookDetail, action: "clickAvatar:", forControlEvents: UIControlEvents.TouchUpInside)
            v.addSubview(avatar)
            let label = UILabel(frame: CGRectMake(0,size,size,nameHeight))
            label.text = "judy\(i)"
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(12)
            let hub = RKNotificationHub(view: v)
            hub.scaleCircleSizeBy(0.7)
            hub.incrementBy(3)
            //临时样式
            if(index%3 == 0){
                hub.setCircleColor(MAIN_COLOR, labelColor: UIColor.whiteColor())
            }
            v.addSubview(label)
            self.addSubview(v)
            index++
        }
        self.frame = CGRectMake(right/2,0,UIScreen.mainScreen().bounds.width,top+height+nameHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func drawRect(rect: CGRect) {
        //        let context = UIGraphicsGetCurrentContext()
        //        CGContextSetLineWidth(context, 0.5)
        //        CGContextSetRGBFillColor(context, 231/255, 231/255, 231/255, 1)
        //        CGContextMoveToPoint(context, -10, 0)
        //        CGContextAddLineToPoint(context, rect.size.width, 0)
        //        CGContextStrokePath(context)
    }
}
