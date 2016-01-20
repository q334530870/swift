import spriteKit

enum Status:Int{
    case run=1 , jump , jump2 , roll
}

class Feixiu : SKSpriteNode {
    let a = ""
    let runAtlas = SKTextureAtlas(named: "run.atlas")
    let runFrames = [SKTexture]()
    
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    let jumpFrames = [SKTexture]()
    
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    let rollFrames = [SKTexture]()
    
    var status = Status.run
    
    override init(){
        let texture = runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        super.init(texture: texture, color: UIColor.whiteColor(), size: size)
        
        for var i = 1; i < runAtlas.textureNames.count; i++ {
            var temp = String(format: "panda_run_%.2d",i)  //.2d：两位数
            var runTexture = runAtlas.textureNamed(temp)
            if runTexture != nil {
                runFrames.append(runTexture)
            }
        }
        
        for var i = 1; i < jumpAtlas.textureNames.count; i++ {
            var temp = String(format: "panda_jump_%.2d",i)  //.2d：两位数
            var jumpTexture = jumpAtlas.textureNamed(temp)
            if jumpTexture != nil {
                jumpFrames.append(jumpTexture)
            }
        }
        
        for var i = 1; i < rollAtlas.textureNames.count; i++ {
            var temp = String(format: "panda_roll_%.2d",i)  //.2d：两位数
            var rollTexture = rollAtlas.textureNamed(temp)
            if rollTexture != nil {
                rollFrames.append(rollTexture)
            }
        }
        
        run()
    }
    
    func run(){
        self.removeAllActions()
        self.status = .run
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runFrames, timePerFrame: 0.05)))
    }
    
    func jump(){
        self.removeAllActions()
        self.status = .jump
        self.runAction(SKAction.animateWithTextures(jumpFrames, timePerFrame: 0.05))
    }
    
    func roll(){
        self.removeAllActions()
        self.status = .roll
        self.runAction(SKAction.animateWithTextures(rollFrames, timePerFrame: 0.05),completion:{() in
            self.run()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}