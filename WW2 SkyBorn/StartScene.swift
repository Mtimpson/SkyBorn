//
//  StartScene.swift
//  WW2 SkyBorn
//
//  Created by Michael Timpson on 5/9/16.
//  Copyright © 2016 newBorn Software Development Company. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


class StartScene: SKScene  {
    var playBtn : UIButton!
    var scoresBtn : UIButton!
    var text1 = SKTexture()
    var bground = SKSpriteNode()
    var skyborn : UILabel!
    
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
    
        
        //adds play button
        playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2.5, height: 40))
        playBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.4)
        playBtn.setTitle("Play", forState: UIControlState.Normal)
        playBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        playBtn.addTarget(self, action: #selector(StartScene.play), forControlEvents:
            UIControlEvents.TouchUpInside)
        playBtn.layer.borderWidth = 1
        playBtn.layer.borderColor = UIColor.whiteColor().CGColor
        playBtn.backgroundColor = UIColor.lightTextColor()
        playBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)

        self.view?.addSubview(playBtn)
        
        
        //adds high scores button
        scoresBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2.5, height: 40))
        scoresBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.5)
        scoresBtn.setTitle("High Scores", forState: UIControlState.Normal)
        scoresBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        scoresBtn.addTarget(self, action: #selector(StartScene.highScores), forControlEvents:
            UIControlEvents.TouchUpInside)
        scoresBtn.layer.borderWidth = 1
        scoresBtn.layer.borderColor = UIColor.whiteColor().CGColor
        scoresBtn.backgroundColor = UIColor.lightTextColor()
        scoresBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)

        
        self.view?.addSubview(scoresBtn)
        
        //adds 'SkyBorn' title
        skyborn = UILabel(frame: CGRect(x: 0, y: 0, width: width/2, height: 80))
        skyborn.center = CGPoint(x: view.center.x*1.75, y: view.frame.size.height * 0.18)
        skyborn.text = "SkyBorn"
        skyborn.font = UIFont(name: "AvenirNextCondensed-Bold", size: 80)
        skyborn.textColor = UIColor.lightTextColor()
        
        self.view?.addSubview(skyborn)
        
        
        
        
        
        
    }
    
    func play(){
       //removes buttons from view
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
        skyborn.removeFromSuperview()
        
        //calls the game to be played
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
        skyborn.removeFromSuperview()
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
        
    }
    
    
    
    
}