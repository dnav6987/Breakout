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
    
    lazy var gravity: UIGravityBehavior = {
        let lazyGravity = UIGravityBehavior()
        lazyGravity.gravityDirection = CGVectorMake(0, 0.3)
        return lazyGravity
    }()   // TODO needed?

    lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        lazyCollider.collisionDelegate=self
        return lazyCollider
    }()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBreakoutBehavior = UIDynamicItemBehavior()
        lazyBreakoutBehavior.elasticity = 0.0
        return lazyBreakoutBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
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
        removeBarrier(named: identifier)
        if let brick = bricks[identifier] {
         UIView.transitionWithView(brick,
                                   duration: 1,
                                   options: UIViewAnimationOptions.TransitionFlipFromRight,
                                   animations: nil,
                                   completion: nil)
            removeBarrier(named: identifier)
            brick.removeFromSuperview()
            bricks.removeValueForKey(identifier)
        }
    }
    
    func clearBricks() {
        for (identifier, _) in bricks {
            removeBrick(identifier)
        }
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        gravity.addItem(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
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
                gravity.gravityDirection.dy = 0.3
                removeBrick("\(identifier!)")
            } else {
                gravity.gravityDirection.dy = -0.3
            }
        } else if fabs(fabs(p.y) - item.bounds.minY) < 2 {  // arbitrary
            gravity.gravityDirection.dy = 0.3
        }
    }
}
