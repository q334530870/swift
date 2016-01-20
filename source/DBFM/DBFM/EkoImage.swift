
import UIKit

class EkoImage: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //设置圆角
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
        //设置边框
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
    }
    //旋转动画
    func onRotation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = M_PI * 2.0
        animation.duration = 20
        animation.repeatCount = 10_000
        self.layer.addAnimation(animation, forKey: nil)
    }
    
}
