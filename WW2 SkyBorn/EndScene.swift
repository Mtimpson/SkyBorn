//
//  EndScene.swift
//  WW2 SkyBorn
//
//  Created by Matt on 5/10/16.
//  Copyright © 2016 newBorn Software Development Company. All rights reserved.
//

import Foundation
import SpriteKit

//scene after the user collides with something
class EndScene : SKScene {
    //button variable
    var restart : UIButton!
    var menu : UIButton!
    var text1 = SKTexture()
    var bground = SKSpriteNode()
    var gameOver : UILabel!

    
    
    override func didMoveToView(view: SKView) {
        
        let width = self.size.width
        let height = self.size.height
        
        //add the sky
        let text3 = SKTexture(imageNamed: "desertSky")
        let sky = SKSpriteNode(texture: text3, size: CGSize(width: width, height: height))
        sky.anchorPoint = CGPoint(x: 0, y: -0.07)
        sky.zPosition = -10
        self.addChild(sky)
        
        //add the desert
        text1 = SKTexture(imageNamed: "desert")
        bground = SKSpriteNode(texture: text1)
        bground.anchorPoint = CGPointZero
        bground.size.width = width
        bground.position = CGPointZero
        bground.zPosition = -5
        self.addChild(bground)

        
        //adds game over label
        gameOver = UILabel((frame: CGRect(x: 0, y: 0, width: 300, height: 60)))
        gameOver.center = CGPoint(x: view.center.x*1.1, y: view.frame.size.height * 0.18)
        gameOver.text = "Game Over"
        gameOver.font = UIFont(name: "AvenirNextCondensed-Bold", size: 60)
        gameOver.textColor = UIColor.whiteColor()
        self.view?.addSubview(gameOver)
        
        //adds Restart button
        restart = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2.5, height: 30))
        restart.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.4)
        restart.setTitle("Restart", forState: UIControlState.Normal)
        restart.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        restart.addTarget(self, action: #selector(EndScene.Restart), forControlEvents: UIControlEvents.TouchUpInside)
        restart.layer.borderWidth = 1
        restart.layer.borderColor = UIColor.whiteColor().CGColor
        restart.backgroundColor = UIColor.lightTextColor()
        restart.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        self.view?.addSubview(restart)
        
        //adds main menu button
        menu = UIButton(frame:CGRect(x: 0, y: 0, width: view.frame.size.width / 2.5, height: 30))
        menu.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.5)
        menu.setTitle("Main Menu", forState: UIControlState.Normal)
        menu.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        menu.addTarget(self, action: #selector (EndScene.mainMenu), forControlEvents: UIControlEvents.TouchUpInside)
        menu.layer.borderWidth = 1
        menu.layer.borderColor = UIColor.whiteColor().CGColor
        menu.backgroundColor = UIColor.lightTextColor()
        menu.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        self.view?.addSubview(menu)

        
        
        
        
    }
    
    //what happens when the restart button is pressed
    func Restart(){
        
        restart.removeFromSuperview()
        gameOver.removeFromSuperview()
        menu.removeFromSuperview()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as SKView!
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }

        
        
    }
    
    func mainMenu(){
        restart.removeFromSuperview()
        gameOver.removeFromSuperview()
        menu.removeFromSuperview()
        
        if let scene = StartScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as SKView!
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }

    }
    
}