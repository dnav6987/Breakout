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
    //TODO tap gesture
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) {
        let dx = sender.translationInView(gameView).x
        switch sender.state {
        case .Changed:
            breakoutGame.movePaddle(dx)
            sender.setTranslation(CGPointZero, inView: gameView)
        default: break
        }
    }

        //TODO
    @IBAction func reset(sender: UILongPressGestureRecognizer) {
        
    }
    
    func newGame() {
        breakoutGame.endGame()
        breakoutGame.newGame(gameView, behavior: breakoutBehavior)
    }
}