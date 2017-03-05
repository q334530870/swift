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
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.05)
        context?.setFillColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        //上边框线
        context?.move(to: CGPoint(x: 14, y: 1))
        context?.addLine(to: CGPoint(x: rect.size.width, y: 1))
        //第一行竖线
        context?.move(to: CGPoint(x: 60, y: 1))
        context?.addLine(to: CGPoint(x: 60, y: rect.size.height/2))
        //中边框线
        context?.move(to: CGPoint(x: 14, y: rect.size.height/2))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height/2))
        //第二行竖线
        context?.move(to: CGPoint(x: 60, y: rect.size.height/2))
        context?.addLine(to: CGPoint(x: 60, y: rect.size.height-1))
        //下边框线
        context?.move(to: CGPoint(x: 14, y: rect.size.height-1))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height-1))
        context?.strokePath()
    }
    
    
}
