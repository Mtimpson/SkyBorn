//
//  GameScene.swift
//  SkyBorn
//  Version 1.0
//
//  Created by Michael Timpson, Matthew Creel & Ben Brott on 5/5/16.
//  Copyright (c) 2016 newBorn Software Development Company. All rights reserved.
//

import SpriteKit


var chopper : SKSpriteNode!
var explosion : SKSpriteNode!

var chopperWalkingFrames: [SKTexture]!
var explosionWalkingFrames: [SKTexture]!


// Added the physics structure Catagory..
// Phsics structure catagory.. EP1 Flappy
struct PhysicsCatagory {
    static let f_40 : UInt32 = 1
    static let enemyMig : UInt32 = 2
    static let userMissile : UInt32 = 4
    static let enemyMissile : UInt32 = 8
    static let scoreWall : UInt32 = 16
    static let ground : UInt32 = 32
    static let ceiling : UInt32 = 64
   
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCatagory {
        static let f_40 : UInt32 = 1
        static let enemyMig : UInt32 = 2
        static let userMissile : UInt32 = 4
        static let enemyMissile : UInt32 = 8
        static let scoreWall : UInt32 = 16
        static let ground : UInt32 = 32
        static let ceiling : UInt32 = 64
        
    }

    var started = false
    var finished = false
    
    var nothingBtn : UIButton!
    var avgScore : Int!
    var totalGames : Int!
    var hitCounter = Int()
    var score = Int()
    var f_40 = SKSpriteNode()
    var explosion = SKSpriteNode()
    var bground = SKSpriteNode()
    var bground2 = SKSpriteNode()
    var text1 = SKTexture()
    var text2 = SKTexture()
    var enemyMig = SKSpriteNode()
    var missile = SKSpriteNode()
    var enemyMissile = SKSpriteNode()
    var start : UIButton!
    var moveBackground = false
    var scoreWall = SKShapeNode()
    var ground = SKShapeNode()
    var ceiling = SKShapeNode()
    var scoreLabel : UILabel!
    var hitLabel : UILabel!
    var total : UILabel!
    var totalScore = Int()
    var highscoreLabel : UILabel!
    var fireBtn : UIButton!
    //array of highscores to be accessible in the StartScene
    var highscoresArr : [NSInteger] = [NSInteger](count: 10, repeatedValue: 0)
    var shotsFired: Int!
    var totalHits : Int!
    var totalEvasions : Int!
    var allTimeScore : Int!
    var hitPercent : Double!
    var localShots = Int()
    
    
    var missiles : [SKSpriteNode] = []
    
   
    //endscene variables
    //button variables
    var restart : UIButton!
    var menu : UIButton!
    var gameOver : UILabel!

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
                
        //needed for contact to register
        physicsWorld.contactDelegate = self
        
