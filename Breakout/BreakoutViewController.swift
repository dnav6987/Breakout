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

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    @IBOutlet var gameView: UIView!
    
    var numBalls = GameSettings.numBalls    // number of balls remaining
    var balls = [Ball]()    // the balls.
    var paddle = Paddle()   // the paddle
    
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
        breakoutBehavior.collider.collisionDelegate = self
        newGame()
    }
    
    // MARK: initialization and destruction
    
    func newGame() {    // start a new game
        numBalls = GameSettings.numBalls    // all of the balls are alive
        initializeBricks()
        initializeBalls()
        initializePaddle()
    }
    
    func initializeBricks() {   // make a grid of bricks but randomly drop some for cool designs!
        for row in 0..<GameSettings.numRows {
            for col in 0..<Int(GameSettings.bricksPerRow) {
                if CGFloat.random(100) < GameSettings.brickPercentage { // randomly drop a brick with a given percent chance
                    let origin = CGPoint(x: CGFloat(col)*Brick.getBrickSize(gameView).width,  y: CGFloat(row)*Brick.getBrickSize(gameView).height)
                    let identifier = row*Int(GameSettings.bricksPerRow) + col   //  unique number for each brick (order in which they are made)
                    let brick = Brick(view: gameView,
                                      origin: origin,
                                      size: Brick.getBrickSize(gameView),
                                      cornerRadius: GameSettings.brickCornerRadius,
                                      identifier: identifier)
                    breakoutBehavior.addBrick(brick, identifier: brick.identifier, boundary: brick.boundary)
                }
            }
        }
    }
    
    func initializeBalls() {    // add the balls and get them moving
        for _ in 0..<GameSettings.numBalls {
            var ballOrigin = gameView.center
            ballOrigin.x += CGFloat.random(200) - 100   // randomly distribute around the center so they are not on top of each other
            let ball = Ball(view: gameView,
                            origin: ballOrigin,
                            size: CGSize(width: GameSettings.ballSize, height: GameSettings.ballSize),
                            cornerRadius: GameSettings.ballSize/2)
            breakoutBehavior.addBall(ball)
            balls.append(ball)
            pushBall(ball as UIDynamicItem) // push the ball so it starts moving
        }
    }
    
    func initializePaddle() {   // make the paddle
        // center the paddle on the bottom of the screen. Adjust height so it is above the tab bar
        let paddleOrigin = CGPoint(x: gameView.center.x - Paddle.getPaddleSize(gameView).width/2,
                                   y: gameView.bounds.maxY - Paddle.getPaddleSize(gameView).height - (self.tabBarController?.tabBar.bounds.height)!)
        paddle = Paddle(view: gameView,
                        origin: paddleOrigin,
                        size: Paddle.getPaddleSize(gameView),
                        cornerRadius: GameSettings.paddleCornerRadius,
                        true)
        breakoutBehavior.addPaddle(paddle, identifier: paddle.identifier, boundary: paddle.boundary)
        
    }
    
    func endGame() {    // clear all of the game elements
        breakoutBehavior.clearBricks()  // remove the bricks
        for ball in balls { // remove the balls
            breakoutBehavior.removeBall(ball)
        }
        breakoutBehavior.removePaddle(paddle)   // remove the paddle
        // sometimes not all the views are removed (even though they should be. I believe due to animation)
        // so add this safety net of removing all subviews
        for view in (paddle.superview?.subviews)! {
            view.removeFromSuperview()
        }
    }
    
    // MARK: game controls
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) { // move the paddle on pan
        switch sender.state {
        case .Changed:
            paddle.move(sender.translationInView(gameView).x)   // get the pan translation
            breakoutBehavior.removePaddle(paddle)   // have to clear the paddle's boundary
            breakoutBehavior.addPaddle(paddle, identifier: paddle.identifier, boundary: paddle.boundary)    // readd the paddle
            sender.setTranslation(CGPointZero, inView: gameView)    // reset the translation
        default: break
        }
    }
    
    @IBAction func reset(sender: UITapGestureRecognizer) { endGame(); newGame() }   // start a new game on double tap
    
    func pushBall(ball: UIDynamicItem) {    // start a ball's motion
        let push = UIPushBehavior(items: [ball], mode: .Instantaneous)  // instantaneous push
        push.magnitude = GameSettings.initialSpeed // how hard to push
        // push angle is straight down plus or minus 60 random degrees
        push.angle = CGFloat(M_PI/2) + CGFloat.random(120)*CGFloat(M_PI/180) -  CGFloat(60*M_PI/180)
        push.action = { [unowned push] in   // prevent memory leak
            if !push.active { self.breakoutBehavior.removeChildBehavior(push) }
        }
        breakoutBehavior.addChildBehavior(push)
    }
    
    // collision handler
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?,atPoint p: CGPoint) {
        if identifier != nil {
            if "\(identifier!)" != "Paddle" {   // i.e. it is a brick
                // how far off the y-velocity is from what it should be
                let ySpeedError = GameSettings.speed - breakoutBehavior.ballBehavior.linearVelocityForItem(item).y
                // correct the velocity
                breakoutBehavior.ballBehavior.addLinearVelocity(CGPoint(x: 0,y: ySpeedError), forItem: item)
                breakoutBehavior.removeBrick("\(identifier!)")
                if breakoutBehavior.bricks.count == 0 { reset(UITapGestureRecognizer()) }   // restart game when all bricks are gone
            } else {    // it is the paddle
                // how far off the y-velocity is from what it should be
                let ySpeedError = -GameSettings.speed - breakoutBehavior.ballBehavior.linearVelocityForItem(item).y
                // correct the velocity
                breakoutBehavior.ballBehavior.addLinearVelocity(CGPoint(x: 0,y: ySpeedError), forItem: item)
            }
        } else if p.y > paddle.frame.origin.y + paddle.frame.height {   // i.e. the ball is below the paddle
            breakoutBehavior.removeBall(item as! Ball)
            numBalls-=1
            if numBalls == 0 { reset(UITapGestureRecognizer()) }    // restart game, they have lost
        }
    }
}


