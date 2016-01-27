//
//  LoginView.swift
//  Judee
//
//  Created by YaoJ on 16/1/27.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.05)
        CGContextSetRGBFillColor(context, 230/255, 230/255, 230/255, 1)
        //上边框线
        CGContextMoveToPoint(context, 14, 1)
        CGContextAddLineToPoint(context, rect.size.width, 1)
        //第一行竖线
        CGContextMoveToPoint(context, 60, 1)
        CGContextAddLineToPoint(context, 60, rect.size.height/2)
        //中边框线
        CGContextMoveToPoint(context, 14, rect.size.height/2)
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2)
        //第二行竖线
        CGContextMoveToPoint(context, 60, rect.size.height/2)
        CGContextAddLineToPoint(context, 60, rect.size.height-1)
        //下边框线
        CGContextMoveToPoint(context, 14, rect.size.height-1)
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-1)
        CGContextStrokePath(context)
    }
    
    
}
