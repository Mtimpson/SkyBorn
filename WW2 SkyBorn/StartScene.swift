//
//  StartScene.swift
//  SkyBorn
//
//  Created by Michael Timpson, Matthew Creel & Ben Brott on 5/9/16.
//  Copyright © 2016 newBorn Software Development Company. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit



class StartScene: SKScene  {
    
    var GCBtn : UIButton!
    var howToBtn : UIButton!
    var playBtn : UIButton!
    var scoresBtn : UIButton!
    var statsBtn : UIButton!
    var text1 = SKTexture()
    var bground = SKSpriteNode()
    var skyborn : UILabel!
    var highscoresArr : [NSInteger] = [NSInteger]()
    var highscoreTitle : UILabel!
    var shotsFired: Int!
    var totalHits : Int!
    var allTimeScore : Int!
    var totalEvasions : Int!
    var hitPercent : Double!
    var avgScore : Int!
    var totalGames : Int!
    var scoreTitles : UILabel!
    var totalGamesLabel : UILabel!
    var avgScoreLabel : UILabel!
    var labelY : CGFloat!
    var menu : UIButton!
    var labelArr : [UILabel] = [UILabel]()
    var statsTitle : UILabel!
    var fromScoresPage = false
    var fromStatsPage = false
    var shotsFiredLabel: UILabel!
    var totalHitsLabel : UILabel!
    var allTimeScoreLabel : UILabel!
    var totalEvasionsLabel : UILabel!
    var hitPercentLabel : UILabel!
  
    
    override func didMoveToView(view: SKView) {
        let width = self.size.width
        let height = self.size.height
        
        
        //creates a defualt able to access the array of highscores we stored
        let highscoreDefault = NSUserDefaults.standardUserDefaults()
        
        //checks to see if the app has been launched before. If so, it pulls the all stats from the default and if not, it sets all stats = 0 and places it in the default
        func isAppAlreadyLaunchedOnce()->Bool{
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
                print("App already launched : \(isAppAlreadyLaunchedOnce)")
                
                //uncomment the next line to reset stats or allow old device to get caught up without errors (make sure to comment the line out again after you run the app once)
                //highscoresArr = [NSInteger](count: 10, repeatedValue: 0); shotsFired = 0; totalHits = 0; totalEvasions = 0; allTimeScore = 0; hitPercent = 0.00; highscoreDefault.setValue(highscoresArr, forKey: "highscoresArr"); highscoreDefault.setValue(shotsFired, forKey: "shotsFired"); highscoreDefault.setValue(totalHits, forKey: "totalHits"); highscoreDefault.setValue(totalEvasions, forKey: "totalEvasions"); highscoreDefault.setValue(allTimeScore, forKey: "allTimeScore"); highscoreDefault.setValue(hitPercent, forKey: "hitPercent"); totalGames = 0; avgScore = 0; highscoreDefault.setValue(avgScore, forKey: "avgScore"); highscoreDefault.setValue(totalGames, forKey: "totalGames")

                highscoresArr = highscoreDefault.valueForKey("highscoresArr") as! [NSInteger]
                shotsFired = highscoreDefault.valueForKey("shotsFired") as! Int
                totalHits = highscoreDefault.valueForKey("totalHits") as! Int
                allTimeScore = highscoreDefault.valueForKey("allTimeScore") as! Int
                totalEvasions = highscoreDefault.valueForKey("totalEvasions") as! Int
                hitPercent = highscoreDefault.valueForKey("hitPercent") as! Double
                totalGames = highscoreDefault.valueForKey("totalGames") as! Int
                avgScore = highscoreDefault.valueForKey("avgScore") as! Int
                
                return true
                
            } else {
                highscoresArr = [NSInteger](count: 10, repeatedValue: 0)
                shotsFired = 0
                totalHits = 0
                totalEvasions = 0
                allTimeScore = 0
                hitPercent = 0.00
                totalGames = 0
                avgScore = 0
                highscoreDefault.setValue(avgScore, forKey: "avgScore")
                highscoreDefault.setValue(totalGames, forKey: "totalGames")
                highscoreDefault.setValue(highscoresArr, forKey: "highscoresArr")
                highscoreDefault.setValue(shotsFired, forKey: "shotsFired")
                highscoreDefault.setValue(totalHits, forKey: "totalHits")
                highscoreDefault.setValue(totalEvasions, forKey: "totalEvasions")
                highscoreDefault.setValue(allTimeScore, forKey: "allTimeScore")
                highscoreDefault.setValue(hitPercent, forKey: "hitPercent")
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
        playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        playBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.3)
        playBtn.setTitle("Play", forState: UIControlState.Normal)
        playBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        playBtn.addTarget(self, action: #selector(StartScene.play), forControlEvents:
            UIControlEvents.TouchUpInside)
        playBtn.layer.borderWidth = 1
        playBtn.layer.borderColor = UIColor.whiteColor().CGColor
        playBtn.backgroundColor = UIColor.lightTextColor()
        playBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //changes text color when pushed
        playBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)

