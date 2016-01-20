//
//  GameScene.swift
//  feixiukupao
//
//  Created by YaoJ on 15/1/14.
//  Copyright (c) 2015年 YaoJ. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,protocolMainScene,SKPhysicsContactDelegate{
    
    lazy var feixiu = Feixiu()
    lazy var platformFactory = PlatformFactory()
    lazy var background = Background()
    
    var moveSpeed:CGFloat = 8
    var dist:CGFloat = 0
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = Sign.scene
        self.physicsBody?.dynamic = false
        
        let backgroundColor = SKColor(red: 240/255, green: 255/255, blue: 255/255, alpha: 1)
        self.backgroundColor = backgroundColor
        feixiu.position = CGPoint(x: 200, y: 400)
        self.addChild(feixiu)
        self.addChild(platformFactory)
        self.addChild(background)
        platformFactory.delegate = self
        platformFactory.mainScene = self.size.width
        self.platformFactory.create(3, x: 0, y: 300)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if feixiu.status == Status.run {
            feixiu.jump()
        }
        else if feixiu.status == Status.jump {
            feixiu.roll()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        background.move(moveSpeed/4)
        self.dist -= moveSpeed
        if self.dist <= 0 {
            //self.platformFactory.create(1, x: self.size.width+20, y: 300)
            self.platformFactory.createRandom()
        }
        platformFactory.move(moveSpeed)
    }
    
    func getData(dist: CGFloat) {
        self.dist = dist
    }
    
}

protocol protocolMainScene {
    func getData(dist:CGFloat)
}