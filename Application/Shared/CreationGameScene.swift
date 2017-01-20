//
//  GameScene.swift
//  TestingCrossPlatform
//
//  Created by Travis London on 12/31/16.
//  Copyright © 2016 Travis London. All rights reserved.
//

import SpriteKit
import UIKit

class CreationGameScene: GameScene {
    
    public var viewController : CreationViewController?
    
    override class func newGameScene() -> CreationGameScene {
        guard let scene = SKScene(fileNamed: "CreationGameScene") as? CreationGameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }

        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
        
    override func resetGame() {
        super.resetGame()
        resetBoard()
    }
    
    override func resetBoard() {
        super.resetBoard()
        self.removeAllChildren()
        setDotOfInterest(dot: (GameScene.nilDot as! ShapeNode?)!)
    }
    
    
    override func performFinish() {
        setDotOfInterest(dot: GameScene.nilDot as! ShapeNode)
        viewController?.openInputDialog(title: NSLocalizedString("Choose a name for the dot graph", comment: "Choose a name for the dot graph"), text: "")
    }
    
    override func handleInputFromDialog(result: String) {
        saveFile(fileName: result)
        viewController?.graphPickerData = PersistenceUtil.getPersistencedDotGraphs()
        viewController?.graphPicker.reloadAllComponents()
    }
    
    func saveFile(fileName: String) {
        let exporter = DotGraphExporter()
        exporter.exportDotGraph(dotGraph: getResults(), fileName: fileName + ".dotGraph")
    }

    override func update(_ currentTime: TimeInterval) {
    }
}


