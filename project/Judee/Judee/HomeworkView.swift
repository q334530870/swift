//
//  HomeworkView.swift
//  Judee
//
//  Created by YaoJ on 16/1/28.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class HomeworkView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.05)
        CGContextSetRGBFillColor(context, 230/255, 230/255, 230/255, 1)
        //中边框线
        CGContextMoveToPoint(context, 0, rect.size.height/2)
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2)
        //下边框线
        CGContextMoveToPoint(context, 0, rect.size.height-1)
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-1)
        CGContextStrokePath(context)
    }
    
    
}
