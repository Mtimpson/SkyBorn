//
//  GameScene.swift
//  WW2 SkyBorn
//  Version 0.1
//
//  Created by Michael Timpson and Matthew Creel on 5/5/16.
//  Copyright (c) 2016 newBorn Software Development Company. All rights reserved.
//

import SpriteKit

// Added the physics structure Catagory..
// Phsics structure catagory.. EP1 Flappy
struct PhysicsCatagory {
    static let f_40 : UInt32 = 1
    static let enemyMig : UInt32 = 4
    static let missile : UInt32 = 2
    static let enemyMissile : UInt32 = 3
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var f_40 = SKSpriteNode()
    var bground = SKSpriteNode()
    var bground2 = SKSpriteNode()
    var text1 = SKTexture()
    var text2 = SKTexture()
    var enemyMig = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //needed for contact to register
        physicsWorld.contactDelegate = self
        
        // Spawn in your f_40 plane at the left middle of the screen!
        f_40 = SKSpriteNode(imageNamed: "heli")
        f_40.size = CGSize(width: 90, height: 20)
        f_40.position = CGPoint(x: self.frame.width / 2.5, y: self.frame.height / 2)
        f_40.physicsBody = SKPhysicsBody(rectangleOfSize: f_40.size)
        f_40.physicsBody?.categoryBitMask = PhysicsCatagory.f_40
        //0 means it will not bounce around when it collides with comething
        f_40.physicsBody?.collisionBitMask = 0
        f_40.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMig
        f_40.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMissile
        f_40.physicsBody?.affectedByGravity = true
        f_40.physicsBody?.dynamic = true
        f_40.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(f_40)
        
        if(f_40.position.y <= 0){
            NSLog("fallen")
            f_40.removeFromParent()
        }
        
                
        //makes 2 backgrounds for the illusion of movement
        text1 = SKTexture(imageNamed: "Bground")
        text2 = SKTexture(imageNamed: "Bground")
        
        bground = SKSpriteNode(texture: text1)
        bground.anchorPoint = CGPointZero
        bground.position = CGPointZero
        bground.zPosition = -5
        self.addChild(bground)
        