        //acts as the ground to detect collisions when flying too low
        ground = SKShapeNode(rectOfSize: CGSizeMake(self.frame.width * 2, 5))
        ground.fillColor = UIColor.whiteColor()
        ground.position = CGPoint(x: 0, y: self.frame.height * 0.075)
        ground.zPosition = -10
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.width * 2, height: 5))
        ground.physicsBody?.categoryBitMask = PhysicsCatagory.ground
        ground.physicsBody?.collisionBitMask = 0
        ground.physicsBody?.contactTestBitMask = PhysicsCatagory.f_40
        ground.physicsBody?.dynamic = true
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(ground)
        
        //acts as the ceiling to detect collisions when flying to high
        ceiling = SKShapeNode(rectOfSize: CGSizeMake(self.frame.width * 2, 5))
        ceiling.fillColor = UIColor.whiteColor()
        ceiling.position = CGPoint(x: 0, y: self.frame.height)
        ceiling.zPosition = -10
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.width * 2, height: 5))
        ceiling.physicsBody?.categoryBitMask = PhysicsCatagory.ceiling
        ceiling.physicsBody?.collisionBitMask = 0
        ceiling.physicsBody?.contactTestBitMask = PhysicsCatagory.f_40
        ceiling.physicsBody?.dynamic = true
        ceiling.physicsBody?.affectedByGravity = false
        ceiling.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(ceiling)
        
        
        //invisible wall at the x coordinate of the user, when enemy objects pass thru it score will increase
        scoreWall = SKShapeNode(rectOfSize: CGSizeMake(5, self.frame.height * 2))
        scoreWall.fillColor = UIColor.whiteColor()
        scoreWall.position = CGPoint(x: self.frame.width / 2.75, y: 0)
        scoreWall.zPosition = -10
        scoreWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 5, height: self.frame.height * 2))
        scoreWall.physicsBody?.categoryBitMask = PhysicsCatagory.scoreWall
        scoreWall.physicsBody?.collisionBitMask = 0
        scoreWall.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMissile | PhysicsCatagory.enemyMig
        scoreWall.physicsBody?.dynamic = true
        scoreWall.physicsBody?.affectedByGravity = false
        scoreWall.physicsBody?.usesPreciseCollisionDetection = true
        
        
        self.addChild(scoreWall)
        
        //label to track number of enemy objects avoided
        scoreLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 20))
        scoreLabel.text = "Evasions: \(score)"
        scoreLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 15)
        scoreLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(scoreLabel)
        
        //label to track number of enemy objects hit by missiles
        hitLabel = UILabel(frame: CGRect(x: 100, y: 0, width: 100, height: 20))
        hitLabel.text = "Hits: \(hitCounter)"
        hitLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 15)
        hitLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(hitLabel)
        
        //adds something behind the fireBtn so that you do not fall if you push fire too fast
        nothingBtn = UIButton(type: .Custom)
        nothingBtn.frame = CGRectMake(10, view.frame.height - 10 - 100, 100, 100)
        nothingBtn.layer.cornerRadius = 0.5 * nothingBtn.bounds.size.width
        //nothingBtn.addTarget(self, action: #selector(GameScene.startPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        nothingBtn.layer.zPosition = 10
        self.view?.addSubview(nothingBtn)
        
        
        // Fire button
        fireBtn = UIButton(type: .Custom)
        fireBtn.frame = CGRectMake(10, view.frame.height - 10 - 100, 100, 100)
        fireBtn.layer.cornerRadius = 0.5 * fireBtn.bounds.size.width
        fireBtn.setTitle("Fire", forState: UIControlState.Normal)
        fireBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        fireBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        fireBtn.addTarget(self, action: #selector(GameScene.firedMissile), forControlEvents: UIControlEvents.TouchUpInside)
        fireBtn.layer.borderWidth = 2
        fireBtn.layer.borderColor = UIColor.whiteColor().CGColor
        fireBtn.backgroundColor = UIColor.lightTextColor()
        fireBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 40)
        fireBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        fireBtn.layer.zPosition = 11
        
        self.view?.addSubview(fireBtn)
        self.fireBtn.enabled = false
        fireBtn.userInteractionEnabled = false
        
        
        //allows the fire button to be pushed every (1st arg) seconds
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GameScene.enableFireBtn), userInfo: nil, repeats: true)
        
        
       

        
        // Load the TextureAtlas for the chopper blades
        let chopperAnimatedAtlas : SKTextureAtlas = SKTextureAtlas(named: "Chopper")
        
        // Load the animation frames from the TextureAtlas
        var bladeFrames = [SKTexture]();
        let numImages : Int = chopperAnimatedAtlas.textureNames.count
        for i in 1...(numImages/2) {
            let chopperTextureName = "chopper\(i)"
            bladeFrames.append(chopperAnimatedAtlas.textureNamed(chopperTextureName))
        }
        
        chopperWalkingFrames = bladeFrames
        
        // Create Chopper Sprite, Setup Position in middle of the screen, add to Scene
        let temp : SKTexture = chopperWalkingFrames[0]
        f_40 = SKSpriteNode(texture: temp)
        f_40.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidX(self.frame))
        //addChild(chopper)
        
        spinChopper()
        
        self.addChild(f_40)
        
        // Load the TextureAtlas for the explosion
        let explosionAnimatedAtlas : SKTextureAtlas = SKTextureAtlas(named: "Explosion")
        
        // Load the animation frames from the TextureAtlas
        var explosionFrames = [SKTexture]();
        let numOfImages : Int = explosionAnimatedAtlas.textureNames.count
        for i in 1...numOfImages {
            let explosionTextureName = "explosion\(i)"
            explosionFrames.append(explosionAnimatedAtlas.textureNamed(explosionTextureName))
        }
        
        explosionWalkingFrames = explosionFrames
        
        //Create Explosion Sprite, Setup Position in the middle of the screen, add to Scene
        //let temp2 : SKTexture = explosionWalkingFrames[0]
        //explosion = SKSpriteNode(texture: temp2)
        //explosion.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidX(self.frame))
        
        explode()
        
        self.addChild(explosion)

       
        
        // Spawn in your f_40 plane at the left middle of the screen!
        //f_40 = SKSpriteNode(imageNamed:"chopper1")
        f_40.size = CGSize(width: 90, height: 25)
        f_40.position = CGPoint(x: self.frame.width / 2.75, y: self.frame.height / 2)
        f_40.zPosition = 1
        f_40.physicsBody = SKPhysicsBody(rectangleOfSize: f_40.size)
        f_40.physicsBody?.categoryBitMask = PhysicsCatagory.f_40
        // 0 means it will not bounce around when it collides with comething
        f_40.physicsBody?.collisionBitMask = 0
        f_40.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMig | PhysicsCatagory.enemyMissile | PhysicsCatagory.ground
        f_40.physicsBody?.affectedByGravity = false
        f_40.physicsBody?.dynamic = true
        f_40.physicsBody?.usesPreciseCollisionDetection = true
        
                
        //makes 2 backgrounds for the illusion of movement
        text1 = SKTexture(imageNamed: "desert")
        text2 = SKTexture(imageNamed: "desert")
        
        
        let width = self.size.width
        let height = self.size.height
        
        let text3 = SKTexture(imageNamed: "desertSky")
        let sky = SKSpriteNode(texture: text3, size: CGSize(width: width, height: height))
        sky.anchorPoint = CGPoint(x: 0, y: -0.07)
        sky.zPosition = -10
        self.addChild(sky)
       
        
        bground = SKSpriteNode(texture: text1)
        bground.anchorPoint = CGPointZero
       
        bground.size.width = width
        bground.position = CGPointZero
        bground.zPosition = -5
        self.addChild(bground)
        
        bground2 = SKSpriteNode(texture: text2)
        bground2.anchorPoint = CGPointZero

        bground2.size.width = width
        bground2.position = CGPointMake(bground2.size.width-1 , 0)
        bground2.zPosition = -5
        self.addChild(bground2)
        
        //adds start button
        start = UIButton((frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10)))
        start.center = CGPoint(x: view.center.x, y: view.center.y - 15)
        start.setTitle("Press to Start!", forState: UIControlState.Normal)
        start.titleLabel!.font = UIFont(name: "AvenirNextCondensed-Bold", size: 30)
        start.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        start.addTarget(self, action: #selector(GameScene.startPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(start)
    }
    
    func startPressed() {
        // DO NOTHING
    }
    
    func explode(){
        // General runAction method to make explosions occur
        let Explode = (SKAction.repeatAction(SKAction.animateWithTextures(explosionWalkingFrames, timePerFrame: 0.07), count: 1))
        let finished = SKAction.removeFromParent()
        explosion.runAction(SKAction.sequence([Explode, finished]))
        
    }
    
    func spinChopper() {
        // General runAction method to make the chopper blades spin.
        f_40.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(chopperWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)))
    }
    
    //used to determine when collisions happen
    func didBeginContact(contact: SKPhysicsContact) {
        //thing 1 in a collision
        let body1 : SKPhysicsBody = contact.bodyA
        //thing 2 in a collision
        let body2 : SKPhysicsBody = contact.bodyB
        
        let contactPos = contact.contactPoint
        
        //check for f40 missile hitting a mig
        if((body1.categoryBitMask == PhysicsCatagory.enemyMig) && (body2.categoryBitMask == PhysicsCatagory.userMissile) || (body1.categoryBitMask == PhysicsCatagory.userMissile) && (body2.categoryBitMask == PhysicsCatagory.enemyMig)){
            
            if(body1.node != nil && body2.node != nil) {
                migAndMissile(body1.node as! SKSpriteNode, userMissile: body2.node as! SKSpriteNode)
                
                let temp2 : SKTexture = explosionWalkingFrames[0]
                explosion = SKSpriteNode(texture: temp2)
                explosion.position = (contactPos)
                
                explode()
                
                self.addChild(explosion)
            }
        }
        
        //check for friendly missile hitting an enemy missile
        if((body1.categoryBitMask == PhysicsCatagory.userMissile) && (body2.categoryBitMask == PhysicsCatagory.enemyMissile) || (body1.categoryBitMask == PhysicsCatagory.enemyMissile) && (body2.categoryBitMask == PhysicsCatagory.userMissile)){
            
            if(body1.node != nil && body2.node != nil) {
                missileAndMissile(body1.node as! SKSpriteNode, enemyMissile: body2.node as! SKSpriteNode)
                
                let temp2 : SKTexture = explosionWalkingFrames[0]
                explosion = SKSpriteNode(texture: temp2)
                explosion.position = (contactPos)
                
                explode()
                
                self.addChild(explosion)
            }
            
        }
        
        //check for the f40 being hit by enemy missile
        if((body1.categoryBitMask == PhysicsCatagory.f_40) && (body2.categoryBitMask == PhysicsCatagory.enemyMissile) || (body1.categoryBitMask == PhysicsCatagory.enemyMissile) && (body2.categoryBitMask == PhysicsCatagory.f_40)){
            
            if(body1.node != nil && body2.node != nil) {
                f40AndMissile(body1.node as! SKSpriteNode, enemyMissile: body2.node as! SKSpriteNode)
                
                let temp2 : SKTexture = explosionWalkingFrames[0]
                explosion = SKSpriteNode(texture: temp2)
                explosion.position = (contactPos)
                
                explode()
                
                self.addChild(explosion)
            }
            
        }
        
        //check for f40 hitting mig
        if((body1.categoryBitMask == PhysicsCatagory.f_40) && (body2.categoryBitMask == PhysicsCatagory.enemyMig) || (body1.categoryBitMask == PhysicsCatagory.enemyMig) && (body2.categoryBitMask == PhysicsCatagory.f_40)){
            
            if(body1.node != nil && body2.node != nil) {
                f40AndMig(body1.node as! SKSpriteNode, enemyMig: body2.node as! SKSpriteNode)
                
                let temp2 : SKTexture = explosionWalkingFrames[0]
                explosion = SKSpriteNode(texture: temp2)
                explosion.position = (contactPos)
                
                explode()
                
                self.addChild(explosion)
            }
        }
        
        //check for enemyMissile or mig passing the user
        if((body1.categoryBitMask == PhysicsCatagory.scoreWall) && (body2.categoryBitMask == PhysicsCatagory.enemyMissile) || (body1.categoryBitMask == PhysicsCatagory.enemyMissile) && (body2.categoryBitMask == PhysicsCatagory.scoreWall)){
        
            addToScore()
        }
        if((body1.categoryBitMask == PhysicsCatagory.scoreWall) && (body2.categoryBitMask == PhysicsCatagory.enemyMig) || (body1.categoryBitMask == PhysicsCatagory.enemyMig) && (body2.categoryBitMask == PhysicsCatagory.scoreWall)){
            
            addToScore()
        }
        
        //check for user hitting the ground
        if((body1.categoryBitMask == PhysicsCatagory.ground) && (body2.categoryBitMask == PhysicsCatagory.f_40) || (body1.categoryBitMask == PhysicsCatagory.f_40) && (body2.categoryBitMask == PhysicsCatagory.ground)){
            
            hitGround()
            
            let temp2 : SKTexture = explosionWalkingFrames[0]
            explosion = SKSpriteNode(texture: temp2)
            explosion.position = (contactPos)
            
            explode()
            
            self.addChild(explosion)
        }
        
        //check for flying above the screen
        if((body1.categoryBitMask == PhysicsCatagory.ceiling) && (body2.categoryBitMask == PhysicsCatagory.f_40) || (body1.categoryBitMask == PhysicsCatagory.f_40) && (body2.categoryBitMask == PhysicsCatagory.ceiling)){
            
            hitCeiling()
            
            let temp2 : SKTexture = explosionWalkingFrames[0]
            explosion = SKSpriteNode(texture: temp2)
            explosion.position = (contactPos)
            
            explode()
            
            self.addChild(explosion)
        }


    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
    
    //call to increase score
    func addToScore(){
        score += 1
        scoreLabel.text = "Evasions: \(score)"
    }
    
    //call when mig collides with f-40 fire
    func migAndMissile(enemyMig: SKSpriteNode, userMissile: SKSpriteNode){
        enemyMig.removeFromParent()
        userMissile.removeFromParent()
        NSLog("Destoryed mig")
        if !finished {
            hitCounter += 10
            hitLabel.text = "Hits: \(hitCounter)"
        }
    }
    //call when f-40 missile collides with mig missile
    func missileAndMissile(userMissile: SKSpriteNode, enemyMissile: SKSpriteNode){
        userMissile.removeFromParent()
        enemyMissile.removeFromParent()
        NSLog("missile on missile")
        if !finished {
            hitCounter += 10
            hitLabel.text = "Hits: \(hitCounter)"
        }

    }
    //call when enemy missile hits our f-40
    func f40AndMissile(f_40: SKSpriteNode, enemyMissile: SKSpriteNode){
        f_40.removeFromParent()
        enemyMissile.removeFromParent()
        NSLog("hit by missile")
        endGame()
    }
    //call when mig collides with f-40
    func f40AndMig(f_40: SKSpriteNode, enemyMig: SKSpriteNode){
        f_40.removeFromParent()
        enemyMig.removeFromParent()
        NSLog("hit by mig")
        endGame()
    }
    
    func hitGround(){
        f_40.removeFromParent()
        NSLog("hit ground")
        endGame()
    }
    
    func hitCeiling(){
        f_40.removeFromParent()
        NSLog("hit ceiling")
        endGame()
    }
    
    //used to stop the chopper from firing infinitely by invalidating the timer causing the firing after a delay
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func firedMissile(){
        missiles.removeAll()
        self.fireBtn.enabled = false
        fireBtn.userInteractionEnabled = false
        let fire = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: #selector(GameScene.spawnUserMissile), userInfo: nil, repeats: true)
        
        //delay param / above time interval = num of missiles fired
        delay(0.75){
            fire.invalidate()
        }
        
        
    }
    
    //spawns a blue missle on the f-40 moving right
    func spawnUserMissile(){
        self.fireBtn.enabled = false
        missile = SKSpriteNode(imageNamed: "missile")
        missile.zPosition = 1
        missile.position = CGPointMake(f_40.position.x, f_40.position.y-4)
        missile.size.height = 150
        missile.size.width = 80
        //moves the missile. last arg controls the speed (lower = faster) will replace this later
        let horizontalMove = SKAction.moveByX(self.size.width, y: 0, duration: 2.5)
        //deletes the missile once off the screen
        let doneMoving = SKAction.removeFromParent()
        missile.runAction(SKAction.sequence([horizontalMove, doneMoving]))
    
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(15, 5))
        missile.physicsBody?.categoryBitMask = PhysicsCatagory.userMissile
        missile.physicsBody?.collisionBitMask = 0
        missile.physicsBody?.contactTestBitMask = PhysicsCatagory.enemyMig | PhysicsCatagory.enemyMissile
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody?.dynamic = true
        missile.physicsBody?.usesPreciseCollisionDetection = true
        
        localShots = localShots + 1

        if !finished {
            self.addChild(missile)
            missiles.append(missile)
        }
        
    }
    
    //Function creates an enemyMig
    func createEnemyMig() {
        
       
        let enemyMigs = SKNode()
        let height = self.size.height
        
        //Load the enemy Mig 21
        enemyMig = SKSpriteNode(imageNamed: "MiG-21-Clean")
        //Set size of the Mig
        enemyMig.size = CGSize(width: 77, height: 100)
        //1.5 = 3/4 of Screen, 1.75 = Barely on Screen, 2.0 = Off the screen
        enemyMig.position = CGPoint(x: self.size.width + enemyMig.size.width/2 , y: CGFloat(arc4random_uniform(UInt32(height * 0.89)) + UInt32(height * 0.1)))
        enemyMig.zPosition = 1
        //Add the enemy mig to the screen.
        enemyMigs.addChild(enemyMig)
        
        enemyMig.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(21, 12))
        enemyMig.physicsBody?.categoryBitMask = PhysicsCatagory.enemyMig
        enemyMig.physicsBody?.collisionBitMask = PhysicsCatagory.userMissile | PhysicsCatagory.f_40 | PhysicsCatagory.scoreWall
        enemyMig.physicsBody?.contactTestBitMask = PhysicsCatagory.userMissile | PhysicsCatagory.f_40 | PhysicsCatagory.scoreWall
        enemyMig.physicsBody?.affectedByGravity = false
        enemyMig.physicsBody?.dynamic = false
        enemyMig.physicsBody?.usesPreciseCollisionDetection = true
        
        
        self.addChild(enemyMigs)
        
        
        //moves migs accross the screen to the left
        let moveMig = SKAction.moveByX(-self.size.width, y: 0, duration: 3.5)
        //deletes mig once off screen
        let doneMoving = SKAction.removeFromParent()
        enemyMig.runAction(SKAction.sequence([moveMig, doneMoving]))
        
        
        
       _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(GameScene.enemyMissiles), userInfo: nil, repeats: false)

    }
    
    //creates a red missile from the migs that moves left
    func enemyMissiles(){
        enemyMissile = SKSpriteNode(imageNamed: "enemyMissile")
        enemyMissile.zPosition = 1
        enemyMissile.position = CGPointMake(enemyMig.position.x, enemyMig.position.y)
        enemyMissile.size.height = 200
        enemyMissile.size.width = 110
        //moves the missile. last arg controls the speed (lower = faster)
        let enemyFire = SKAction.moveByX(-self.size.width, y: 0, duration: 2)
        //deletes red missile once off screen
        let doneMoving = SKAction.removeFromParent()
        enemyMissile.runAction(SKAction.sequence([enemyFire, doneMoving]))
        
        
        enemyMissile.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(7,2))
        enemyMissile.physicsBody?.categoryBitMask = PhysicsCatagory.enemyMissile
        enemyMissile.physicsBody?.collisionBitMask = PhysicsCatagory.userMissile | PhysicsCatagory.f_40 | PhysicsCatagory.scoreWall
        enemyMissile.physicsBody?.contactTestBitMask = PhysicsCatagory.userMissile | PhysicsCatagory.f_40 | PhysicsCatagory.scoreWall
        enemyMissile.physicsBody?.affectedByGravity = false
        enemyMissile.physicsBody?.dynamic = false
        enemyMissile.physicsBody?.usesPreciseCollisionDetection = true

        self.addChild(enemyMissile)
        
    }
    
    //called when the user loses
    func endGame(){
        moveBackground = false
        finished = true
        
        scoreWall.removeFromParent()
        fireBtn.removeFromSuperview()
        nothingBtn.removeFromSuperview()
        
        totalScore = hitCounter + score
        
        //default creats a mode to access scores in other files and does not reset between plays
        let highscoreDefault = NSUserDefaults.standardUserDefaults()
        highscoresArr = highscoreDefault.valueForKey("highscoresArr") as! [NSInteger]
        
        highscoresArr.sortInPlace()
        
        //add the new score to the array if a top ten score
        if(highscoresArr.isEmpty){
            var indx = 1
            highscoresArr.append(totalScore)
            while indx < 10 {
                highscoresArr.append(0)
                indx = indx + 1
            }
        
        } else if (totalScore > highscoresArr[0]){
            highscoresArr[0] = totalScore
            highscoresArr.sortInPlace()
        }
        
        //sorts the array in descending order
        highscoresArr = highscoresArr.reverse()

        //puts the actual array in the default under the listed key
        highscoreDefault.setValue(highscoresArr, forKey: "highscoresArr")
        
        // gets stats from the default (except hitPercent and avgScore)
        shotsFired = highscoreDefault.valueForKey("shotsFired") as! Int
        totalHits = highscoreDefault.valueForKey("totalHits") as! Int
        totalEvasions = highscoreDefault.valueForKey("totalEvasions") as! Int
        allTimeScore = highscoreDefault.valueForKey("allTimeScore") as! Int
        totalGames = highscoreDefault.valueForKey("totalGames") as! Int
        
        //adds current game stats to all time stats
        shotsFired = shotsFired + localShots
        totalHits = totalHits + hitCounter
        totalEvasions = totalEvasions + score
        allTimeScore = allTimeScore + totalScore
        totalGames = totalGames + 1
        
        avgScore = allTimeScore / totalGames
        
        if(shotsFired==0){
            hitPercent = 0.00
        } else {
            hitPercent = Double(totalHits / 10) / Double(shotsFired) * 100
        }
        
        //stores updated all time stats in the default
        highscoreDefault.setValue(shotsFired, forKey: "shotsFired")
        highscoreDefault.setValue(totalHits, forKey: "totalHits")
        highscoreDefault.setValue(totalEvasions, forKey: "totalEvasions")
        highscoreDefault.setValue(allTimeScore, forKey: "allTimeScore")
        highscoreDefault.setValue(hitPercent, forKey: "hitPercent")
        highscoreDefault.setValue(avgScore, forKey: "avgScore")
        highscoreDefault.setValue(totalGames, forKey: "totalGames")

        
        
        //adds total score label
        total = UILabel((frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30)))
        total.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.32)
        total.text = "Score: \(totalScore)"
        total.textAlignment = NSTextAlignment.Center
        total.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        total.textColor = UIColor.whiteColor()
        self.view?.addSubview(total)
        
        //adds a highscore label
        highscoreLabel = UILabel((frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30)))
        highscoreLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.38)
        highscoreLabel.text = "Highscore: \(highscoresArr[0])"
        highscoreLabel.textAlignment = NSTextAlignment.Center
        highscoreLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        highscoreLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(highscoreLabel)

        
        
        //adds game over label
        gameOver = UILabel((frame: CGRect(x: 0, y: 0, width: 300, height: 60)))
        gameOver.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.2)
        gameOver.text = "Game Over"
        gameOver.textAlignment = NSTextAlignment.Center
        gameOver.font = UIFont(name: "AvenirNextCondensed-Bold", size: 60)
        gameOver.textColor = UIColor.whiteColor()
        self.view?.addSubview(gameOver)
        
        //adds Restart button
        restart = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        restart.center = CGPoint(x: view!.frame.size.width / 2, y: view!.frame.size.height * 0.5)
        restart.setTitle("Restart", forState: UIControlState.Normal)
        restart.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        restart.addTarget(self, action: #selector(GameScene.Restart), forControlEvents: UIControlEvents.TouchUpInside)
        restart.layer.borderWidth = 1
        restart.layer.borderColor = UIColor.whiteColor().CGColor
        restart.backgroundColor = UIColor.lightTextColor()
        restart.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //changes text color when pushed
        restart.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.view?.addSubview(restart)
        
        //adds main menu button
        menu = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        menu.center = CGPoint(x: view!.frame.size.width / 2, y: view!.frame.size.height * 0.65)
        menu.setTitle("Main Menu", forState: UIControlState.Normal)
        menu.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        menu.addTarget(self, action: #selector (GameScene.mainMenu), forControlEvents: UIControlEvents.TouchUpInside)
        menu.layer.borderWidth = 1
        menu.layer.borderColor = UIColor.whiteColor().CGColor
        menu.backgroundColor = UIColor.lightTextColor()
        menu.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //changes text color when pushed
        menu.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)

        self.view?.addSubview(menu)
        
        
    }
    
    //what happens when the restart button is pressed
    func Restart(){
        highscoreLabel.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        hitLabel.removeFromSuperview()
        total.removeFromSuperview()
        restart.removeFromSuperview()
        gameOver.removeFromSuperview()
        menu.removeFromSuperview()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as SKView!
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }

    
    }
    //when main menu button is pressed
    func mainMenu(){
        highscoreLabel.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        hitLabel.removeFromSuperview()
        total.removeFromSuperview()
        restart.removeFromSuperview()
        gameOver.removeFromSuperview()
        menu.removeFromSuperview()
        
        if let scene = StartScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as SKView!
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
    }
    
    //changes fire buttons textcolor to black
    func flashFire(){
        self.fireBtn.titleLabel?.textColor = UIColor.blackColor()
    }

    

    var touchingScreen = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        super.touchesBegan(touches, withEvent: event)
        touchingScreen = true
        f_40.physicsBody?.velocity = CGVector(dx: 0, dy: 150)
        start.removeFromSuperview()
        //fireBtn.enabled = true
        
        if (!(f_40.physicsBody?.affectedByGravity)!) {
            //calls the createEnemyMig function every 1 second. 1st arg is time interval
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameScene.createEnemyMig), userInfo: nil, repeats: true)
            
            //spwans a missile from the f-40. time interval is the 1st arg. will need to change to touch activation later
           // NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GameScene.spawnUserMissile), userInfo: nil, repeats: true)
            
        }
        
        f_40.physicsBody?.affectedByGravity = true
        moveBackground = true
        
        
        
    }
    
    //called to renable firing a missle (called by the NSTimer where button is made)
    func enableFireBtn(){
        if moveBackground {
            self.fireBtn.enabled = true
        }
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
        
        //makes the fire buttons color change if you can fire
        if fireBtn.enabled {
            flashFire()
        }
        
        if (moveBackground == true && finished == false) {
            // 4 controls the speed below
            
            //enable the fire button
            fireBtn.userInteractionEnabled = true
            
            bground.position = CGPoint(x: bground.position.x-6 , y: bground.position.y)
            bground2.position = CGPoint(x: bground2.position.x-6, y: bground2.position.y)
        
            if(bground.position.x < -bground.size.width + self.size.width * 0.2){
                bground.position = CGPointMake(bground2.position.x + bground2.size.width, bground.position.y)
            }
        
            if(bground2.position.x < -bground2.size.width + self.size.width * 0.2){
                bground2.position = CGPointMake(bground.position.x + bground.size.width, bground2.position.y)
            }
            
            
        }
        
        var index = 0
        while index < missiles.count{
            if missiles[index].position.x > self.frame.size.width * 0.79 {
                missiles[index].physicsBody?.dynamic = false
            }
            
            index = index + 1
        }
    }
}
