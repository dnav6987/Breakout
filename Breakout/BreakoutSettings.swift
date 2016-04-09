//
//  BreakoutSettings.swift
//  Breakout
//
//  Created by Dan Navarro on 4/9/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

class BreakoutSettingsViewController: UITableViewController {
    @IBAction func changeBrickSize(sender: UISlider) {
        Constants.bricksPerRow = CGFloat(-sender.value)
        update()
    }

    @IBAction func changeNumRows(sender: UIStepper) {
        Constants.numRows = Int(sender.value)
        update()
    }
    
    @IBAction func changeBallSpeed(sender: UISlider) {
        
    }
    
    @IBAction func changeNumBalls(sender: UISegmentedControl) {
        
    }
    
    @IBAction func changeBallElasticity(sender: UISlider) {
        
    }
    
    @IBAction func changePaddleSize(sender: UISlider) {
        Constants.paddlesPerRow = CGFloat(-sender.value)
        update()
    }
    
    func update() {
        if let gameViewController = self.tabBarController?.viewControllers![0] as? BreakoutViewController {   // The game view controller
            gameViewController.newGame()
        }
    }
}