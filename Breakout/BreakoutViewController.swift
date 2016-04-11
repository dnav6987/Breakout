//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Dan Navarro on 4/7/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

typealias Brick = BreakoutGameItem
typealias Ball = BreakoutGameItem
typealias Paddle = BreakoutGameItem

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {
    @IBOutlet var gameView: UIView!
    
    var balls = [Ball]()
    var paddle = Paddle()
    
    var breakoutBehavior = BreakoutBehavior()
    
    lazy var animator : UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
        gameView.backgroundColor = UIColor.blackColor()
        newGame()
    }
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Changed:
            paddle.move(sender.translationInView(gameView).x)
            breakoutBehavior.removePaddle(paddle)
            breakoutBehavior.addPaddle(paddle, identifier: paddle.identifier, boundary: paddle.path)
            sender.setTranslation(CGPointZero, inView: gameView)
        default: break
        }
    }

    @IBAction func reset(sender: UITapGestureRecognizer) {
        endGame()
        newGame()
    }
    
    func newGame() {
        initializeBricks()
        initializeBalls()
        initializePaddle()
    }
    
    func initializeBricks() {
        for row in 0..<GameSettings.numRows {
            for col in 0..<Int(GameSettings.bricksPerRow) {
                if CGFloat.random(100) < 80 {
                    let origin = CGPoint(x: CGFloat(col)*Brick.getBrickSize(gameView).width, y: CGFloat(row)*Brick.getBrickSize(gameView).height)
                    let identifier = row*Int(GameSettings.bricksPerRow) + col
                    let brick = Brick(view: gameView,
                                      origin: origin,
                                      size: Brick.getBrickSize(gameView),
                                      cornerRadius: GameSettings.brickCornerRadius,
                                      identifier: identifier)
                    breakoutBehavior.addBrick(brick, identifier: brick.identifier, boundary: brick.path)
                }
            }
        }
    }
    
    func initializeBalls() {
        for _ in 0..<GameSettings.numBalls {
            var ballOrigin = gameView.center
            ballOrigin.x += CGFloat.random(200) - 100
            let ball = Ball(view: gameView,
                            origin: ballOrigin,
                            size: CGSize(width: GameSettings.ballSize, height: GameSettings.ballSize),
                            cornerRadius: GameSettings.ballSize/2)
            breakoutBehavior.addBall(ball)
            balls.append(ball)
        }
    }
    
    func initializePaddle() {
        // TODO fix height
        let paddleOrigin = CGPoint(x: gameView.center.x - Paddle.getPaddleSize(gameView).width/2,
                                   y: gameView.bounds.maxY - Paddle.getPaddleSize(gameView).height - CGFloat(50))
        paddle = Paddle(view: gameView,
                        origin: paddleOrigin,
                        size: Paddle.getPaddleSize(gameView),
                        cornerRadius: GameSettings.paddleCornerRadius,
                        true)
        breakoutBehavior.addPaddle(paddle, identifier: paddle.identifier, boundary: paddle.path)

    }
    
    func endGame() {
        breakoutBehavior.clearBricks()
        for ball in balls {
            breakoutBehavior.removeBall(ball)
        }
        breakoutBehavior.removePaddle(paddle)
        for view in (paddle.superview?.subviews)! {
            view.removeFromSuperview()
        }
    }
}

class BreakoutGameItem: UIView {
    var gameView = UIView()
    var identifier = ""
    var path = UIBezierPath()
    
    convenience init(view: UIView, origin: CGPoint, size: CGSize, cornerRadius: CGFloat) {
        self.init(frame: CGRect(origin: origin, size: size))
        layer.cornerRadius = cornerRadius
        backgroundColor = UIColor.random
        gameView = view
        gameView.addSubview(self)
    }
}

private extension Brick {
    convenience init(view: UIView, origin: CGPoint, size: CGSize, cornerRadius: CGFloat, identifier: Int) {
        self.init(view: view, origin: origin, size: size, cornerRadius: cornerRadius)
        self.identifier = "Brick" + "\(identifier)"
        path = UIBezierPath(roundedRect: frame, cornerRadius: GameSettings.brickCornerRadius)
    }
    
    static func getBrickSize(gameView: UIView) -> CGSize {
        let width = gameView.bounds.width / GameSettings.bricksPerRow
        let height = gameView.bounds.height / (GameSettings.bricksPerRow * GameSettings.brickAspectRatio)
        return CGSize(width: width, height: height)
    }
}

private extension Paddle {
    convenience init(view: UIView, origin: CGPoint, size: CGSize, cornerRadius: CGFloat, _: Bool) {
        self.init(view: view, origin: origin, size: size, cornerRadius: cornerRadius)
        self.identifier = "Paddle"
        path = UIBezierPath(roundedRect: frame, cornerRadius: GameSettings.brickCornerRadius)
    }
    
    static func getPaddleSize(gameView: UIView) -> CGSize {
        let width = gameView.bounds.width / GameSettings.paddlesPerRow
        let height = gameView.bounds.height / (GameSettings.paddlesPerRow * GameSettings.paddleAspectRatio)
        return CGSize(width: width, height: height)
    }
    
    func move(dx: CGFloat) {  // negative values are left, possitive values are right
        if (self.frame.origin.x > self.superview!.frame.minX || dx>0) &&
            (self.frame.origin.x + Paddle.getPaddleSize(self.superview!).width < self.superview!.frame.maxX || dx<0) {
            self.frame.origin.x += dx
            self.path = UIBezierPath(roundedRect: frame, cornerRadius: GameSettings.brickCornerRadius)
        }
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