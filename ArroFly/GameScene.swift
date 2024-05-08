//
//  GameScene.swift
//  ArroFly
//
//  Created by Felix Kwan on 11/9/2016.
//  Copyright (c) 2016年 KwFung. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    /* For accommodate iPhone 6 or 6s */
    var scaleFactor: CGFloat!
    
    /* Empty node for packing or detection */
    var obstacle: SKNode!
    var contactNode: SKNode!
    var floor: SKNode!
    var wholeSpace: SKNode!
    var starExplosion: SKNode!
    
    /* Object */
    var space: SKSpriteNode!
    var UFO: SKSpriteNode!
    var star: SKSpriteNode!

    /* Game Control */
    var firstTap: Bool = true
    var gameOverEd: Bool = false
    var pauseEd: Bool = false
    var pauseVelocity: CGVector!
    var randomNumber: NSInteger = 0
    var lastRandomNumber: NSInteger?
    
    /* Control action */
    var spaceMovingThenReset: SKAction!
    var moveObstacleThenRemove: SKAction!
    var spawnThenDelayForever: SKAction!
    var circularMove: SKAction!
    var leftRight: SKAction!
    var rightLeft: SKAction!
    var waitForNext: SKAction!
    var leftRightOneByOne: SKAction!
    var movePathOneByOne: SKAction!
    var leftRightForward: SKAction!
    var LaserOnOff: SKAction!
    
    /* Sound effect */
    var startSound: SKAction!
    var jumpSound: SKAction!
    var deadSound: SKAction!
    var levelSound: SKAction!
    var laserSound: SKAction!
    
    /* UI items */
    var score: NSInteger = 0
    var scoreLabel: SKLabelNode!
    var tappingLabel: SKLabelNode!
    var tappingFinger: SKSpriteNode!
    var pauseLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var showFinalScoreLabel: SKLabelNode!
    var finalScoreLabel: SKLabelNode!
    var showBestScoreLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    var medal: SKSpriteNode!
    var panel: SKSpriteNode!
    var resetButton: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    var homeButton: SKSpriteNode!
    
    /* Obstacle */
    var crossGroup: SKNode!
    var rotatingCrossTexture: SKTexture!
    var rotatingCrossLeft: SKSpriteNode!
    var rotatingCrossRight: SKSpriteNode!
    
    var sunGroup: SKNode!
    var sunTexture: SKTexture!
    var moonTexture: SKTexture!
    var sun: SKSpriteNode!
    var moon: SKSpriteNode!
    
    var shipGroup: SKNode!
    var shipTexture: SKTexture!
    var shipA: SKSpriteNode!
    var shipB: SKSpriteNode!
    var shipC: SKSpriteNode!
    var ship: [SKSpriteNode]!
    
    var yellowGroup: SKNode!
    var yellowUfoTexture: SKTexture!
    var yellowUfoLeft: SKSpriteNode!
    var yellowUfoRight: SKSpriteNode!
    var yellowUfoMore: SKSpriteNode!
    
    var beigeGroup: SKNode!
    var beigeUfoTexture: SKTexture!
    var beigeUfoA: SKSpriteNode!
    var beigeUfoB: SKSpriteNode!
    var beigeUfoC: SKSpriteNode!
    var beigeUfoD: SKSpriteNode!
    var beigeUfo: [SKSpriteNode]!
    
    var blueGroup: SKNode!
    var blueUfoTexture: SKTexture!
    var laserTexture: SKTexture!
    var laserBeamTexture: SKTexture!
    var blueUfoLeft: SKSpriteNode!
    var blueUfoRight: SKSpriteNode!
    var laserLeft: SKSpriteNode!
    var laserRight: SKSpriteNode!
    var laserBeamLeft: SKSpriteNode!
    var laserBeamRight: SKSpriteNode!
    
    var pinkGroup: SKNode!
    var pinkUfoTexture: SKTexture!
    var pinkUfoA: SKSpriteNode!
    var pinkUfoB: SKSpriteNode!
    var pinkUfoC: SKSpriteNode!
    var pinkUfoD: SKSpriteNode!
    var pinkUfo: [SKSpriteNode]!
    
    /* Object category */
    let UFOCategory: UInt32    = 1 << 0
    let obstacleCategory: UInt32 = 1 << 1
    let scoreCategory: UInt32 = 1 << 2
    
    override func didMove(to view: SKView) {
   
        /* Set physicalWorld */
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        
        /* Set scaleFactor to accommodate iPhone 6 or 6s */
        scaleFactor = self.frame.size.width / 320.0
        
        /* Create obstacle, wholeSpace and starExplosion class */
        obstacle = SKNode()
        self.addChild(obstacle)
        wholeSpace = SKNode()
        self.addChild(wholeSpace)
        starExplosion = SKNode()
        self.addChild(starExplosion)
        
        /* Set sound effect */
        jumpSound = SKAction.playSoundFileNamed("Jump.mp3", waitForCompletion: false)
        levelSound = SKAction.playSoundFileNamed("Level.mp3", waitForCompletion: false)
        laserSound = SKAction.playSoundFileNamed("Laser.mp3", waitForCompletion: false)
        deadSound = SKAction.playSoundFileNamed("Dead.mp3", waitForCompletion: true)
        startSound = SKAction.playSoundFileNamed("Start.mp3", waitForCompletion: false)
        self.run(startSound)
        
        /* Create background texture */
        let spaceTexture = SKTexture(imageNamed: "Space")
        spaceTexture.filteringMode = .nearest
        
        /* Set background movement */
        let spaceMoving = SKAction.moveBy( x: 0, y: -self.frame.size.height * 2, duration: TimeInterval(0.01 * self.frame.height))
        let spaceReset = SKAction.moveBy( x: 0, y: self.frame.size.height * 2, duration: TimeInterval(0.0))
        spaceMovingThenReset = SKAction.repeatForever(SKAction.sequence([spaceMoving, spaceReset]))
        
        /* Create 4 background object, run movement, add background into wholeSpace class */
        for i in 0...3 {
            
            space = SKSpriteNode(texture: spaceTexture)
            space.size = CGSize( width: self.frame.width, height: self.frame.height)
            space.position = CGPoint( x: self.frame.width / 2, y: CGFloat(i) * self.frame.height)
            space.zPosition = -100
            space.run(spaceMovingThenReset, withKey: "SpaceMoving")
            wholeSpace.addChild(space)
        }
        
        /* Create score label at corner */
        scoreLabel = SKLabelNode(fontNamed:"KenVector-Future")
        scoreLabel.position = CGPoint( x: self.frame.size.width * 0.1, y: self.frame.size.height * 0.92)
        scoreLabel.zPosition = 100
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 50
        scoreLabel.setScale(scaleFactor)
        scoreLabel.fontColor = UIColor.yellow
        scoreLabel.isHidden = true
        self.addChild(scoreLabel)
        
        /* Create tapping label */
        tappingLabel = SKLabelNode(fontNamed: "KenPixel-Blocks")
        tappingLabel.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.35)
        tappingLabel.zPosition = 100
        tappingLabel.text = "Tap"
        tappingLabel.fontSize = 40
        tappingLabel.setScale(scaleFactor)
        tappingLabel.fontColor = UIColor.green
        tappingLabel.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.3)), SKAction.scale(to: 1.0, duration:TimeInterval(0.3))])))
        self.addChild(tappingLabel)
        
        /* Create tapping finger */
        let tappingFingerTexture = SKTexture(imageNamed: "cursorHand_grey")
        tappingFinger = SKSpriteNode(texture: tappingFingerTexture)
        tappingFinger.setScale(scaleFactor)
        tappingFinger.zPosition = 100
        tappingFinger.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.3 )
        tappingFinger.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.3)), SKAction.scale(to: 1.0, duration:TimeInterval(0.3))])))
        self.addChild(tappingFinger)

        /* Create pause label */
        pauseLabel = SKLabelNode(fontNamed:"KenVector-Future")
        pauseLabel.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        pauseLabel.zPosition = 100
        pauseLabel.text = "Paused"
        pauseLabel.fontSize = 30
        pauseLabel.setScale(scaleFactor)
        pauseLabel.fontColor = UIColor.magenta
        pauseLabel.isHidden = true
        self.addChild(pauseLabel)
        
        /* Create gameover label */
        gameOverLabel = SKLabelNode(fontNamed:"KenVector-Future")
        gameOverLabel.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.74)
        gameOverLabel.zPosition = 100
        gameOverLabel.text = "GameOver"
        gameOverLabel.fontSize = 30
        gameOverLabel.setScale(scaleFactor)
        gameOverLabel.fontColor = UIColor.orange
        gameOverLabel.isHidden = true
        self.addChild(gameOverLabel)
        
        /* Create showFinalScore label */
        showFinalScoreLabel = SKLabelNode(fontNamed:"KenVector-Future")
        showFinalScoreLabel.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.6)
        showFinalScoreLabel.zPosition = 100
        showFinalScoreLabel.text = "SCORE"
        showFinalScoreLabel.fontSize = 20
        showFinalScoreLabel.setScale(scaleFactor)
        showFinalScoreLabel.fontColor = UIColor.gray
        showFinalScoreLabel.isHidden = true
        self.addChild(showFinalScoreLabel)
        
        /* Create final score label */
        finalScoreLabel = SKLabelNode(fontNamed:"KenPixel-Blocks")
        finalScoreLabel.position = CGPoint( x: self.frame.size.width * 0.75, y: self.frame.size.height * 0.59)
        finalScoreLabel.zPosition = 100
        finalScoreLabel.text = ""
        finalScoreLabel.fontSize = 40
        finalScoreLabel.setScale(scaleFactor)
        finalScoreLabel.isHidden = true
        finalScoreLabel.fontColor = UIColor.purple
        self.addChild(finalScoreLabel)
        
        /* Create showBestScore label */
        showBestScoreLabel = SKLabelNode(fontNamed:"KenVector-Future")
        showBestScoreLabel.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.47)
        showBestScoreLabel.zPosition = 100
        showBestScoreLabel.text = "BEST"
        showBestScoreLabel.fontSize = 20
        showBestScoreLabel.setScale(scaleFactor)
        showBestScoreLabel.fontColor = UIColor.gray
        showBestScoreLabel.isHidden = true
        self.addChild(showBestScoreLabel)
        
        /* Create best score label */
        bestScoreLabel = SKLabelNode(fontNamed:"KenPixel-Blocks")
        bestScoreLabel.position = CGPoint( x: self.frame.size.width * 0.75, y: self.frame.size.height * 0.46)
        bestScoreLabel.zPosition = 100
        bestScoreLabel.text = ""
        bestScoreLabel.fontSize = 40
        bestScoreLabel.setScale(scaleFactor)
        bestScoreLabel.fontColor = UIColor.purple
        bestScoreLabel.isHidden = true
        self.addChild(bestScoreLabel)

        /* Create metal panel */
        let panelTexture = SKTexture(imageNamed: "metalPanel_yellow")
        panel = SKSpriteNode(texture: panelTexture)
        panel.setScale(2.5 * scaleFactor)
        panel.zPosition = 50
        panel.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.6 )
        panel.isHidden = true
        self.addChild(panel)
        
        /* Create button for reset scene */
        let resetButtonTexture = SKTexture(imageNamed: "return")
        resetButton = SKSpriteNode(texture: resetButtonTexture)
        resetButton.setScale(0.75 * scaleFactor)
        resetButton.zPosition = 100
        resetButton.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.25 )
        resetButton.isHidden = true
        self.addChild(resetButton)
        
        /* Create button for pause scene */
        let pauseButtonTexture = SKTexture(imageNamed: "pause")
        pauseButton = SKSpriteNode(texture: pauseButtonTexture)
        pauseButton.setScale(0.3 * scaleFactor)
        pauseButton.zPosition = 100
        pauseButton.position = CGPoint( x: self.frame.size.width * 0.9, y: self.frame.size.height * 0.94 )
        pauseButton.isHidden = true
        self.addChild(pauseButton)
        
        /* Create button for home scene */
        let homeButtonTexture = SKTexture(imageNamed: "home")
        homeButton = SKSpriteNode(texture: homeButtonTexture)
        homeButton.setScale(0.4 * scaleFactor)
        homeButton.zPosition = 100
        homeButton.position = CGPoint( x: self.frame.size.width * 0.9, y: self.frame.size.height * 0.94 )
        homeButton.isHidden = true
        self.addChild(homeButton)

        /* Create UFOtexture and UFO object, set UFO into physical body */
        let UFOtexture = SKTexture(imageNamed: "shipGreen_manned")
        UFO = SKSpriteNode(texture: UFOtexture)
        UFO.setScale(0.3 * scaleFactor)
        UFO.position = CGPoint( x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.2 )
        
        UFO.physicsBody = SKPhysicsBody(texture: UFOtexture, size: CGSize( width: UFO.size.width, height: UFO.size.height) )
        UFO.physicsBody?.isDynamic = true
        UFO.physicsBody?.allowsRotation = false
        UFO.physicsBody?.mass = 0.06        // constant mass prevent different scale of UFO generating different mass
        UFO.physicsBody?.categoryBitMask = UFOCategory
        UFO.physicsBody?.contactTestBitMask = obstacleCategory
        UFO.physicsBody?.collisionBitMask = obstacleCategory
        self.addChild(UFO)
        
        /* Set detection area under screen, gameover when UFO position.y < 0 */
        floor = SKNode()
        floor.position = CGPoint( x: self.frame.midX, y: -2 * UFO.size.height )
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: UFO.size.height))
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.categoryBitMask = obstacleCategory
        floor.physicsBody?.contactTestBitMask = UFOCategory
        self.addChild(floor)

        /* Set obstacle movement */
        let distanceToMove = CGFloat(self.frame.size.height)
        let moveObstacle = SKAction.moveBy( x: 0, y: -2 * distanceToMove, duration:TimeInterval(0.02 * distanceToMove))
        let removeObstacle = SKAction.removeFromParent()
        moveObstacleThenRemove = SKAction.sequence([moveObstacle, removeObstacle])
        
        /* Spawn obstacle */
        let spawn = SKAction.run({self.spawnRandomObstacle()})
        let delay = SKAction.wait(forDuration: TimeInterval(5.5 * scaleFactor))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)

        /* Observe pauseGameEd, pass it to AppDelegat when app resign */
        NotificationCenter.default.addObserver(self, selector: #selector(pauseGame), name: NSNotification.Name(rawValue: "CallPauseGame"), object: nil)
        
        /* Call function from view controller */
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showBanner"), object: nil)
    }

    /* Push UFO when tapping*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOverEd == false {
            
            for touch: AnyObject in touches {
                let location = touch.location(in: self)
                
                if firstTap == true {
                    
                    self.run(spawnThenDelayForever, withKey: "ObstacleSpawn")  // Start to spawn obstacle
                    tappingLabel.removeFromParent()                              // remove the label
                    tappingFinger.removeFromParent()
                    pauseButton.isHidden = false                               // Show button and label
                    scoreLabel.isHidden = false
                    self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0)   // Set gravity after first tap
                    UFO.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    UFO.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
                    
                    /* Run jumping sound effect */
                    self.run(jumpSound)
                    
                    firstTap = false
                }
                
                /* Tap on pause, during game play and visible button */
                else if (pauseButton.contains(location) && pauseEd == false && pauseButton.isHidden == false) {
                    
                    pauseGame()
                }
    
                /* Tap on pause, when already paused and visible button */
                else if (pauseButton.contains(location) && pauseEd == true && pauseButton.isHidden == false) {
                    
                    self.speed = 1
                    UFO.physicsBody?.isDynamic = true
                    pauseEd = false
                }
                    
                else if (UFO.position.y < self.frame.height && pauseEd == false) {

                    UFO.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    UFO.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
                    
                    /* Run jumping sound effect */
                    self.run(jumpSound)
                }
            }
        }
        else {
            for touch: AnyObject in touches {
                let location = touch.location(in: self)
                
                /* Tap on reset, when button is visible */
                if resetButton.contains(location) && resetButton.isHidden == false {
                    resetScene()
                }
                
                /* Tap on home, when button is visible */
                else if homeButton.contains(location) && homeButton.isHidden == false {
                    
                    let transition = SKTransition.crossFade(withDuration: 1)
                    let menuScene = MenuScene(size: self.size)
                    self.view?.presentScene(menuScene, transition: transition)
                }
            }
        }
    }
 
    func spawnRotatingCross() {
       
        /* Create SKNode crossPair for packing the whole obstacle, create rotation, 
         create obstacle texture, set obstacle position */
        crossGroup = SKNode()
        let rotation = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration:4))
        let rotationC = SKAction.repeatForever(SKAction.rotate(byAngle: -CGFloat(Double.pi), duration:4))
        rotatingCrossTexture = SKTexture(imageNamed: "RotatingCross")
        
        /* Create left rotating cross */
        rotatingCrossLeft = SKSpriteNode(texture: rotatingCrossTexture)
        rotatingCrossLeft.setScale(0.35 * scaleFactor)
        rotatingCrossLeft.position = CGPoint(x: self.frame.size.width * 0.2, y: 0)
        
        rotatingCrossLeft.physicsBody = SKPhysicsBody(texture: rotatingCrossTexture, size: CGSize( width: rotatingCrossLeft.size.width, height: rotatingCrossLeft.size.height) )
        rotatingCrossLeft.physicsBody?.isDynamic = false
        rotatingCrossLeft.physicsBody?.categoryBitMask = obstacleCategory
        rotatingCrossLeft.physicsBody?.contactTestBitMask = UFOCategory
        rotatingCrossLeft.run(rotation)
        crossGroup.addChild(rotatingCrossLeft)
        
        /* Create right rotating cross */
        rotatingCrossRight = SKSpriteNode(texture: rotatingCrossTexture)
        rotatingCrossRight.setScale(0.35 * scaleFactor)
        rotatingCrossRight.position = CGPoint(x: self.frame.size.width * 0.8, y: 0.65 * rotatingCrossRight.size.height)
        rotatingCrossRight.physicsBody = SKPhysicsBody(texture: rotatingCrossTexture, size: CGSize( width: rotatingCrossRight.size.width, height: rotatingCrossRight.size.height) )
        rotatingCrossRight.physicsBody?.isDynamic = false
        rotatingCrossRight.physicsBody?.categoryBitMask = obstacleCategory
        rotatingCrossRight.physicsBody?.contactTestBitMask = UFOCategory
        rotatingCrossRight.run(rotationC)
        crossGroup.addChild(rotatingCrossRight)
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: rotatingCrossRight.size.height)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: 0.5 * rotatingCrossRight.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        crossGroup.addChild(contactNode)

        crossGroup.position = CGPoint( x: 0, y: self.frame.size.height + rotatingCrossLeft.size.height * 0.5)
        crossGroup.zPosition = -50
        crossGroup.run(moveObstacleThenRemove, withKey: "CrossPairMoving")
        obstacle.addChild(crossGroup)
        
    }
    
    /*
    func spawnRotatingX() {
        
        /* Create xGroup, rotation, obstacle texture */
        xGroup = SKNode()
        let rotation = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration:3.5))
        rotatingXTexture = SKTexture(imageNamed: "RotatingX")
     
        /* Create rotating X */
        rotatingX = SKSpriteNode(texture: rotatingXTexture)
        rotatingX.setScale(0.4 * scaleFactor)
        rotatingX.position = CGPoint(x: self.frame.size.width * 0.15, y: 0 )
        rotatingX.physicsBody = SKPhysicsBody(texture: rotatingXTexture, size: CGSize( width: rotatingX.size.width, height: rotatingX.size.height) )
        rotatingX.physicsBody?.isDynamic = false
        rotatingX.physicsBody?.categoryBitMask = obstacleCategory
        rotatingX.physicsBody?.contactTestBitMask = UFOCategory
        rotatingX.run(rotation)
        xGroup.addChild(rotatingX)
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: rotatingX.size.height * 0.75)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: 0.5 * rotatingX.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        xGroup.addChild(contactNode)
        
        xGroup.position = CGPoint( x: 0, y: self.frame.size.height + rotatingX.size.height / 2)
        xGroup.zPosition = -50
        xGroup.run(moveObstacleThenRemove, withKey: "RotatingXMoving")
        obstacle.addChild(xGroup)

    }
    */
 
    func spawnSun() {
        
        /* Set sunGroup and texture */
        sunGroup = SKNode()
        sunTexture = SKTexture(imageNamed: "sun1")
        moonTexture = SKTexture(imageNamed: "spikeBall1")
        
        /* Set circle path and motion */
        let circle = UIBezierPath(roundedRect: CGRect( x: self.frame.width/4, y: 0, width: self.frame.width * 0.5, height: self.frame.width * 0.5), cornerRadius: self.frame.width * 0.5)
        let followCircle = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: true, duration: 7)
        circularMove = SKAction.repeatForever(followCircle)
        
        /* Create sun */
        sun = SKSpriteNode(texture: sunTexture)
        sun.setScale(0.3 * scaleFactor)
        sun.physicsBody = SKPhysicsBody(texture: sunTexture, size: CGSize( width: sun.size.width, height: sun.size.height) )
        sun.physicsBody?.isDynamic = false
        sun.physicsBody?.categoryBitMask = obstacleCategory
        sun.physicsBody?.contactTestBitMask = UFOCategory
        sun.run(circularMove)
        sunGroup.addChild(sun)
        
        /* Create moon */
        moon = SKSpriteNode(texture: moonTexture)
        moon.setScale(0.3 * scaleFactor)
        moon.physicsBody = SKPhysicsBody(texture: moonTexture, size: CGSize( width: moon.size.width, height: moon.size.height) )
        moon.physicsBody?.isDynamic = false
        moon.physicsBody?.categoryBitMask = obstacleCategory
        moon.physicsBody?.contactTestBitMask = UFOCategory
        moon.isHidden = true
        let waitForSun = SKAction.wait(forDuration: 2.5)            // Hide moon when waiting
        let showMoon = SKAction.run({ self.moon.isHidden = false })
        moon.run(SKAction.sequence([waitForSun, showMoon, circularMove]))
        sunGroup.addChild(moon)
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: self.frame.width/2)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: self.frame.width/4))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        sunGroup.addChild(contactNode)
        
        sunGroup.position = CGPoint( x: 0, y: self.frame.size.height + self.frame.size.width * 0.75)
        sunGroup.zPosition = -50
        sunGroup.run(moveObstacleThenRemove, withKey: "SunMoving")
        obstacle.addChild(sunGroup)
    }
    func spawnShip() {
        
        /* Set shipGroup and texture */
        shipGroup = SKNode()
        shipTexture = SKTexture(imageNamed: "spaceShips")
        
        /* Create array that contains four ship */
        shipA = SKSpriteNode(texture: shipTexture)
        shipB = SKSpriteNode(texture: shipTexture)
        shipC = SKSpriteNode(texture: shipTexture)
        ship = [shipA, shipB, shipC]
    
        /* Set motion */
        let distance = self.frame.width * 1.2
        let radian = (CGFloat(Double.pi) * 0.5) + atan2(self.frame.size.height * 0.25, distance)
        let rotateRight = SKAction.rotate(toAngle: radian, duration: TimeInterval(0))
        let rotateLeft = SKAction.rotate(toAngle: -radian, duration: TimeInterval(0))
        let leftToRight = SKAction.moveBy(x: distance, y: self.frame.size.height * 0.25, duration: TimeInterval(0.0035 * distance))
        let rightToLeft = SKAction.moveBy(x: -distance, y: self.frame.size.height * 0.25, duration: TimeInterval(0.0035 * distance))
        let origin = SKAction.moveBy(x: 0, y: -self.frame.size.height * 0.5, duration: TimeInterval(0))
        let leftRight = SKAction.repeatForever(SKAction.sequence([rotateRight, leftToRight, rotateLeft, rightToLeft, origin]))
        
        /* Set ship property and run motion */
        for i in 0...2 {
            
            ship[i].setScale(0.1 * scaleFactor)
            ship[i].position = CGPoint( x: -ship[i].size.height, y: 0)
            ship[i].physicsBody = SKPhysicsBody(texture: shipTexture, size: CGSize( width: ship[i].size.width, height: ship[i].size.height) )
            ship[i].physicsBody?.isDynamic = false
            ship[i].physicsBody?.categoryBitMask = obstacleCategory
            ship[i].physicsBody?.contactTestBitMask = UFOCategory
            waitForNext = SKAction.wait(forDuration: TimeInterval(i))
            leftRightForward = SKAction.sequence([waitForNext, leftRight])
            ship[i].run(leftRightForward)
            shipGroup.addChild(ship[i])
        }
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: self.frame.size.height * 0.5)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: ship[0].size.height/4))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        shipGroup.addChild(contactNode)
        
        shipGroup.position = CGPoint( x: 0, y: self.frame.size.height + ship[0].size.width/2 )
        shipGroup.zPosition = -50
        shipGroup.run(moveObstacleThenRemove, withKey: "ShipMoving")
        obstacle.addChild(shipGroup)
    }
    
    func spawnYellowUfo() {
        
        /* Set yellowGroup and texture */
        yellowGroup = SKNode()
        yellowUfoTexture = SKTexture(imageNamed: "shipYellow_manned")
        
        /* Set motion */
        let distance = self.frame.width * 0.9
        let leftToRight = SKAction.moveBy(x: distance, y: 0, duration: TimeInterval(0.004 * distance))
        let rightToLeft = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.004 * distance))
        leftRight = SKAction.repeatForever(SKAction.sequence([leftToRight, rightToLeft]))
        rightLeft = SKAction.repeatForever(SKAction.sequence([rightToLeft, leftToRight]))
        
        /* Create left yellowUfo */
        yellowUfoLeft = SKSpriteNode(texture: yellowUfoTexture)
        yellowUfoLeft.setScale(0.3 * scaleFactor)
        yellowUfoLeft.position = CGPoint( x: self.frame.width * 0.05, y: 0)
        yellowUfoLeft.physicsBody = SKPhysicsBody(texture: yellowUfoTexture, size: CGSize( width: yellowUfoLeft.size.width, height: yellowUfoLeft.size.height) )
        yellowUfoLeft.physicsBody?.isDynamic = false
        yellowUfoLeft.physicsBody?.categoryBitMask = obstacleCategory
        yellowUfoLeft.physicsBody?.contactTestBitMask = UFOCategory
        yellowUfoLeft.run(leftRight)
        yellowGroup.addChild(yellowUfoLeft)
        
        /* Create right yellowUfo */
        yellowUfoRight = SKSpriteNode(texture: yellowUfoTexture)
        yellowUfoRight.setScale(0.3 * scaleFactor)
        yellowUfoRight.position = CGPoint( x: self.frame.width * 0.95, y: yellowUfoRight.size.height * 2)
        yellowUfoRight.physicsBody = SKPhysicsBody(texture: yellowUfoTexture, size: CGSize( width: yellowUfoRight.size.width, height: yellowUfoRight.size.height) )
        yellowUfoRight.physicsBody?.isDynamic = false
        yellowUfoRight.physicsBody?.categoryBitMask = obstacleCategory
        yellowUfoRight.physicsBody?.contactTestBitMask = UFOCategory
        yellowUfoRight.run(rightLeft)
        yellowGroup.addChild(yellowUfoRight)
        
        /* Create one more yellowUfo */
        yellowUfoMore = SKSpriteNode(texture: yellowUfoTexture)
        yellowUfoMore.setScale(0.3 * scaleFactor)
        yellowUfoMore.position = CGPoint( x: self.frame.width * 0.05, y: yellowUfoMore.size.height * 4)
        yellowUfoMore.physicsBody = SKPhysicsBody(texture: yellowUfoTexture, size: CGSize( width: yellowUfoMore.size.width, height: yellowUfoMore.size.height) )
        yellowUfoMore.physicsBody?.isDynamic = false
        yellowUfoMore.physicsBody?.categoryBitMask = obstacleCategory
        yellowUfoMore.physicsBody?.contactTestBitMask = UFOCategory
        yellowUfoMore.run(leftRight)
        yellowGroup.addChild(yellowUfoMore)
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: yellowUfoLeft.size.height * 6)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: yellowUfoLeft.size.height/2 ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        yellowGroup.addChild(contactNode)
        
        yellowGroup.position = CGPoint( x: 0, y: self.frame.size.height + yellowUfoLeft.size.height/2 )
        yellowGroup.zPosition = -50
        yellowGroup.run(moveObstacleThenRemove, withKey: "YellowUfoMoving")
        obstacle.addChild(yellowGroup)
    }
    
    func spawnBeigeUfo() {
        
        /* Set beigeGroup and texture */
        beigeGroup = SKNode()
        beigeUfoTexture = SKTexture(imageNamed: "shipBeige_manned")
        
        /* Set motion */
        let distance = self.frame.width * 1.2
        let leftToRight = SKAction.moveBy(x: distance, y: 0, duration: TimeInterval(0.005 * distance))
        let rightToLeft = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.005 * distance))
        let leftRight = SKAction.repeatForever(SKAction.sequence([leftToRight, rightToLeft]))
        
        /* Create array that contains four beigeUfo */
        beigeUfoA = SKSpriteNode(texture: beigeUfoTexture)
        beigeUfoB = SKSpriteNode(texture: beigeUfoTexture)
        beigeUfoC = SKSpriteNode(texture: beigeUfoTexture)
        beigeUfoD = SKSpriteNode(texture: beigeUfoTexture)
        beigeUfo = [beigeUfoA, beigeUfoB, beigeUfoC, beigeUfoD]
        
        /* Set beigeUfo property and run motion */
        for i in 0...3 {
 
            beigeUfo[i].setScale(0.3 * scaleFactor)
            beigeUfo[i].position = CGPoint( x: -beigeUfo[i].size.width/2, y: beigeUfo[i].size.height * CGFloat(i))
            beigeUfo[i].physicsBody = SKPhysicsBody(texture: beigeUfoTexture, size: CGSize( width: beigeUfo[i].size.width, height: beigeUfo[i].size.height) )
            beigeUfo[i].physicsBody?.isDynamic = false
            beigeUfo[i].physicsBody?.categoryBitMask = obstacleCategory
            beigeUfo[i].physicsBody?.contactTestBitMask = UFOCategory
            waitForNext = SKAction.wait(forDuration: TimeInterval(i))
            leftRightOneByOne = SKAction.sequence([waitForNext, leftRight])
            beigeUfo[i].run(leftRightOneByOne)
            beigeGroup.addChild(beigeUfo[i])
        }
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: beigeUfo[0].size.height * 3)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: beigeUfo[0].size.height/2))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        beigeGroup.addChild(contactNode)
        
        beigeGroup.position = CGPoint( x: 0, y: self.frame.size.height + beigeUfo[0].size.height/2 )
        beigeGroup.zPosition = -50
        beigeGroup.run(moveObstacleThenRemove, withKey: "BeigeUfoMoving")
        obstacle.addChild(beigeGroup)
    }
    
    func spawnBlueUfo() {
        
        /* Set blueGroup and texture */
        blueGroup = SKNode()
        blueUfoTexture = SKTexture(imageNamed: "shipBlue_manned")
        laserTexture = SKTexture(imageNamed: "laserBlueBurst")
        laserBeamTexture = SKTexture(imageNamed: "laserBlueHorizontal" )
        
        /* Create two blueUfo and laserSource*/
        blueUfoLeft = SKSpriteNode(texture: blueUfoTexture)
        blueUfoLeft.setScale(0.3 * scaleFactor)
        blueUfoLeft.position = CGPoint( x: self.frame.width * 0.1, y: blueUfoLeft.size.height * 4)
        blueUfoRight = SKSpriteNode(texture: blueUfoTexture)
        blueUfoRight.setScale(0.3 * scaleFactor)
        blueUfoRight.position = CGPoint( x: self.frame.width * 0.9, y: 0)
        laserLeft = SKSpriteNode(texture: laserTexture)
        laserLeft.setScale(0.3 * scaleFactor)
        laserLeft.position = CGPoint( x: self.frame.width * 0.18, y: blueUfoLeft.size.height * 4)
        laserRight = SKSpriteNode(texture: laserTexture)
        laserRight.setScale(0.3 * scaleFactor)
        laserRight.position = CGPoint( x: self.frame.width * 0.82, y: 0)
        blueGroup.addChild(blueUfoLeft)
        blueGroup.addChild(blueUfoRight)
        blueGroup.addChild(laserLeft)
        blueGroup.addChild(laserRight)
        
        /* Set laserBeam position and scale */
        laserBeamLeft = SKSpriteNode(texture: laserBeamTexture)
        laserBeamLeft.setScale(0.3 * scaleFactor)
        laserBeamLeft.xScale = (self.frame.size.width / laserBeamLeft.size.width)
        laserBeamLeft.anchorPoint = CGPoint( x: 0, y: 0.5)
        laserBeamLeft.position = CGPoint( x: self.frame.width * 0.2, y: blueUfoLeft.size.height * 4)
        laserBeamRight = SKSpriteNode(texture: laserBeamTexture)
        laserBeamRight.setScale(0.3 * scaleFactor)
        laserBeamRight.anchorPoint = CGPoint( x: 1, y: 0.5)
        laserBeamRight.xScale = (self.frame.size.width / laserBeamRight.size.width)
        laserBeamRight.position = CGPoint( x: self.frame.width * 0.8, y: 0)
        
        /* Set physical property of laserBeam */
        laserBeamLeft.physicsBody = SKPhysicsBody(texture: laserBeamTexture, size: CGSize( width: laserBeamLeft.size.width, height: laserBeamLeft.size.height ))
        laserBeamLeft.physicsBody?.isDynamic = false
        laserBeamLeft.physicsBody?.categoryBitMask = obstacleCategory
        laserBeamLeft.physicsBody?.contactTestBitMask = UFOCategory
        laserBeamRight.physicsBody = SKPhysicsBody(texture: laserBeamTexture, size: CGSize( width: laserBeamRight.size.width, height: laserBeamRight.size.height ))
        laserBeamRight.physicsBody?.isDynamic = false
        laserBeamRight.physicsBody?.categoryBitMask = obstacleCategory
        laserBeamRight.physicsBody?.contactTestBitMask = UFOCategory
        
        /* Set laser on off period */
        let leftLaserOn = SKAction.run({ self.blueGroup.addChild(self.laserBeamLeft) })
        let rightLaserOn = SKAction.run({ self.blueGroup.addChild(self.laserBeamRight) })
        let leftLaserOff = SKAction.run({ self.laserBeamLeft.removeFromParent() })
        let rightLaserOff = SKAction.run({ self.laserBeamRight.removeFromParent() })
        let waitForLaser = SKAction.wait(forDuration: TimeInterval(1.5))
        let runLaserSound = SKAction.run({ self.run(self.laserSound) })
        let leftLaserOnOff = SKAction.repeatForever(SKAction.sequence([leftLaserOn, runLaserSound, waitForLaser, leftLaserOff, waitForLaser]))
        let rightLaserOnOff = SKAction.repeatForever(SKAction.sequence([waitForLaser, rightLaserOn, runLaserSound,waitForLaser, rightLaserOff]))
        LaserOnOff = SKAction.group([leftLaserOnOff, rightLaserOnOff])
        blueGroup.run(LaserOnOff, withKey: "Laser")
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: blueUfoLeft.size.height * 5)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: blueUfoLeft.size.height/2 ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        blueGroup.addChild(contactNode)
        
        blueGroup.position = CGPoint( x: 0, y: self.frame.size.height + blueUfoLeft.size.height/2 )
        blueGroup.zPosition = -50
        blueGroup.run(moveObstacleThenRemove, withKey: "BlueUfoMoving")
        obstacle.addChild(blueGroup)
    }
    
    func spawnPinkUfo() {
        
        /* Set pinkGroup and texture */
        pinkGroup = SKNode()
        pinkUfoTexture = SKTexture(imageNamed: "shipPink_manned")
        
        /* Set path */
        let path = UIBezierPath()
        let startPoint = CGPoint( x: -pinkUfoTexture.size().width * 0.15 * scaleFactor, y: 0)
        let endPoint = CGPoint( x: self.frame.size.width * 1.2, y: 0)
        let controlPointA = CGPoint( x: self.frame.size.width * 0.3, y: -self.frame.size.height * 0.5)
        let controlPointB = CGPoint( x: self.frame.size.width * 0.9, y: self.frame.size.height * 0.5)
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: controlPointA, controlPoint2: controlPointB)
        let followPath = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, duration: 4)
        let origin = SKAction.move(to: startPoint, duration: TimeInterval(0))
        let movePath = SKAction.repeatForever(SKAction.sequence([followPath, origin]))
        
        /* Create array that contains four pinkUfo */
        pinkUfoA = SKSpriteNode(texture: pinkUfoTexture)
        pinkUfoB = SKSpriteNode(texture: pinkUfoTexture)
        pinkUfoC = SKSpriteNode(texture: pinkUfoTexture)
        pinkUfoD = SKSpriteNode(texture: pinkUfoTexture)
        pinkUfo = [pinkUfoA, pinkUfoB, pinkUfoC, pinkUfoD]
        
        /* Set pinkUfo property and run motion */
        for i in 0...3 {
            
            pinkUfo[i].setScale(0.3 * scaleFactor)
            pinkUfo[i].position = CGPoint( x: -pinkUfo[i].size.width/2, y: 0)
            pinkUfo[i].physicsBody = SKPhysicsBody(texture: pinkUfoTexture, size: CGSize( width: pinkUfo[i].size.width, height: pinkUfo[i].size.height) )
            pinkUfo[i].physicsBody?.isDynamic = false
            pinkUfo[i].physicsBody?.categoryBitMask = obstacleCategory
            pinkUfo[i].physicsBody?.contactTestBitMask = UFOCategory
            waitForNext = SKAction.wait(forDuration: TimeInterval(i))
            movePathOneByOne = SKAction.sequence([waitForNext, movePath])
            pinkUfo[i].run(movePathOneByOne)
            pinkGroup.addChild(pinkUfo[i])
        }
        
        /* Create detection area for score */
        contactNode = SKNode()
        contactNode.position = CGPoint( x: self.frame.midX, y: pinkUfo[0].size.height * 3)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: self.frame.size.width, height: pinkUfo[0].size.height/2))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = UFOCategory
        pinkGroup.addChild(contactNode)
        
        pinkGroup.position = CGPoint( x: 0, y: self.frame.size.height + pinkUfo[0].size.height/2 )
        pinkGroup.zPosition = -50
        pinkGroup.run(moveObstacleThenRemove, withKey: "PinkUfoMoving")
        obstacle.addChild(pinkGroup)
    }
    
    func spawnRandomObstacle() {
        
        /* Generate random number for random obstacle spawn, repeat until new randomNumber generated */
        repeat {
            randomNumber = Int(arc4random_uniform(7)) + 1
        } while randomNumber == lastRandomNumber
        switch randomNumber {
        case 1 :
            spawnRotatingCross()
            lastRandomNumber = 1
        case 2 :
            spawnSun()
            lastRandomNumber = 2
        case 3 :
            spawnShip()
            lastRandomNumber = 3
        case 4 :
            spawnYellowUfo()
            lastRandomNumber = 4
        case 5 :
            spawnBeigeUfo()
            lastRandomNumber = 5
        case 6 :
            spawnBlueUfo()
            lastRandomNumber = 6
        case 7 :
            spawnPinkUfo()
            lastRandomNumber = 7
        default :
            return
        }
    }
    
    func addScore() {
        
        /* Add score procedure */
        score += 1
        scoreLabel.text = String(score)
        
        /* Larger score label for second */
        scoreLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.2)), SKAction.scale(to: 1.0, duration:TimeInterval(0.2))]))
        
        /* Set level up sound */
        self.run(levelSound)
    }
    
    func gameOver() {
        
        gameOverEd = true
        
        /* Remove obstacle spawn and movement */
        self.removeAction(forKey: "ObstacleSpawn")
        crossGroup?.removeAction(forKey: "CrossPairMoving")
        sunGroup?.removeAction(forKey: "SunMoving")
        shipGroup?.removeAction(forKey: "ShipMoving")
        yellowGroup?.removeAction(forKey: "YellowUfoMoving")
        beigeGroup?.removeAction(forKey: "BeigeUfoMoving")
        blueGroup?.removeAllActions()
        pinkGroup?.removeAction(forKey: "PinkUfoMoving")
        
        /* Stop moving space */
        wholeSpace.isPaused = true
        
        /* UFO explode when collide with obstacle */
        explosion()
        
        /* Delay for 2 second then show gameover display */
        let gameOverDelay = SKAction.wait(forDuration: TimeInterval(2))
        let delayThenDisplay = SKAction.sequence([gameOverDelay, SKAction.run({self.gameOverDisplay()})])
        self.run(delayThenDisplay)
    }
    
    func explosion() {
        
        /* Create star texture */
        let starTexture = SKTexture(imageNamed: "starGold")
        
        /* Create numerous star */
        for _ in 0...20 {
            
            star = SKSpriteNode(texture: starTexture)
            
            /* Set random size of star */
            let randomSize = CGFloat(drand48() / 3)
            
            /* Set random distance, value may be negative/
            Negative or positive result = Int(arc4random_uniform(upperValue - lowerValue + 1)) + lowerValue
            In this case, randomDistance = CGFloat(arc4random_uniform(400 -  (-400) + 1) + (-400)) */
            let randomDistanceX = CGFloat(arc4random_uniform(801)) - 400
            let randomDistanceY = CGFloat(arc4random_uniform(801)) - 400
            
            /* Create explosion animation */
            let fadeOut = SKAction.fadeOut(withDuration: 2)
            let moveRandom = SKAction.moveBy( x: randomDistanceX, y: randomDistanceY, duration: 2)
            let explode = SKAction.group([fadeOut, moveRandom])
            
            star.setScale(randomSize * scaleFactor)
            star.zPosition = 100
            star.position = UFO.position
            star.run(explode)
            starExplosion.addChild(star)
        }
        
        /* Remove UFO */
        UFO.removeFromParent()
        
        /* Run gameover sound effect */
        self.run(deadSound)
    }
    
    func gameOverDisplay() {
        
        /* Store or load best score */
        let userDefaults = UserDefaults.standard
        let bestScore = userDefaults.integer(forKey: "BestScore")
        if score > bestScore {
            
            userDefaults.set(score, forKey: "BestScore")
            bestScoreLabel.text = String(score)
            bestScoreLabel.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.5)), SKAction.scale(to: 1.0, duration:TimeInterval(0.5))])))
            finalScoreLabel.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.5)), SKAction.scale(to: 1.0, duration:TimeInterval(0.5))])))
        }
        else {
            bestScoreLabel.text = String(bestScore)
        }
        
        /* Show label, button and change score, hide pause button*/
        gameOverLabel.isHidden = false
        showFinalScoreLabel.isHidden = false
        finalScoreLabel.isHidden = false
        finalScoreLabel.text = String(score)
        showBestScoreLabel.isHidden = false
        bestScoreLabel.isHidden = false
        panel.isHidden = false
        resetButton.isHidden = false
        resetButton.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.2, duration:TimeInterval(0.5)), SKAction.scale(to: 1.0, duration:TimeInterval(0.5))])))
        homeButton.isHidden = false
        pauseButton.isHidden = true
        scoreLabel.isHidden = true
        
        /* Create medal, change medalType each 5 levels */
        var medalType = score / 5
        if medalType > 9 { medalType = 9}
        let medalTexture = SKTexture(imageNamed: "Medal\(medalType)")
        medal = SKSpriteNode(texture: medalTexture)
        medal.setScale(1.2 * scaleFactor)
        medal.zPosition = 100
        medal.position = CGPoint( x: self.frame.size.width * 0.25, y: self.frame.size.height * 0.55 )
        self.addChild(medal)
        
        /* Occasionally show interstitial ads */
        let randomAd = arc4random_uniform(10)
        if randomAd < 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAd"), object: nil)
        }
    }
    
    func resetScene() {
        
        /* Directly reload GameScene */
        let transition = SKTransition.crossFade(withDuration: 1)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        /* UFO contact with score category */
        if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory {
            
            /* Remove contactNode to prevent adding score again */
            contact.bodyA.node!.removeFromParent()
            addScore()
        }
        else if ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
            
            contact.bodyB.node!.removeFromParent()
            addScore()
        }
        else { gameOver() }
    }
    
    @objc func pauseGame() {
        
        /* This function may pass to AppDelegate, when application resign, so it must ensure false pauseEd, not yet GameOver, already first tap to prevent duplicate call of pauseGame() or error, pauseEd set to true to show pauseLabel */
        if !pauseEd && !gameOverEd && !firstTap {
            pauseEd = true
            UFO.physicsBody?.isDynamic = false
            self.speed = 0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        /* Called before each frame is rendered */
        if pauseEd {
            pauseLabel.isHidden = false
        }
        else { pauseLabel.isHidden = true }
        
    }
}
