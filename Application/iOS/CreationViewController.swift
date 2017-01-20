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

class CreationViewController: CDTViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var graphPicker: UIPickerView!

    var graphPickerData = [String]()
    var pickerRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.graphPicker.delegate = self
        self.graphPicker.dataSource = self
        self.graphPicker.isHidden = true
        view.addSubview(graphPicker)
        graphPickerData = PersistenceUtil.getPersistencedDotGraphs()
    }
    
    @IBAction func handleDeletePressed(_ sender: Any) {
        if(self.graphPicker.isHidden) {
            self.pickerRow = 0
            self.graphPicker.isHidden = false
        } else {
            self.handleDelete()
        }
    }
    
    func handleDelete() {
        self.graphPicker.isHidden = true
        if graphPickerData.count == 0 { return }
        PersistenceUtil.removeDotGraph(name: graphPickerData[pickerRow])
        graphPickerData.remove(at: pickerRow)
        self.graphPicker.reloadAllComponents()
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
        scene = CreationGameScene.newGameScene()
        (self.scene as? CreationGameScene)?.viewController = self
    }
    
    @IBAction func handleResetPressed(_ sender: Any) {
        super.resetPressed(sender)
    }
    
    @IBAction func handleFinishedPressed(_ sender: Any) {
        super.finishedPressed(sender)
    }
}
