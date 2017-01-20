//
//  GameScene.swift
//  TestingCrossPlatform
//
//  Created by Travis London on 12/31/16.
//  Copyright © 2016 Travis London. All rights reserved.
//

import SpriteKit
import UIKit

class ChallengeGameScene: DifficultyBasedGameScene {
    
    public var viewController : ChallengeViewController?
    
    override class func newGameScene() -> ChallengeGameScene {
        guard let scene = SKScene(fileNamed: "ChallengeGameScene") as? ChallengeGameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func setUpScene() {
        super.setUpScene()
        creation = false
        // TODO: Load level file chosen, or file chosen by user
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func resetBoard() {
        super.resetBoard()
        clearLines()
    }
    
    func clearBoard() {
        clearDots()
        clearLines()
    }
    
    func completeLoad() {
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
        // store original result
        expectedResults = getResults()
        // clear all lines drawn with original
        clearLines()
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
    
    func addChildren(nodes: [SKShapeNode]) {
        for node in nodes {
            self.addChild(node)
        }
    }
    
    override func performFinish() {
        finish()
    }
    
    func finish() {
        let matched = checkResults()
        viewController?.openResultDialog(result: matched)
    }

    override func restoreStart() {
        clearLines()
        if(currentDifficulty == 1) {
            for line in originalLines {
                addChild(line)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
