//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Dan Navarro on 4/7/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {
    @IBOutlet var gameView: UIView!
    
    var breakoutBehavior = BreakoutBehavior()
    
    lazy var animator : UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    var breakoutGame = BreakoutGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
        gameView.backgroundColor = UIColor.blackColor()
        breakoutGame.newGame(gameView, behavior: breakoutBehavior)
    }
}