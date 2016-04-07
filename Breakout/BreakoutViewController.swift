//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Dan Navarro on 4/7/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController {
    typealias Brick = UIView
    typealias Ball = UIView
    typealias Paddle = UIView
    
    // TODO put in settings
    struct BreakoutGameConst {
        static let bricksPerCol = 12
        static let brickAspectRatio = 3
        static let numRows = 7
    }
    
    @IBOutlet var gameView: UIView!
    
    var brickSize: CGSize {
        let width = CGFloat(gameView.bounds.width / CGFloat(BreakoutGameConst.bricksPerCol))
        let height = CGFloat(gameView.bounds.height / CGFloat(BreakoutGameConst.bricksPerCol * BreakoutGameConst.brickAspectRatio))
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newGame()
    }
    
    func newGame() {
        let brickFrame = CGRect(origin: CGPointZero, size: brickSize)
        let brickView = UIView(frame: brickFrame)
        brickView.backgroundColor = UIColor.random
        gameView.addSubview(brickView)
//        dropItBehavior.addDrop(dropView)

    }
}

// TODO NEEDED???
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
        default: return UIColor.blackColor()
        }
    }
}