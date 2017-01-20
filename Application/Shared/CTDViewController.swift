//
//  GameViewController.swift
//  TestingCrossPlatform
//
//  Created by Travis London on 12/31/16.
//  Copyright © 2016 Travis London. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class CDTViewController: UIViewController {
    
    var scene: GameScene? = nil
    
    func resetPressed(_ sender: Any) {
        scene?.resetBoard()
    }
    
    func finishedPressed(_ sender: Any) {
        scene?.performFinish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAndConfigureGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = false
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.isMultipleTouchEnabled = true
        
    }
    func createAndConfigureGameScene() {
        // let subtypes override
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func openResultDialog(result theResult : Bool) {
        // let subtypes override
    }
        
    func openInputDialog(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.scene?.handleInputFromDialog(result: (textField?.text)!)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
}
