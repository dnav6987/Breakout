//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Dan Navarro on 4/7/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    var bricks = [String : Brick]() // store the bricks so we can keep track of the boundaries

    lazy var collider: UICollisionBehavior = {  // collider behavior
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCollider
    }()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {    // behaviors for the ball
        let lazyBreakoutBehavior = UIDynamicItemBehavior()
        lazyBreakoutBehavior.elasticity = GameSettings.elasticity
        // don't want any friction or resistance because they slow down the ball. (Honestly, not sure if this is working though)
        lazyBreakoutBehavior.friction = 0.0
        lazyBreakoutBehavior.resistance = 0.0
        return lazyBreakoutBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    // add a collision boundary
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    // remove a collision boundary
    func removeBarrier(named name: String) {
        collider.removeBoundaryWithIdentifier(name)
    }
    
    // add the boundary of the brick and store the brick
    func addBrick(brick: Brick, identifier: String, boundary: UIBezierPath) {
        addBarrier(boundary, named: identifier)
        bricks[identifier] = brick
    }
    
    // animate the brick, remove its collision boundary and remove it from the view
    func removeBrick(identifier: String) {
        if let brick = bricks[identifier] {
         UIView.transitionWithView(brick,
                                   duration: 0.5,
                                   options: UIViewAnimationOptions.TransitionFlipFromBottom,
                                   animations: nil,
                                   completion: { (finished: Bool) -> () in
                                    if finished { brick.removeFromSuperview() } // don't remove until animation is done
            })
            self.removeBarrier(named: identifier)
            self.bricks.removeValueForKey(identifier)
        }
    }
    
    // remove all the bricks
    func clearBricks() {
        for (identifier, _) in bricks { removeBrick(identifier) }
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
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
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}