        self.view?.addSubview(playBtn)
        
        
        //adds high scores button
        scoresBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        scoresBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.44)
        scoresBtn.setTitle("High Scores", forState: UIControlState.Normal)
        scoresBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        scoresBtn.addTarget(self, action: #selector(StartScene.highscoreLabels), forControlEvents:
            UIControlEvents.TouchUpInside)
        scoresBtn.layer.borderWidth = 1
        scoresBtn.layer.borderColor = UIColor.whiteColor().CGColor
        scoresBtn.backgroundColor = UIColor.lightTextColor()
        scoresBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //changes text color when pushed
        scoresBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
         self.view?.addSubview(scoresBtn)
        
        //adds stats button
        statsBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        statsBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.58)
        statsBtn.setTitle("Statistics", forState: UIControlState.Normal)
        statsBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        statsBtn.addTarget(self, action: #selector(StartScene.showStats), forControlEvents:
            UIControlEvents.TouchUpInside)
        statsBtn.layer.borderWidth = 1
        statsBtn.layer.borderColor = UIColor.whiteColor().CGColor
        statsBtn.backgroundColor = UIColor.lightTextColor()
        statsBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //changes text color when pushed
        statsBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)

        self.view?.addSubview(statsBtn)
        
        //adds how to play button
        howToBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        howToBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.72)
        howToBtn.setTitle("Tutorial", forState: UIControlState.Normal)
        howToBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        howToBtn.addTarget(self, action: #selector(StartScene.howToPlay), forControlEvents:
            UIControlEvents.TouchUpInside)
        howToBtn.layer.borderWidth = 1
        howToBtn.layer.borderColor = UIColor.whiteColor().CGColor
        howToBtn.backgroundColor = UIColor.lightTextColor()
        howToBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //changes text color when pushed
        howToBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        self.view?.addSubview(howToBtn)
        
        //adds gamecenter button
        GCBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        GCBtn.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.86)
        GCBtn.setTitle("Game Center", forState: UIControlState.Normal)
        GCBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        GCBtn.addTarget(self, action: #selector(StartScene.callGC), forControlEvents:
            UIControlEvents.TouchUpInside)
        GCBtn.layer.borderWidth = 1
        GCBtn.layer.borderColor = UIColor.whiteColor().CGColor
        GCBtn.backgroundColor = UIColor.lightTextColor()
        GCBtn.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //changes text color when pushed
        GCBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        self.view?.addSubview(GCBtn)


        
        //adds 'SkyBorn' title
        skyborn = UILabel(frame: CGRect(x: 0, y: 0, width: width/2, height: 80))
        skyborn.center = CGPoint(x: view.center.x, y: view.frame.size.height * 0.12)
        skyborn.text = "SkyBorn"
        skyborn.textAlignment = NSTextAlignment.Center
        skyborn.font = UIFont(name: "AvenirNextCondensed-Bold", size: 80)
        skyborn.textColor = UIColor.lightTextColor()
        
        self.view?.addSubview(skyborn)
        
        
    }
    
    
    func callGC(){
        
    }
    
    //called to start the game
    func play(){
       //removes buttons from view
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
        skyborn.removeFromSuperview()
        statsBtn.removeFromSuperview()
        howToBtn.removeFromSuperview()
        GCBtn.removeFromSuperview()

        
        //calls the game to be played
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
    
    //called when the user hits 'highscores' button
    func highscoreLabels(){
        skyborn.removeFromSuperview()
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
        statsBtn.removeFromSuperview()
        howToBtn.removeFromSuperview()
        GCBtn.removeFromSuperview()

        
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
        menu = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        menu.center = CGPoint(x: view!.frame.size.width / 2, y: view!.frame.size.height * 0.85)
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
        
        fromScoresPage = true


        
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
        //removes highscore labels if clicked from highscores page
        if(fromScoresPage){
            var index = 0
            while index < 10 {
                labelArr[index].removeFromSuperview()
                index += 1
            }
            highscoreTitle.removeFromSuperview()
        }
        
        //removes stats labels if clicked from stats page
        if(fromStatsPage){
            statsTitle.removeFromSuperview()
            shotsFiredLabel.removeFromSuperview()
            allTimeScoreLabel.removeFromSuperview()
            hitPercentLabel.removeFromSuperview()
            totalEvasionsLabel.removeFromSuperview()
            totalHitsLabel.removeFromSuperview()
            totalGamesLabel.removeFromSuperview()
            avgScoreLabel.removeFromSuperview()
        }
        
        //sets from___page booleans to false
        fromStatsPage = false
        fromScoresPage = false
        
       
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
    
    func showStats(){
        skyborn.removeFromSuperview()
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
        statsBtn.removeFromSuperview()
        howToBtn.removeFromSuperview()
        GCBtn.removeFromSuperview()

        
        //adds main menu button
        menu = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        menu.center = CGPoint(x: view!.frame.size.width / 2, y: view!.frame.size.height * 0.84)
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

        //adds stats title
        statsTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2, height: 80))
        statsTitle.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.18)
        statsTitle.text = "Statistics"
        statsTitle.textAlignment = NSTextAlignment.Center
        statsTitle.font = UIFont(name: "AvenirNextCondensed-Bold", size: 60)
        statsTitle.textColor = UIColor.whiteColor()
        self.view?.addSubview(statsTitle)
        
        allTimeScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        allTimeScoreLabel.text = "Total Score: \(allTimeScore)"
        allTimeScoreLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.3)
        allTimeScoreLabel.textAlignment = NSTextAlignment.Center
        allTimeScoreLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        allTimeScoreLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(allTimeScoreLabel)
        
        totalEvasionsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        totalEvasionsLabel.text = "Total Evasions: \(totalEvasions)"
        totalEvasionsLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.37)
        totalEvasionsLabel.textAlignment = NSTextAlignment.Center
        totalEvasionsLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        totalEvasionsLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(totalEvasionsLabel)
        
        totalHitsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        totalHitsLabel.text = "Total Hits: \(totalHits / 10)"
        totalHitsLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.44)
        totalHitsLabel.textAlignment = NSTextAlignment.Center
        totalHitsLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        totalHitsLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(totalHitsLabel)

        shotsFiredLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        shotsFiredLabel.text = "Shots Fired: \(shotsFired)"
        shotsFiredLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.51)
        shotsFiredLabel.textAlignment = NSTextAlignment.Center
        shotsFiredLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        shotsFiredLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(shotsFiredLabel)
        
        hitPercentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        hitPercentLabel.text = String(NSString(format: "Hit Percentage: %.2f%%", hitPercent))
        hitPercentLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.58)
        hitPercentLabel.textAlignment = NSTextAlignment.Center
        hitPercentLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        hitPercentLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(hitPercentLabel)
        
        totalGamesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        totalGamesLabel.text = "Games Played: \(totalGames)"
        totalGamesLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.65)
        totalGamesLabel.textAlignment = NSTextAlignment.Center
        totalGamesLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        totalGamesLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(totalGamesLabel)
        
        avgScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        avgScoreLabel.text = "Average Score Per Game: \(avgScore)"
        avgScoreLabel.center = CGPoint(x: view!.center.x, y: view!.frame.size.height * 0.72)
        avgScoreLabel.textAlignment = NSTextAlignment.Center
        avgScoreLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 20)
        avgScoreLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(avgScoreLabel)


        
        fromStatsPage = true
    }
    
    func howToPlay(){
        skyborn.removeFromSuperview()
        playBtn.removeFromSuperview()
        scoresBtn.removeFromSuperview()
        statsBtn.removeFromSuperview()
        howToBtn.removeFromSuperview()
        GCBtn.removeFromSuperview()
        
        if let scene = HowToScene(fileNamed:"GameScene") {
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
    
    
}