// MARK: Breakout game items

class BreakoutGameItem: UIView {    // base class that the ball, paddle, and bricks will extend
    var identifier = "" // for collider boundaries
    var boundary = UIBezierPath()
    
    convenience init(view: UIView, origin: CGPoint, size: CGSize, cornerRadius: CGFloat) {
        self.init(frame: CGRect(origin: origin, size: size))
        layer.cornerRadius = cornerRadius   // all of the items will have rounded corners
        backgroundColor = UIColor.random    // give it a random color
        view.addSubview(self)
    }
}


// MARK: Bricks
// these could all have subclassed off BreakoutGameItem but extensions also do the the trick in this scenario.

private extension Brick {
    convenience init(view: UIView, origin: CGPoint, size: CGSize, cornerRadius: CGFloat, identifier: Int) {
        self.init(view: view, origin: origin, size: size, cornerRadius: cornerRadius)
        self.identifier = "Brick" + "\(identifier)" // each brick will have a unique identifier for collider boundaries
        boundary = UIBezierPath(roundedRect: frame, cornerRadius: GameSettings.brickCornerRadius)
    }
    
    static func getBrickSize(gameView: UIView) -> CGSize {  // return the size of the brick
        let width = gameView.bounds.width / GameSettings.bricksPerRow
        let height = gameView.bounds.height / (GameSettings.bricksPerRow * GameSettings.brickAspectRatio)
        return CGSize(width: width, height: height)
    }
}

// MARK: Paddle

private extension Paddle {
    convenience init(view: UIView, origin: CGPoint, size: CGSize, cornerRadius: CGFloat, _: Bool) {
        self.init(view: view, origin: origin, size: size, cornerRadius: cornerRadius)
        self.identifier = "Paddle"  // for the collider boundary
        boundary = UIBezierPath(roundedRect: frame, cornerRadius: GameSettings.brickCornerRadius)
    }
    
    static func getPaddleSize(gameView: UIView) -> CGSize { // return the size of the paddle
        let width = gameView.bounds.width / GameSettings.paddlesPerRow
        let height = gameView.bounds.height / (GameSettings.paddlesPerRow * GameSettings.paddleAspectRatio)
        return CGSize(width: width, height: height)
    }
    
    func move(dx: CGFloat) {  // move the paddle by dx. negative values are left, possitive values are right
        // only move the paddle if it is in bounds
        if (self.frame.origin.x > self.superview!.frame.minX || dx>0) &&
            (self.frame.origin.x + Paddle.getPaddleSize(self.superview!).width < self.superview!.frame.maxX || dx<0) {
            self.frame.origin.x += dx
            // reset the boundary to its new location
            self.boundary = UIBezierPath(roundedRect: frame, cornerRadius: GameSettings.brickCornerRadius)
        }
    }
}


// MARK: CGFloat and UIColor

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