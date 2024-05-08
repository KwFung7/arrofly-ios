//
//  NameScene.swift
//  ArroFly
//
//  Created by Felix Kwan on 21/9/2016.
//  Copyright © 2016年 KwFung. All rights reserved.
//

import SpriteKit

class NameScene: SKScene {

    var scaleFactor: CGFloat!
    var nameLabel: SKLabelNode!
    override func didMove(to view: SKView) {
        
        /* Set scaleFactor to accommodate iPhone 6 or 6s */
        scaleFactor = self.frame.size.width / 320.0
        
        /* Create name label */
        nameLabel = SKLabelNode(fontNamed:"KenVector-Future")
        nameLabel.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        nameLabel.zPosition = 100
        nameLabel.text = "KwFung"
        nameLabel.fontSize = 50
        nameLabel.setScale(scaleFactor)
        nameLabel.fontColor = UIColor.black
        self.addChild(nameLabel)
        
        /* Set backgroundColor for second */
        self.backgroundColor = UIColor( red: 0/255, green: 170/255, blue: 100/255, alpha: 1.0)
        
        /* Transition to MenuScene*/
        let wait = SKAction.wait(forDuration: TimeInterval(2))
        let transition = SKTransition.crossFade(withDuration: 1)
        let menuScene = MenuScene(size: self.size)
        let toMenu = SKAction.run({ self.view?.presentScene(menuScene, transition: transition) })
        self.run(SKAction.sequence([ wait, toMenu]))
    }
}
