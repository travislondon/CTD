//
//  PvPViewController.swift
//  TestingCrossPlatform
//
//  Created by Travis London on 12/31/16.
//  Copyright © 2016 Travis London. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PvPViewController: DifficultyBasedViewController {
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var difficultyButton: UIButton!

    @IBAction func handleResetPressed(_ sender: Any) {
        if(!(scene?.countingDown)!) {
            super.resetPressed(sender)
        }
    }
    
    @IBAction func handleDifficultyPressed(_ sender: Any) {
        if(!(scene?.countingDown)!) {
            (self.scene as? PvPGameScene)?.switchDifficulty()
        }
    }
    
    @IBAction func handleFinishedPressed(_ sender: Any) {
        if(!(scene?.countingDown)!) {
            super.finishedPressed(sender)
        }
    }
    
    override func createAndConfigureGameScene() {
        scene = PvPGameScene.newGameScene()
        (self.scene as? PvPGameScene)?.viewController = self
        
        difficultyButton.setTitle(NSLocalizedString("Easy", comment: "Easy"), for: UIControlState.normal)
    }
    
}