        bground2 = SKSpriteNode(texture: text2)
        bground2.anchorPoint = CGPointZero
        bground2.position = CGPointMake(bground2.size.width-1 , 0)
        bground2.zPosition = -5
        self.addChild(bground2)
        
   
        //calls the createEnemyMig function every 1 second. 1st arg is time interval
        _ = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(GameScene.createEnemyMig), userInfo: nil, repeats: true)
        
        //spwans a missile from the f-40. time interval is the 1st arg. will need to change to touch activation later
       // _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GameScene.spawnUserMissile), userInfo: nil, repeats: true)
        
    
        
    }
    
    //used to determine when collisions happen
    func didBeginContact(contact: SKPhysicsContact) {
        //thing 1 in a collision
        let body1 : SKPhysicsBody = contact.bodyA
        //thing 2 in a collision
        let body2 : SKPhysicsBody = contact.bodyB
        
        //check for f40 missile hitting a mig
        if((body1.categoryBitMask == PhysicsCatagory.enemyMig) && (body2.categoryBitMask == PhysicsCatagory.missile) || (body1.categoryBitMask == PhysicsCatagory.missile) && (body2.categoryBitMask == PhysicsCatagory.enemyMig)){
            
            migAndMissile(body1.node as! SKSpriteNode, missile: body2.node as! SKSpriteNode)
        }
        
        //check for friendly missile hitting an enemy missile
        if((body1.categoryBitMask == PhysicsCatagory.missile) && (body2.categoryBitMask == PhysicsCatagory.enemyMissile) || (body1.categoryBitMask == PhysicsCatagory.enemyMissile) && (body2.categoryBitMask == PhysicsCatagory.missile)){
            
            missileAndMissile(body1.node as! SKSpriteNode, enemyMissile: body2.node as! SKSpriteNode)
            
        }
        
        //check for the f40 being hit by enemy missile
        if((body1.categoryBitMask == PhysicsCatagory.f_40) && (body2.categoryBitMask == PhysicsCatagory.enemyMissile) || (body1.categoryBitMask == PhysicsCatagory.enemyMissile) && (body2.categoryBitMask == PhysicsCatagory.f_40)){
            
            f40AndMissile(body1.node as! SKSpriteNode, enemyMissile: body2.node as! SKSpriteNode)
            
        }
        
        //check for f40 hitting mig
        if((body1.categoryBitMask == PhysicsCatagory.f_40) && (body2.categoryBitMask == PhysicsCatagory.enemyMig) || (body1.categoryBitMask == PhysicsCatagory.enemyMig) && (body2.categoryBitMask == PhysicsCatagory.f_40)){
            
            f40AndMig(body1.node as! SKSpriteNode, enemyMig: body2.node as! SKSpriteNode)
        }



        
    }
    
    //call when mig collides with f-40 fire
    func migAndMissile(enemyMig: SKSpriteNode, missile: SKSpriteNode){
        enemyMig.removeFromParent()
        missile.removeFromParent()
        NSLog("Destory mig")
    }
    //call when f-40 missile collides with mig missile
    func missileAndMissile(missile: SKSpriteNode, enemyMissile: SKSpriteNode){
        missile.removeFromParent()
        enemyMissile.removeFromParent()
        NSLog("missile on missile")
    }
    //call when enemy missile hits our f-40
    func f40AndMissile(f_40: SKSpriteNode, enemyMissile: SKSpriteNode){
        f_40.removeFromParent()
        enemyMissile.removeFromParent()
        NSLog("hit by missile")
    }
    //call when mig collides with f-40 fire
    func f40AndMig(f_40: SKSpriteNode, enemyMig: SKSpriteNode){
        f_40.removeFromParent()
        enemyMig.removeFromParent()
        NSLog("hit by mig")
    }
    
    //spawns a blue missle on the f-40 moving right
    func spawnUserMissile(){
        let missile = SKSpriteNode(imageNamed: "missile")
        missile.zPosition = 1
        missile.position = CGPointMake(f_40.position.x, f_40.position.y)
        missile.size.height = 150
        missile.size.width = 80
        //moves the missile. last arg controls the speed (lower = faster) will replace this later
        let horizontalMove = SKAction.moveByX(self.size.width, y: 0, duration: 2.5)
        //deletes the missile once off the screen
        let doneMoving = SKAction.removeFromParent()
        missile.runAction(SKAction.sequence([horizontalMove, doneMoving]))
        
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: missile.size)
        missile.physicsBody?.categoryBitMask = PhysicsCatagory.missile
        missile.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMig
        missile.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMissile
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody?.dynamic = false
        missile.physicsBody?.usesPreciseCollisionDetection = true
        
        
        
        self.addChild(missile)
        
        //use line below to move missle non-horizontially. work out later
        //let missleMovement = SKAction.moveBy(<#T##delta: CGVector##CGVector#>, duration: <#T##NSTimeInterval#>)
        
    }
    
    //Function creates an enemyMig
    func createEnemyMig() {
        
       
        
        let enemyMigs = SKNode()
        let height = self.view!.frame.height
        
        //Load the enemy Mig 21
        enemyMig = SKSpriteNode(imageNamed: "MiG-21-Clean")
        //Set size of the Mig
        enemyMig.size = CGSize(width: 60, height: 70)
        //1.5 = 3/4 of Screen, 1.75 = Barley on Screen, 2.0 = Off the screen
        enemyMig.position = CGPoint(x: self.frame.width-200, y: CGFloat(arc4random()) % height)
        enemyMig.zPosition = 1
        //Add the enemy mig to the screen.
        enemyMigs.addChild(enemyMig)
        
        enemyMig.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(10, 5))
        enemyMig.physicsBody?.categoryBitMask = PhysicsCatagory.enemyMig
        enemyMig.physicsBody?.contactTestBitMask = PhysicsCatagory.missile
        enemyMig.physicsBody?.contactTestBitMask = PhysicsCatagory.f_40
        enemyMig.physicsBody?.affectedByGravity = false
        enemyMig.physicsBody?.dynamic = false
        enemyMig.physicsBody?.usesPreciseCollisionDetection = true
        
        
        self.addChild(enemyMigs)
        
        
        //moves migs accross the screen to the left
        let moveMig = SKAction.moveByX(-self.size.width, y: 0, duration: 4)
        //deletes mig once off screen
        let doneMoving = SKAction.removeFromParent()
        enemyMig.runAction(SKAction.sequence([moveMig, doneMoving]))
        
        
        
       _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(GameScene.enemyMissiles), userInfo: nil, repeats: false)

    }
    
    //creates a red missile from the migs that moves left
    func enemyMissiles(){
        let enemyMissile = SKSpriteNode(imageNamed: "enemyMissile")
        enemyMissile.zPosition = 1
        enemyMissile.position = CGPointMake(enemyMig.position.x, enemyMig.position.y)
        enemyMissile.size.height = 150
        enemyMissile.size.width = 80
        //moves the missile. last arg controls the speed (lower = faster)
        let enemyFire = SKAction.moveByX(-self.size.width, y: 0, duration: 2)
        //deletes red missile once off screen
        let doneMoving = SKAction.removeFromParent()
        enemyMissile.runAction(SKAction.sequence([enemyFire, doneMoving]))
        
        
        enemyMissile.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(7,2))
        enemyMissile.physicsBody?.categoryBitMask = PhysicsCatagory.enemyMissile
        enemyMissile.physicsBody?.contactTestBitMask = PhysicsCatagory.missile
        enemyMissile.physicsBody?.contactTestBitMask = PhysicsCatagory.f_40
        enemyMissile.physicsBody?.affectedByGravity = false
        enemyMissile.physicsBody?.dynamic = false
        enemyMissile.physicsBody?.usesPreciseCollisionDetection = true

        self.addChild(enemyMissile)
        
    }
    

    var touchingScreen = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
        touchingScreen = true
        f_40.physicsBody?.velocity = CGVector(dx: 0, dy: 150)
    }
    
    override func touchesCancelled(touches: Set<UITouch>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        touchingScreen = false
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        touchingScreen = false
    }
    
    //infinitely scrolls the background to the left.. Also fuctions the touch mechanic.
    override func update(currentTime: NSTimeInterval){
        if touchingScreen {
            f_40.physicsBody?.velocity = CGVector(dx: 0, dy: 140)
        }
        
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
}
