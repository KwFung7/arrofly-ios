//
//  MenuScene.swift
//  ArroFly
//
//  Created by Felix Kwan on 16/9/2016.
//  Copyright © 2016年 KwFung. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var scaleFactor: CGFloat!
    var spaceMovingThenReset: SKAction!
    var wholeSpace: SKNode!
    var space: SKSpriteNode!
    var nameLabel: SKLabelNode!
    var gameName: SKLabelNode!
    var kenneyNl: SKLabelNode!
    var startButton: SKSpriteNode!
    var UFO: SKSpriteNode!
    var sun: SKSpriteNode!
    var moon: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        /* Set scaleFactor to accommodate iPhone 6 or 6s */
        scaleFactor = self.frame.size.width / 320.0

        /* Create wholeSpace class */
        wholeSpace = SKNode()
        self.addChild(wholeSpace)
        
        /* Create background texture */
        let spaceTexture = SKTexture(imageNamed: "Space")
        spaceTexture.filteringMode = .nearest

        /* Set background movement */
        let spaceMoving = SKAction.moveBy( x: 0, y: -self.frame.size.height * 2, duration: TimeInterval(0.01 * self.frame.height))
        let spaceReset = SKAction.moveBy( x: 0, y: self.frame.size.height * 2, duration: TimeInterval(0.0))
        spaceMovingThenReset = SKAction.repeatForever(SKAction.sequence([spaceMoving, spaceReset]))
        
        /* Create 4 background object, run movement, add background into moving class */
        for i in 0...3 {
            
            space = SKSpriteNode(texture: spaceTexture)
            space.size = CGSize( width: self.frame.width, height: self.frame.height)
            space.position = CGPoint( x: self.frame.width / 2, y: CGFloat(i) * self.frame.height)
            space.zPosition = -100
            space.run(spaceMovingThenReset, withKey: "SpaceMoving")
            wholeSpace.addChild(space)
        }
        
        /* Create game name label */
        gameName = SKLabelNode(fontNamed:"KenPixel-Blocks")
        gameName.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.65)
        gameName.zPosition = 100
        gameName.text = "ArroFly"
        gameName.fontSize = 55
        gameName.setScale(scaleFactor)
        gameName.fontColor = UIColor.orange
        self.addChild(gameName)
        
        /* Create kenney.nl label */
        kenneyNl = SKLabelNode(fontNamed:"KenVector_Future")
        kenneyNl.position = CGPoint( x: self.frame.size.width * 0.75, y: self.frame.size.height * 0.95)
        kenneyNl.zPosition = 100
        kenneyNl.text = "@ Graphics from Kenney.nl"
        kenneyNl.fontSize = 8
        kenneyNl.setScale(scaleFactor)
        kenneyNl.fontColor = UIColor.gray
        self.addChild(kenneyNl)
        
        /* Create UFOtexture and UFO object */
        let UFOtexture = SKTexture(imageNamed: "shipGreen_manned")
        UFO = SKSpriteNode(texture: UFOtexture)
        UFO.setScale(0.3 * scaleFactor)
        UFO.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.4 )
        self.addChild(UFO)
        
        /* Move UFO up and down */
        let up = SKAction.move( to: CGPoint( x: self.frame.size.width * 0.5, y: self.frame.height * 0.45), duration: TimeInterval(1.5))
        let down = SKAction.move( to: CGPoint( x: self.frame.size.width * 0.5, y: self.frame.height * 0.4), duration: TimeInterval(1.5))
        let upAndDown = SKAction.repeatForever(SKAction.sequence([up, down]))
        UFO.run(upAndDown)
        
        /* Set sun and moon texture */
        let sunTexture = SKTexture(imageNamed: "sun1")
        let moonTexture = SKTexture(imageNamed: "spikeBall1")
        
        /* Set circle path and motion */
        let circle = UIBezierPath(roundedRect: CGRect( x: self.frame.width/4, y: 0, width: self.frame.width * 0.5, height: self.frame.width * 0.5), cornerRadius: self.frame.width * 0.5)
        let followCircle = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: true, duration: 5)
        let circularMove = SKAction.repeatForever(followCircle)
        
        /* Create sunGroup and sun */
        let sunGroup = SKNode()
        self.addChild(sunGroup)
        sun = SKSpriteNode(texture: sunTexture)
        sun.setScale(0.3 * scaleFactor)
        sun.run(circularMove)
        sunGroup.addChild(sun)
        
        /* Create moon */
        moon = SKSpriteNode(texture: moonTexture)
        moon.setScale(0.3 * scaleFactor)
        moon.isHidden = true
        let waitForSun = SKAction.wait(forDuration: 2.5)            // Hide moon when waiting
        let showMoon = SKAction.run({ self.moon.isHidden = false })
        moon.run(SKAction.sequence([waitForSun, showMoon, circularMove]))
        sunGroup.addChild(moon)
        
        /* Move sunGroup */
        let distance = self.frame.height * 0.8
        let moveObstacle = SKAction.moveBy( x: 0, y: -distance, duration:TimeInterval(0.01 * distance))
        sunGroup.position = CGPoint(x: 0, y: self.frame.size.height + self.frame.size.width * 0.75 )
        sunGroup.run(moveObstacle)
        
        /* Create start button */
        let startButtonTexture = SKTexture(imageNamed: "StartButton")
        startButton = SKSpriteNode(texture: startButtonTexture)
        startButton.setScale(scaleFactor)
        startButton.zPosition = 100
        startButton.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.2 )
        startButton.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.2, duration:TimeInterval(0.5)), SKAction.scale(to: 1.0, duration:TimeInterval(0.5))])))
        self.addChild(startButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if startButton.contains(location){
                let transition = SKTransition.crossFade(withDuration: 1)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
