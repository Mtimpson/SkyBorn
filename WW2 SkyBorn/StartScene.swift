//
//  StartScene.swift
//  WW2 SkyBorn
//
//  Created by Michael Timpson on 5/9/16.
//  Copyright © 2016 newBorn Software Development Company. All rights reserved.
//

import Foundation
import SpriteKit


class StartScene: SKScene  {
    var playBtn : UIButton!
    var scoresBtn : UIButton!
    var text1 = SKTexture()
    var bground = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        let width = self.size.width
        let height = self.size.height

        
        let text3 = SKTexture(imageNamed: "desertSky")
        let sky = SKSpriteNode(texture: text3, size: CGSize(width: width, height: height))
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


        
        
        //adds play button
        playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 30))
        playBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.4)
        playBtn.setTitle("Play", forState: UIControlState.Normal)
        playBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        playBtn.addTarget(self, action: #selector(StartScene.play), forControlEvents:
            UIControlEvents.TouchUpInside)

        self.view?.addSubview(playBtn)
        
        
        //adds high scores button
        scoresBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 30))
        scoresBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.5)
        scoresBtn.setTitle("High Scores", forState: UIControlState.Normal)
        scoresBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        scoresBtn.addTarget(self, action: #selector(StartScene.highScores), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(scoresBtn)
        
        
        
    }
    
    func play(){
       
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
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
    
    func highScores(){
        
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
    }
    
    
    
    
    
}