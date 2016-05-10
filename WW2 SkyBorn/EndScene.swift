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
    var blur : UIBlurEffect!
    var blurView : UIVisualEffectView!
    
    
    override func didMoveToView(view: SKView) {
        //blurs GameScene background
        blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurView)
        
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
        self.view?.presentScene(GameScene())
        restart.removeFromSuperview()
        blurView.removeFromSuperview()
        
    }
    
}