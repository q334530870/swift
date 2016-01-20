//
//  PopButton.swift
//  IDAI360
//
//  Created by YaoJ on 16/1/8.
//  Copyright © 2016年 YaoJ. All rights reserved.
//

import UIKit

class PopButton: UIButton {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        //缩放动画
        if let scale = self.pop_animationForKey("popButton") as? POPSpringAnimation{
            scale.toValue = NSValue(CGPoint:CGPointMake(0.7, 0.7))
        }
        else{
            let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale.toValue = NSValue(CGPoint:CGPointMake(0.7, 0.7))
            scale.springBounciness = 20
            scale.springSpeed = 18
            self.pop_addAnimation(scale, forKey: "popButton")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        //还原缩放动画
        if let scale = self.pop_animationForKey("popButton") as? POPSpringAnimation{
            scale.toValue = NSValue(CGPoint:CGPointMake(1, 1))
        }
        else{
            let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale.toValue = NSValue(CGPoint:CGPointMake(1, 1))
            scale.springBounciness = 20
            scale.springSpeed = 18
            self.pop_addAnimation(scale, forKey: "popButton")
        }
    }
    
}
