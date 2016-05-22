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
    var highscoresArr : [NSInteger] = [NSInteger]()
    var highscoreTitle : UILabel!
    var scoreTitles : UILabel!
    var labelY : CGFloat!
    var menu : UIButton!
    var labelArr : [UILabel] = [UILabel]()
  
    
    override func didMoveToView(view: SKView) {
        let width = self.size.width
        let height = self.size.height
        
        
        //creates a defualt able to access the array of highscores we stored
        let highscoreDefault = NSUserDefaults.standardUserDefaults()
        
        //checks to see if the app has been launched before. If so, it pulls the array of high scores and if not, it creates an array of high scores. Prevents errors 
        func isAppAlreadyLaunchedOnce()->Bool{
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
                print("App already launched : \(isAppAlreadyLaunchedOnce)")
                highscoresArr = highscoreDefault.valueForKey("highscoresArr") as! [NSInteger]
                return true
            }else{
                highscoresArr = [NSInteger](count: 10, repeatedValue: 0)
                highscoreDefault.setValue(highscoresArr, forKey: "highscoresArr")
                defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
                print("App launched first time")
                return false
            }
        }
    
        isAppAlreadyLaunchedOnce()
        NSLog("\(highscoresArr)")

        

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
        //changes text color when pushed
        playBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)

        self.view?.addSubview(playBtn)
        
        
        //adds high scores button
        scoresBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2.5, height: 40))
        scoresBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.5)
        scoresBtn.setTitle("High Scores", forState: UIControlState.Normal)
        scoresBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        scoresBtn.addTarget(self, action: #selector(StartScene.highscoreLabels), forControlEvents:
            UIControlEvents.TouchUpInside)
        scoresBtn.layer.borderWidth = 1
        scoresBtn.layer.borderColor = UIColor.whiteColor().CGColor
        scoresBtn.backgroundColor = UIColor.lightTextColor()
        scoresBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        //changes text color when pushed
        scoresBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)

        
        self.view?.addSubview(scoresBtn)
        
        //adds 'SkyBorn' title
        skyborn = UILabel(frame: CGRect(x: 0, y: 0, width: width/2, height: 80))
        skyborn.center = CGPoint(x: view.center.x, y: view.frame.size.height * 0.18)
        skyborn.text = "SkyBorn"
        skyborn.textAlignment = NSTextAlignment.Center
        skyborn.font = UIFont(name: "AvenirNextCondensed-Bold", size: 80)
        skyborn.textColor = UIColor.lightTextColor()
        
        self.view?.addSubview(skyborn)
        
        
    }
    
    //called to start the game
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
    
    //called when the user hits 'highscores' button
    func highscoreLabels(){
        skyborn.removeFromSuperview()
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
        
        //adds highscore title
        highscoreTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2, height: 80))
        highscoreTitle.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.18)
        highscoreTitle.text = "High Scores"
        highscoreTitle.textAlignment = NSTextAlignment.Center
        highscoreTitle.font = UIFont(name: "AvenirNextCondensed-Bold", size: 60)
        highscoreTitle.textColor = UIColor.whiteColor()
        self.view?.addSubview(highscoreTitle)
        
        //labelY is adjusted so that the labels for each score don't overlap
        labelY = 0.23
        var index = 0
        //creates 10 labels, one for each of the top ten scores and adds them to an array so that they can be removed. Only the last made one is removed if an array is not used
        while (index < 10){
            scoreTitles = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
            labelY = labelY + 0.05
            scoreTitles.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * labelY)
            scoreTitles.text = calcAlignment(highscoresArr[index], index: index)
            scoreTitles.textAlignment = NSTextAlignment.Center
            scoreTitles.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
            scoreTitles.textColor = UIColor.whiteColor()
            self.view?.addSubview(scoreTitles)
            labelArr.append(scoreTitles)
            
            index += 1
        }
        
        //adds main menu button
        menu = UIButton(frame:CGRect(x: 0, y: 0, width: view!.frame.size.width / 2.5, height: 40))
        menu.center = CGPoint(x: view!.frame.size.width / 2, y: view!.frame.size.height * 0.8)
        menu.setTitle("Main Menu", forState: UIControlState.Normal)
        menu.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        menu.addTarget(self, action: #selector (GameScene.mainMenu), forControlEvents: UIControlEvents.TouchUpInside)
        menu.layer.borderWidth = 1
        menu.layer.borderColor = UIColor.whiteColor().CGColor
        menu.backgroundColor = UIColor.lightTextColor()
        menu.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        //changes text color when pushed
        menu.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.view?.addSubview(menu)


        
    }
    
    // called from highscoreLabeles to aligns scores with different numbers of digits by using '...'
    func calcAlignment(score: Int, index: Int) -> String {
        var alignedtText : String!
        let index = index + 1
        if(score<10000){
            alignedtText = "\(index).............................\(score)"
        }
        if(score<1000){
            alignedtText = "\(index)..............................\(score)"
        }
        if(score<100){
            alignedtText = "\(index)...............................\(score)"
        }
        if(score<10){
            alignedtText = "\(index)................................\(score)"
        }
        
        if(index == 10){
            if(score<10000){
                alignedtText = "\(index)...........................\(score)"
            }
            if(score<1000){
                alignedtText = "\(index)............................\(score)"
            }
            if(score<100){
                alignedtText = "\(index).............................\(score)"
            }
            if(score<10){
                alignedtText = "\(index)..............................\(score)"
            }

        }
        
        return alignedtText
    }
    //called from the highscores screen to return to the main menu
    func mainMenu(){
        var index = 0
        while index < 10 {
            labelArr[index].removeFromSuperview()
            index += 1
        }
        
        highscoreTitle.removeFromSuperview()
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