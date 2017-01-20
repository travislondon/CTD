//
//  DifficultyBasedViewController.swift
//  Dots
//
//  Created by Travis London on 1/13/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class DifficultyBasedViewController : GameViewController {
    override func openResultDialog(result theResult : Bool) {
        var passButton = NSLocalizedString("Pass", comment: "Pass")
        let retryButton = NSLocalizedString("Retry", comment: "Retry")
        var message = NSLocalizedString("Did not connect the dots!", comment: "Did not connect the dots!")
        if(theResult) {
            message = NSLocalizedString("Successfully connected the dots!", comment: "Successfully connected the dots!")
        } else {
            passButton = NSLocalizedString("Give Up", comment: "Give Up")
        }
        // Initialize Alert Controller
        let alertController = UIAlertController(title: NSLocalizedString("Game Complete", comment: "Game Complete"), message: message, preferredStyle: .alert)
        
        // Initialize Actions
        let yesAction = UIAlertAction(title: passButton, style: .default) { (action) -> Void in
            self.scene?.resetGame()
        }
        
        let noAction = UIAlertAction(title: retryButton, style: .default) { (action) -> Void in
            (self.scene as? DifficultyBasedGameScene)!.restoreStart()
            if((self.scene as? DifficultyBasedGameScene)?.getCurrentDifficulty() == 1) {
                self.scene?.countingDown = true
                (self.scene as? DifficultyBasedGameScene)?.countDown(count: 5)
            }
        }
        
        // Add Actions
        alertController.addAction(yesAction)
        if(!theResult) {
            alertController.addAction(noAction)
        }
        
        // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
    }    
}
