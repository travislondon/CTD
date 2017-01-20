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

class HelpViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = NSLocalizedString("HelpContents", comment: "HelpContents")
    }
}
