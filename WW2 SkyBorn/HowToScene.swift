//
//  HowToScene.swift
//  SkyBorn
//
//  Created by Matt on 5/30/16.
//  Copyright © 2016 newBorn Software Development Company. All rights reserved.
//

import Foundation
import SpriteKit


class HowToScene : SKScene, SKPhysicsContactDelegate {
    
    var started = false
    var finished = false
    var touchingScreen = false
  
    var playTap : UIButton!
    var nothingBtn : UIButton!
    var migTimer : NSTimer!
    var taps = 0
    var instruct1 : UILabel!
    var instruct2 : UILabel!
    var instruct3 : UILabel!
    var instruct4 : UILabel!
    var instruct5 : UILabel!
    var welcome : UILabel!
    var continueTap : UIButton!
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
    var moveBackground = true
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
        //self.view?.addSubview(scoreLabel)
        
        //label to track number of enemy objects hit by missiles
        hitLabel = UILabel(frame: CGRect(x: 100, y: 0, width: 100, height: 20))
        hitLabel.text = "Hits: \(hitCounter)"
        hitLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 15)
        hitLabel.textColor = UIColor.whiteColor()
        //self.view?.addSubview(hitLabel)
        
        
        //adds something behind the fireBtn so that you do not fall if you push fire too fast
        nothingBtn = UIButton(type: .Custom)
        nothingBtn.frame = CGRectMake(10, view.frame.height - 10 - 100, 100, 100)
        nothingBtn.layer.cornerRadius = 0.5 * nothingBtn.bounds.size.width
        //nothingBtn.addTarget(self, action: #selector(GameScene.startPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        nothingBtn.layer.zPosition = 10
        //self.view?.addSubview(nothingBtn)

        
        // Fire button
        fireBtn = UIButton(type: .Custom)
        fireBtn.frame = CGRectMake(10, view.frame.height - 10 - 100, 100, 100)
        fireBtn.layer.cornerRadius = 0.5 * fireBtn.bounds.size.width
        fireBtn.setTitle("Fire", forState: UIControlState.Normal)
        fireBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        fireBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        fireBtn.addTarget(self, action: #selector(HowToScene.firedMissile), forControlEvents: UIControlEvents.TouchUpInside)
        fireBtn.layer.borderWidth = 2
        fireBtn.layer.borderColor = UIColor.whiteColor().CGColor
        fireBtn.backgroundColor = UIColor.lightTextColor()
        fireBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 40)
        fireBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        fireBtn.layer.zPosition = 11
        
        //self.view?.addSubview(fireBtn)
        self.fireBtn.enabled = false
        fireBtn.userInteractionEnabled = false
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(HowToScene.enableFireBtn), userInfo: nil, repeats: true)
        
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
        
        //adds a button that calls function to flip thru instructions when tapped
        continueTap = UIButton(frame: CGRect(x: view.frame.size.width/1.85, y: view.frame.size.height/1.07 - 5, width: 150, height: 30))
        continueTap.setTitle("Tap to Continue >", forState: UIControlState.Normal)
        continueTap.titleLabel?.font =  UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        continueTap.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        continueTap.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        continueTap.addTarget(self, action: #selector(HowToScene.tappedContinue), forControlEvents: UIControlEvents.TouchUpInside)
        self.view!.addSubview(continueTap)
        
        //adds a welcome label
        welcome = UILabel(frame: CGRect(x: view.frame.size.height / 4.75, y: view.frame.size.height / 5, width: 200, height: 400))
        welcome.text = "Welcome to SkyBorn! This screen will teach you how to play. Hit the button in the bottom right to continue!"
        welcome.lineBreakMode = .ByWordWrapping
        welcome.numberOfLines = 0
        welcome.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        welcome.textColor = UIColor.whiteColor()
        view.addSubview(welcome)
        
        //adds a button that moves to gamescene after tutorial
        playTap = UIButton(frame: CGRect(x: view.frame.size.width/1.85, y: view.frame.size.height/1.07 - 5, width: 150, height: 30))
        playTap.setTitle("Tap to Play >", forState: UIControlState.Normal)
        playTap.titleLabel?.font =  UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        playTap.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        playTap.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        playTap.addTarget(self, action: #selector(HowToScene.tappedPlay), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func tappedPlay(){
        scoreLabel.removeFromSuperview()
        hitLabel.removeFromSuperview()
        instruct4.removeFromSuperview()
        playTap.removeFromSuperview()
        nothingBtn.removeFromSuperview()
        fireBtn.removeFromSuperview()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view! as SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    

    }
    
    func tappedContinue(){
        taps = taps + 1
        if (taps == 1){
            tap1()
        }
        if (taps == 2){
            tap2()
        }

        if (taps == 3){
            tap3()
        }

        if (taps == 4){
            tap4()
        }

        if (taps == 5){
            tap5()
        }
        
        if (taps == 6){
            tap6()
        }


    }
    
    func tap1(){
        welcome.removeFromSuperview()
        instruct1 = UILabel(frame: CGRect(x: view!.frame.size.height / 4.75, y: view!.frame.size.height / 4.75, width: 200, height: 400))
        instruct1.textColor = UIColor.whiteColor()
        instruct1.text = "Tap and hold the screen to fly higher. Hitting the ground or top of the screen will cause your chopper to explode!"
        instruct1.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        instruct1.lineBreakMode = .ByWordWrapping
        instruct1.numberOfLines = 0
        self.view?.addSubview(instruct1)
        
        ground.fillColor = UIColor.redColor()
        ceiling.fillColor = UIColor.redColor()
        ground.zPosition = 100
        ceiling.zPosition = 100
    }
    
    func tap2(){
        ground.zPosition = -100
        ceiling.zPosition = -100
        instruct1.removeFromSuperview()
        
        instruct2 = UILabel(frame: CGRect(x: view!.frame.size.height / 4.75, y: view!.frame.size.height / 5, width: 200, height: 400))
        instruct2.textColor = UIColor.whiteColor()
        instruct2.text = "Tap the fire button to fire a burst of missiles. Aim wisely, you cannot fire continuously!"
        instruct2.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        instruct2.lineBreakMode = .ByWordWrapping
        instruct2.numberOfLines = 0
        self.view?.addSubview(instruct2)
        
        self.view?.addSubview(nothingBtn)
        self.view?.addSubview(fireBtn)
        
        
        

    }

    func tap3(){
        instruct2.removeFromSuperview()
        
        instruct3 = UILabel(frame: CGRect(x: view!.frame.size.height / 4.75, y: view!.frame.size.height / 5, width: 200, height: 400))
        instruct3.textColor = UIColor.whiteColor()
        instruct3.text = "Avoid or shoot down enemy fighters as they spawn on the right. Be careful, they fire back!"
        instruct3.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        instruct3.lineBreakMode = .ByWordWrapping
        instruct3.numberOfLines = 0
        self.view?.addSubview(instruct3)
        continueTap.setTitle("Tap to try it out >", forState: UIControlState.Normal)

    }
    
    func tap4(){
        migTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(HowToScene.createEnemyMig), userInfo: nil, repeats: true)
        instruct3.removeFromSuperview()
        continueTap.setTitle("Tap to continue >", forState: UIControlState.Normal)


    }

    func tap5(){
        migTimer.invalidate()
        
        instruct3 = UILabel(frame: CGRect(x: view!.frame.size.height / 4.75, y: view!.frame.size.height / 5, width: 200, height: 400))
        instruct3.textColor = UIColor.whiteColor()
        instruct3.text = "Score is kept in the top left corner: You receive 1 point for every object you avoid and 10 for each one you shoot with a missile."
        instruct3.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        instruct3.lineBreakMode = .ByWordWrapping
        instruct3.numberOfLines = 0
        self.view?.addSubview(instruct3)
        
        score = 0
        hitCounter = 0
        
        self.view?.addSubview(scoreLabel)
        self.view?.addSubview(hitLabel)
        

        
    }
    
    func tap6(){
        instruct3.removeFromSuperview()
        
        instruct4 = UILabel(frame: CGRect(x: view!.frame.size.height / 4.75, y: view!.frame.size.height / 5, width: 200, height: 400))
        instruct4.textColor = UIColor.whiteColor()
        instruct4.text = "Thats it, you're ready to play!"
        instruct4.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        instruct4.lineBreakMode = .ByWordWrapping
        instruct4.numberOfLines = 0
        self.view?.addSubview(instruct4)
        
        continueTap.removeFromSuperview()
        self.view?.addSubview(playTap)
        
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
    
    //spawns a blue missle on the f-40 moving right
    func spawnUserMissile(){
        
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
        enemyMig.position = CGPoint(x: self.frame.width , y: CGFloat(arc4random_uniform(UInt32(height * 0.8)) + UInt32(height * 0.1)))
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
        
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(HowToScene.enemyMissiles), userInfo: nil, repeats: false)
        
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
                if (body1.categoryBitMask == PhysicsCatagory.f_40) {
                    f40AndMissile(body1.node as! SKSpriteNode, enemyMissile: body2.node as! SKSpriteNode)
                }
                else {
                    f40AndMissile(body2.node as! SKSpriteNode, enemyMissile: body1.node as! SKSpriteNode)
                }
                
                
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
                if (body1.categoryBitMask == PhysicsCatagory.f_40) {
                    f40AndMig(body1.node as! SKSpriteNode, enemyMig: body2.node as! SKSpriteNode)
                }
                else {
                    f40AndMig(body2.node as! SKSpriteNode, enemyMig: body1.node as! SKSpriteNode)
                }
                
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
        hitCounter += 10
        hitLabel.text = "Hits: \(hitCounter)"
    }
    //call when f-40 missile collides with mig missile
    func missileAndMissile(userMissile: SKSpriteNode, enemyMissile: SKSpriteNode){
        userMissile.removeFromParent()
        enemyMissile.removeFromParent()
        NSLog("missile on missile")
        hitCounter += 10
        hitLabel.text = "Hits: \(hitCounter)"
    }
    //call when enemy missile hits our f-40
    func f40AndMissile(f_40: SKSpriteNode, enemyMissile: SKSpriteNode){
        f_40.removeFromParent()
        enemyMissile.removeFromParent()
        NSLog("hit by missile")
        touchingScreen = false

        f_40.position = CGPoint(x: self.frame.width / 2.75, y: self.frame.height / 2)
        f_40.physicsBody?.affectedByGravity = false
        f_40.physicsBody?.dynamic = false
        self.addChild(f_40)
    }
    //call when mig collides with f-40
    func f40AndMig(f_40: SKSpriteNode, enemyMig: SKSpriteNode){
        f_40.removeFromParent()
        enemyMig.removeFromParent()
        NSLog("hit by mig")
        touchingScreen = false
        
        f_40.position = CGPoint(x: self.frame.width / 2.75, y: self.frame.height / 2)
        f_40.physicsBody?.affectedByGravity = false
        f_40.physicsBody?.dynamic = false
        self.addChild(f_40)

    }
    
    func hitGround(){
        f_40.removeFromParent()
        NSLog("hit ground")
        f_40.position = CGPoint(x: self.frame.width / 2.75, y: self.frame.height / 2)
        self.addChild(f_40)
        f_40.physicsBody?.affectedByGravity = false
        touchingScreen = false
        f_40.physicsBody?.dynamic = false
        

    }
    
    func hitCeiling(){
        f_40.removeFromParent()
        NSLog("hit ceiling")
        f_40.position = CGPoint(x: self.frame.width / 2.75, y: self.frame.height / 2)
        self.addChild(f_40)
        f_40.physicsBody?.affectedByGravity = false
        touchingScreen = false
        f_40.physicsBody?.dynamic = false
      
    }

    
    //called to renable firing a missle (called by the NSTimer where button is made)
    func enableFireBtn(){
        self.fireBtn.enabled = true
        self.fireBtn.userInteractionEnabled = true
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func firedMissile(){
        self.fireBtn.enabled = false
        fireBtn.userInteractionEnabled = false
        let fire = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: #selector(HowToScene.spawnUserMissile), userInfo: nil, repeats: true)
        
        //delay param / above time interval = num of missiles fired
        delay(0.75){
            fire.invalidate()
        }
        
    }
    
    //changes fire buttons textcolor to black
    func flashFire(){
        self.fireBtn.titleLabel?.textColor = UIColor.blackColor()
    }




    
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        touchingScreen = true
        

       
        if (taps > 0){
            f_40.physicsBody?.affectedByGravity = true
            f_40.physicsBody?.velocity = CGVector(dx: 0, dy: 150)
            f_40.physicsBody?.dynamic = true
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

    
    override func update(currentTime: NSTimeInterval){
        if (touchingScreen && taps > 0) {
            f_40.physicsBody?.velocity = CGVector(dx: 0, dy: 140)
        }
        
        //makes the fire buttons color change if you can fire
        if fireBtn.enabled {
            flashFire()
        }



        if (moveBackground == true && finished == false) {
            // 4 controls the speed below
            
            bground.position = CGPoint(x: bground.position.x-6 , y: bground.position.y)
            bground2.position = CGPoint(x: bground2.position.x-6, y: bground2.position.y)
            
            if(bground.position.x < -bground.size.width + self.size.width * 0.2){
                bground.position = CGPointMake(bground2.position.x + bground2.size.width, bground.position.y)
            }
            
            if(bground2.position.x < -bground2.size.width + self.size.width * 0.2){
                bground2.position = CGPointMake(bground.position.x + bground.size.width, bground2.position.y)
            }
            
            
        }

        
    }

    
    

    
}
