//
//  BreakoutSettings.swift
//  Breakout
//
//  Created by Dan Navarro on 4/9/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

class BreakoutSettingsViewController: UITableViewController {
    @IBAction func changeBrickSize(sender: UISlider) { GameSettings.bricksPerRow = CGFloat(-sender.value) }
    @IBAction func changeNumRows(sender: UIStepper) { GameSettings.numRows = Int(sender.value) }
    @IBAction func changeBrickPercentage(sender: UISlider) { GameSettings.brickPercentage = CGFloat(sender.value) }
    @IBAction func changeBallSpeed(sender: UISlider) { GameSettings.speed = CGFloat(sender.value) }
    @IBAction func changeNumBalls(sender: UISegmentedControl) { GameSettings.numBalls = Int(sender.selectedSegmentIndex) + 1 }
    @IBAction func changeBallElasticity(sender: UISlider) { GameSettings.elasticity = CGFloat(sender.value) }
    @IBAction func changeBallSize(sender: UISlider) { GameSettings.ballSize = CGFloat(sender.value) }
    @IBAction func changePaddleSize(sender: UISlider) { GameSettings.paddlesPerRow = CGFloat(-sender.value) }
}

struct GameSettings {
    static var bricksPerRow: CGFloat = 12
    static let brickAspectRatio: CGFloat = 3
    static let brickCornerRadius: CGFloat = 10
    static var numRows = 3
    static var brickPercentage: CGFloat = 80
    
    static var paddlesPerRow: CGFloat = 5
    static let paddleAspectRatio: CGFloat = 10
    static let paddleCornerRadius: CGFloat = 15
    
    static var ballSize: CGFloat = 16
    static var numBalls: Int = 1
    static var elasticity: CGFloat = 1.0
    
    static var speed: CGFloat = 400
    static var initialSpeed: CGFloat = 0.05
}