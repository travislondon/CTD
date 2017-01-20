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

class ChallengeViewController: DifficultyBasedViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var difficultyButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var graphPicker: UIPickerView!
    var graphPickerData = [String]()
    var pickerRow = 0
    
    @IBAction func handleLoadPressed(_ sender: Any) {
        if(self.graphPicker.isHidden) {
            self.pickerRow = 0
            self.graphPicker.isHidden = false
        } else {
            handleLoad()
        }
    }
    
    @IBAction func handleResetPressed(_ sender: Any) {
        if(!((self.scene as? ChallengeGameScene)?.countingDown)!) {
            super.resetPressed(sender)
        }
    }
    
    @IBAction func handleDifficultyPressed(_ sender: Any) {
        if(!((self.scene as? ChallengeGameScene)?.countingDown)!) {
            (self.scene as? ChallengeGameScene)?.switchDifficulty()
        }
    }

    @IBAction func handleFinishedPressed(_ sender: Any) {
        if(!((self.scene as? ChallengeGameScene)?.countingDown)!) {
            self.scene?.performFinish()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.graphPicker.delegate = self
        self.graphPicker.dataSource = self
        self.graphPicker.isHidden = true
        graphPickerData = PersistenceUtil.getPersistencedDotGraphs()
    }
    
    func handleCancel() {
        pickerRow = 0
    }
    func handleLoad() {
        self.graphPicker.isHidden = true
        if graphPickerData.count == 0 { return }
        (scene as! ChallengeGameScene).clearBoard()
        let importer = DotGraphImporter()
        (self.scene as? ChallengeGameScene)?.addChildren(nodes: importer.importDotGraph(path: PersistenceUtil.getURLFor(name: graphPickerData[pickerRow])))
        (scene as! ChallengeGameScene).completeLoad()

    }
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return graphPickerData.count
    }
    
    // The number of rows of data
    func pickerView(numberOfRowsInComponent component: Int) -> Int {
        return graphPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return graphPickerData[row]
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func createAndConfigureGameScene() {
        self.scene = ChallengeGameScene.newGameScene()
        (self.scene as? ChallengeGameScene)?.viewController = self
        
        difficultyButton.setTitle(NSLocalizedString("Easy", comment: "Easy"), for: UIControlState.normal)
    }
    
}
