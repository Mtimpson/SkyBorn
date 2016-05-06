//
//  GameScene.swift
//  WW2 SkyBorn
//  Version 0.1
//
//  Created by Michael Timpson and Matthew Creel on 5/5/16.
//  Copyright (c) 2016 newBorn Software Development Company. All rights reserved.
//

import SpriteKit

//Phsics structure catagory.. EP1 Flappy
struct PhysicsCatagory {
    static let f_40 : UInt32 = 0x1 << 1
    static let enemyMig : UInt32 = 0x1 << 2
    
}

class GameScene: SKScene {
    
    var f_40 = SKSpriteNode()
    var bground = SKSpriteNode()
    var bground2 = SKSpriteNode()
    var text1 = SKTexture()
    var text2 = SKTexture()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Spawn in your f_40 plane at the left middle of the screen!
        f_40 = SKSpriteNode(imageNamed: "F-40-Clean")
        f_40.size = CGSize(width: 60, height: 70)
        f_40.position = CGPoint(x: self.frame.width / 2 - f_40.frame.width, y: self.frame.height / 2)
        f_40.physicsBody = SKPhysicsBody(circleOfRadius: f_40.frame.width / 2)
        f_40.physicsBody?.categoryBitMask = PhysicsCatagory.f_40
        f_40.physicsBody?.collisionBitMask = PhysicsCatagory.enemyMig
        f_40.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMig
        f_40.physicsBody?.affectedByGravity = true
        f_40.physicsBody?.dynamic = true
        
        self.addChild(f_40)
        
        // Every call to the mig fuction will spawn a new Mig!
        createEnemyMig()
        createEnemyMig()
        createEnemyMig()
        
        text1 = SKTexture(imageNamed: "Bground")
        text2 = SKTexture(imageNamed: "Bground")
        
        bground = SKSpriteNode(texture: text1)
        bground.anchorPoint = CGPointZero
        bground.position = CGPointZero
        bground.zPosition = -1
        self.addChild(bground)
        
        bground2 = SKSpriteNode(texture: text2)
        bground2.anchorPoint = CGPointZero
        bground2.position = CGPointMake(bground2.size.width-1 , 0)
        bground2.zPosition = -1
        self.addChild(bground2)
    
        
    }
    
    override func update(currentTime: NSTimeInterval){
        // 4 controls the speed below
        bground.position = CGPoint(x: bground.position.x-6 , y: bground.position.y)
        bground2.position = CGPoint(x: bground2.position.x-6, y: bground2.position.y)
        
        if(bground.position.x < -bground.size.width+200){
            bground.position = CGPointMake(bground2.position.x + bground2.size.width, bground.position.y)
        }
        
        if(bground2.position.x < -bground2.size.width+200){
            bground2.position = CGPointMake(bground.position.x + bground.size.width, bground2.position.y)
        }

    }
    
    //Function creates an enemyMig
    func createEnemyMig() {
        
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        let enemyMigs = SKNode()
        let height = self.view!.frame.height
        
        //Load the enemy Mig 21
        let enemyMig = SKSpriteNode(imageNamed: "MiG-21-Clean")
        //Set size of the Mig
        enemyMig.size = CGSize(width: 60, height: 70)
        //1.5 = 3/4 of Screen, 1.75 = Barley on Screen, 2.0 = Off the screen
        enemyMig.position = CGPoint(x: screenSize.width * 1.5 , y: CGFloat(arc4random()) % height)
        
        //Add the enemy mig to the screen.
        enemyMigs.addChild(enemyMig)
        
        
        self.addChild(enemyMigs)

    
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        // The higher the "60" the higher the plane will 'jump'!
        f_40.physicsBody?.velocity = CGVectorMake(0, 0)
        f_40.physicsBody?.applyImpulse(CGVectorMake(0, 60))
    }
   
   // override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    //}
}
