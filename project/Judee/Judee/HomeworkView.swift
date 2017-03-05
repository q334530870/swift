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
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.05)
        context?.setFillColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        //中边框线
        context?.move(to: CGPoint(x: 0, y: rect.size.height/2))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height/2))
        //下边框线
        context?.move(to: CGPoint(x: 0, y: rect.size.height-1))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height-1))
        context?.strokePath()
    }
    
    
}
