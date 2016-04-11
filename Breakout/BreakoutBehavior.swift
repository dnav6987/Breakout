//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Dan Navarro on 4/7/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    var bricks = [String : Brick]()

    lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        lazyCollider.collisionDelegate=self
        return lazyCollider
    }()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBreakoutBehavior = UIDynamicItemBehavior()
        lazyBreakoutBehavior.elasticity = GameSettings.elasticity
        lazyBreakoutBehavior.friction = 0.0
        lazyBreakoutBehavior.resistance = 0.0
        return lazyBreakoutBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(named name: String) {
        collider.removeBoundaryWithIdentifier(name)
    }
    
    func addBrick(brick: Brick, identifier: String, boundary: UIBezierPath) {
        addBarrier(boundary, named: identifier)
        bricks[identifier] = brick
    }
    
    func removeBrick(identifier: String) {
        if let brick = bricks[identifier] {
         UIView.transitionWithView(brick,
                                   duration: 0.5,
                                   options: UIViewAnimationOptions.TransitionFlipFromBottom,
                                   animations: nil,
                                   completion: { (finished: Bool) -> () in
                                    if finished { brick.removeFromSuperview() }
            })
            self.removeBarrier(named: identifier)
            self.bricks.removeValueForKey(identifier)
        }
    }
    
    func clearBricks() {
        for (identifier, _) in bricks { removeBrick(identifier) }
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
        pushBall(ball as UIDynamicItem)
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func pushBall(ball: UIDynamicItem) {
        let push = UIPushBehavior(items: [ball], mode: .Instantaneous)
        push.magnitude = GameSettings.speed
        push.angle = CGFloat(M_PI/2) + CGFloat.random(60)*CGFloat(M_PI/180) -  CGFloat(30*M_PI/180)
        push.action = { [unowned push] in
            if !push.active {
                self.removeChildBehavior(push)
            }
        }
        addChildBehavior(push)
    }
    
    func addPaddle(paddle: Paddle, identifier: String, boundary: UIBezierPath) {
        addBarrier(boundary, named: identifier)
    }
    
    func removePaddle(paddle: Paddle) {
        removeBarrier(named: paddle.identifier)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?,atPoint p: CGPoint) {
        if identifier != nil {
            if "\(identifier!)" != "Paddle" {
                removeBrick("\(identifier!)")
            }
        }
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}