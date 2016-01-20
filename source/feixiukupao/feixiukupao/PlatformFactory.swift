import spritekit

class PlatformFactory : SKNode {
    
    let platformLeft = SKTexture(imageNamed: "platform_l")
    let platformMiddle = SKTexture(imageNamed: "platform_m")
    let platformRight = SKTexture(imageNamed: "platform_r")
    
    var mainScene:CGFloat = 0
    var delegate:protocolMainScene?
    
    var platforms = [Platform]()
    
    func createRandom(){
        var num = (Int)(arc4random() % 4 + 1)
        var gap = (CGFloat)(arc4random() % 10 + 1)
        var x = mainScene + gap + (CGFloat)(num * 50) + 100
        var y = (CGFloat)(arc4random() % 200 + 200)
        self.create(num, x: x, y: y)
    }
    
    func create(middleNum:Int, x:CGFloat, y:CGFloat){
        
        var platform_left = SKSpriteNode(texture: platformLeft)
        platform_left.anchorPoint = CGPointMake(0, 0.9)
        
        var platform_right = SKSpriteNode(texture: platformRight)
        platform_right.anchorPoint = CGPointMake(0, 0.9)
        
        var platformArray = [SKSpriteNode]()
        platformArray.append(platform_left)
        
        for i in 1...middleNum {
            var platform_middle = SKSpriteNode(texture: platformMiddle)
            platform_middle.anchorPoint = CGPointMake(0, 0.9)
            platformArray.append(platform_middle)
        }
        
        platformArray.append(platform_right)
        
        var platform = Platform()
        platform.position = CGPointMake(x, y)
        platform.create(platformArray)
        self.addChild(platform)
        
        platforms.append(platform)
        
        delegate?.getData(platform.width + x - mainScene)
    }
    
    func move (speed:CGFloat){
        for pf in platforms {
            pf.position.x -= speed
        }
        if platforms[0].position.x < -platforms[0].width {
            platforms[0].removeFromParent()
            platforms.removeAtIndex(0)
        }
    }
}
