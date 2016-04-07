//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Dan Navarro on 4/7/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

typealias Brick = UIView
typealias Ball = UIView
typealias Paddle = UIView

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {
    // TODO put in settings
    struct BreakoutGameConstants {
        static let bricksPerCol: CGFloat = 12
        static let brickAspectRatio: CGFloat = 3
        static let numRows = 7
        static let brickCornerRadius: CGFloat = 10
    }
    
    @IBOutlet var gameView: UIView!
    
    let breakoutBehavior = BreakoutBehavior()
    
    lazy var animator : UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()

    
    var brickSize: CGSize {
        let width = gameView.bounds.width / BreakoutGameConstants.bricksPerCol
        let height = gameView.bounds.height / (BreakoutGameConstants.bricksPerCol * BreakoutGameConstants.brickAspectRatio)
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
        gameView.backgroundColor = UIColor.blackColor()
        newGame()
    }
    
    func newGame() {
        for row in 0..<BreakoutGameConstants.numRows {
            for col in 0..<Int(BreakoutGameConstants.bricksPerCol) {
                if CGFloat.random(100) < 80 {
                    let origin = CGPoint(x: CGFloat(col)*brickSize.width, y: CGFloat(row)*brickSize.height)
                    let brick = Brick.newBrick(origin, size: brickSize, cornerRadius: BreakoutGameConstants.brickCornerRadius)
                    gameView.addSubview(brick)
                    
                    let path = UIBezierPath(roundedRect: brick.frame, cornerRadius: BreakoutGameConstants.brickCornerRadius)
                    breakoutBehavior.addBarrier(path, named: "Brick" + "\(row*Int(BreakoutGameConstants.bricksPerCol) + col)")
                }
            }
        }
    }
}

private extension Brick {
    static func newBrick(origin: CGPoint, size: CGSize, cornerRadius: CGFloat) -> Brick {
        let frame = CGRect(origin: origin, size: size)
        let brick = Brick(frame: frame)
        brick.layer.cornerRadius = cornerRadius
        brick.backgroundColor = UIColor.random
        return brick
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 6 {
        case 0: return UIColor.redColor()
        case 1: return UIColor.orangeColor()
        case 2: return UIColor.yellowColor()
        case 3: return UIColor.greenColor()
        case 4: return UIColor.blueColor()
        case 5: return UIColor.purpleColor()
        default: return UIColor.whiteColor()
        }
    }
}