//
//  DrawLineTest.swift
//  IDAI360
//
//  Created by YaoJ on 16/1/22.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class DrawLineTest: UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetRGBFillColor(context, 231/255, 231/255, 231/255, 1)
        CGContextMoveToPoint(context, 8, 0)
        CGContextAddLineToPoint(context, rect.size.width - 8, 0)
        CGContextStrokePath(context)
    }
    
}
