import spriteKit

class Background : SKNode {
    
    var nearArray = [SKSpriteNode]()
    
    var farArray = [SKSpriteNode]()
    
    override init() {
        super.init()
        
        var farTexture = SKTexture(imageNamed: "background_f1")
        
        var far0 = SKSpriteNode(texture: farTexture)
        far0.anchorPoint = CGPointMake(0, 0)
        far0.position.y = 150
        
        var far1 = SKSpriteNode(texture: farTexture)
        far1.anchorPoint = CGPointMake(0, 0)
        far1.position.x = far0.size.width
        far1.position.y = 150
        
        var far2 = SKSpriteNode(texture: farTexture)
        far2.anchorPoint = CGPointMake(0, 0)
        far2.position.x = far0.size.width*2
        far2.position.y = 150
        
        self.addChild(far0)
        self.addChild(far1)
        self.addChild(far2)
        farArray.append(far0)
        farArray.append(far1)
        farArray.append(far2)
        
        var nearTexture = SKTexture(imageNamed: "background_f0")
        
        var near0 = SKSpriteNode(texture: nearTexture)
        near0.anchorPoint = CGPointMake(0, 0)
        near0.position.y = 70
        
        var near1 = SKSpriteNode(texture: nearTexture)
        near1.anchorPoint = CGPointMake(0, 0)
        near1.position.x = near0.size.width
        near1.position.y = 70
        
        self.addChild(near0)
        self.addChild(near1)
        nearArray.append(near0)
        nearArray.append(near1)
    }
    
    func move(speed:CGFloat){
        
        for near in nearArray {
            near.position.x -= speed
        }
        if nearArray[0].position.x + nearArray[0].size.width < speed {
            nearArray[0].position.x = 0
            nearArray[1].position.x = nearArray[0].size.width
        }
        
        for far in farArray {
            far.position.x -= speed/4
        }
        if farArray[0].position.x + farArray[0].size.width < speed/4 {
            farArray[0].position.x = 0
            farArray[1].position.x = farArray[0].size.width
            farArray[2].position.x = farArray[0].size.width*2
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}