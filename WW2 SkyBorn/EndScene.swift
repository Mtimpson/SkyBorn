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
    //blur effect variables
    var text1 = SKTexture()
    var text3 = SKTexture()
    var sky = SKSpriteNode()
    var bground = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        
        let width = self.size.width
        let height = self.size.height
        
        
        text3 = SKTexture(imageNamed: "desertSky")
        sky = SKSpriteNode(texture: text3, size: CGSize(width: width, height: height))
        sky.anchorPoint = CGPoint(x: 0, y: -0.07)
        sky.zPosition = -10
        self.addChild(sky)
        
        text1 = SKTexture(imageNamed: "desert")
        bground = SKSpriteNode(texture: text1)
        bground.anchorPoint = CGPointZero
        bground.size.width = width
        bground.position = CGPointZero
        bground.zPosition = -5
        self.addChild(bground)

        
        //adds Restart button
        restart = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 30))
        restart.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 7)
        restart.setTitle("Restart", forState: UIControlState.Normal)
        restart.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        restart.addTarget(self, action: #selector(EndScene.Restart), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(restart)
        
        
    }
    
    //what happens when the restart button is pressed
    func Restart(){
        
        restart.removeFromSuperview()
        bground.removeFromParent()
        sky.removeFromParent()
        
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
    
}