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
        lazyGravity.gravityDirection = CGVectorMake(0, -1.0)
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
        lazyBreakoutBehavior.elasticity = 0.75
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
            brick.removeFromSuperview()
            bricks.removeValueForKey(identifier)
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
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?,atPoint p: CGPoint) {
        if identifier != nil {
            if "\(identifier)" != "Paddle" {
                gravity.gravityDirection.dy = 1.0
                removeBrick("\(identifier!)")
            } else {
                gravity.gravityDirection.dy = -1.0
            }
        } else if fabs(fabs(p.y) - item.bounds.minY) < 2 {  // arbitrary
            gravity.gravityDirection.dy = 1.0
        }
    }
}
