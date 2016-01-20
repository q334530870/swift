import spriteKit

class Platform:SKNode {
    
    var width:CGFloat = 0.0
    var height:CGFloat = 10
    
    func create(platforms:[SKSpriteNode]){
        for pf in platforms {
            pf.position.x = self.width
            self.addChild(pf)
            self.width += pf.size.width
        }
    }
    
}
