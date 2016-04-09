//
//  BreakoutSettings.swift
//  Breakout
//
//  Created by Dan Navarro on 4/9/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

class BreakoutSettingsViewController: UITableViewController {
    
    @IBOutlet weak var brickSize: UISlider!
    @IBOutlet weak var numRows: UIStepper!
    @IBOutlet weak var ballSpeed: UISlider!
    @IBOutlet weak var numBalls: UISegmentedControl!
    @IBOutlet weak var ballElasticity: UISlider!
    @IBOutlet weak var paddleSize: UISlider!
}