//
//  GameScene.swift
//  TestingCrossPlatform
//
//  Created by Travis London on 12/31/16.
//  Copyright © 2016 Travis London. All rights reserved.
//

import SpriteKit
import UIKit

class PvPGameScene: DifficultyBasedGameScene {

    fileprivate var currentPlayer = 1
    public var viewController : PvPViewController?
    
    override class func newGameScene() -> PvPGameScene {
        guard let scene = SKScene(fileNamed: "PvPGameScene") as? PvPGameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func setUpScene() {
        super.setUpScene()
        self.viewController?.playerLabel.text = NSLocalizedString("Player One", comment: "Player One")
    }
    
    override func resetGame() {
        super.resetGame()
        self.originalDots.removeAll()
        self.creation = true
        resetBoard()
    }
    
    override func resetBoard() {
        super.resetBoard()
        if(creation) {
            self.removeAllChildren()
        } else {
            self.clearLines()
        }
    }
    
    func switchPlayer() {
        switch currentPlayer {
        case 1:
            currentPlayer = 2
            self.viewController?.playerLabel.text = NSLocalizedString("Player Two", comment: "Player Two")
            break
        case 2:
            currentPlayer = 1
            self.viewController?.playerLabel.text = NSLocalizedString("Player One", comment: "Player One")
            break
        default: break
        }
    }
    
    func switchDifficulty() {
        switch currentDifficulty {
        case 1:
            currentDifficulty = 2
            self.viewController?.difficultyButton.setTitle(NSLocalizedString("Hard", comment: "Hard"), for: UIControlState.normal)
            break
        case 2:
            currentDifficulty = 1
            self.viewController?.difficultyButton.setTitle(NSLocalizedString("Easy", comment: "Easy"), for: UIControlState.normal)
            break
        default: break
        }
    }

    override func performFinish() {
        if(creation) {
            finishForProponent()
        } else {
            finishForOpponent()
        }
    }
    
    func finishForProponent() {
        self.expectedResults = getResults()
        self.switchPlayer()
        self.creation = false
        setDotOfInterest(dot: (GameScene.nilDot as! ShapeNode?)!)
        originalLines.removeAll()
        let lines = children.filter { $0.isKind(of: LineNode.self) }
        for line in lines {
            originalLines.append(line)
        }
        originalDots.removeAll()
        let dots = children.filter { $0.isKind(of: ShapeNode.self) }
        for dot in dots {
            originalDots.append(dot)
        }
        if(currentDifficulty == 1) {
            self.countingDown = true
            countDown(count: 5)
        } else {
            clearLines()
        }
    }
    
    func finishForOpponent() {
        let matched = checkResults()
        viewController?.openResultDialog(result: matched)
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}

