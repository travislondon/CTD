//
//  DifficultyBasedGameScene.swift
//  Dots
//
//  Created by Travis London on 1/13/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class DifficultyBasedGameScene : GameScene {
    var countDownLabel : SKLabelNode?
    var currentDifficulty = 1
    var expectedResults = ""
    var originalLines : Array<SKNode> = []
    var originalDots : Array<SKNode> = []

    override func setUpScene() {
        super.setUpScene()
        self.countDownLabel = SKLabelNode.init()
        if let countDownLabel = self.countDownLabel {
            countDownLabel.fontName = "Arial"
            countDownLabel.fontColor = SKColor.cyan
            countDownLabel.fontSize = 60
        }        
    }

    override func resetBoard() {
        super.resetBoard()
    }

    func checkResults() -> Bool {
        let results = getResults()
        if(expectedResults == results) {
            return true
        }
        return false
    }

    func getCurrentDifficulty() -> Int {
        return currentDifficulty
    }
    
    func restoreStart() {
        clearLines()
        if(currentDifficulty == 1) {
            for line in originalLines {
                addChild(line)
            }
        }
    }
    
    func restoreDots() {
        clearDots()
        for dot in originalDots {
            addChild(dot)
        }
    }
    
    func clearDots() {
        let dots = children.filter { $0.isKind(of: ShapeNode.self) }
        removeChildren(in: dots)
    }
        
    fileprivate var count : Int = 0
    func countDown(count: Int) {
        self.count = count
        countDownLabel?.horizontalAlignmentMode = .center
        countDownLabel?.verticalAlignmentMode = .baseline
        countDownLabel?.position = CGPoint(x: 0, y: 0)
        countDownLabel?.fontColor = SKColor.cyan
        countDownLabel?.fontSize = size.height / 20
        countDownLabel?.zPosition = 2
        countDownLabel?.text = NSLocalizedString("CountDown", comment: "Starting in") + " \(count)..."
        
        addChild(countDownLabel!)
        
        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                  SKAction.run(countDownAction)])
        
        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: count),
                               SKAction.run(endCountdown)]))
        
    }
    
    func countDownAction() {
        count -= 1
        if(count >= 3) {
            clearDots()
        } else {
            restoreDots()
        }
        countDownLabel?.text = NSLocalizedString("CountDown", comment: "Starting in") + " \(count)..."
    }
    
    func endCountdown() {
        countDownLabel?.removeFromParent()
        clearLines()
        self.countingDown = false
    }
    
}
