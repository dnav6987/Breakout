//
//  BreakoutGame.swift
//  Breakout
//
//  Created by Dan Navarro on 4/8/16.
//  Copyright © 2016 Dan Navarro. All rights reserved.
//

import UIKit

typealias Brick = BreakoutGameItem
typealias Ball = BreakoutGameItem
typealias Paddle = BreakoutGameItem

// TODO put in settings
struct Constants {
    static let bricksPerRow: CGFloat = 12
    static let brickAspectRatio: CGFloat = 3
    static let brickCornerRadius: CGFloat = 10
    static let numRows = 1
    
    static let paddlesPerRow: CGFloat = 8
    static let paddleAspectRatio: CGFloat = 5
    static let paddleCornerRadius: CGFloat = 15
    
    static let ballSize: CGFloat = 16
}

class BreakoutGame {
    var gameView = UIView()
    var breakoutBehavior = BreakoutBehavior()
    var paddle = Paddle()
    
    func newGame(view: UIView, behavior: BreakoutBehavior) {
        gameView = view
        breakoutBehavior = behavior
        
        for row in 0..<Constants.numRows {
            for col in 0..<Int(Constants.bricksPerRow) {
                if CGFloat.random(100) < 80 {
                    let origin = CGPoint(x: CGFloat(col)*Brick.getBrickSize(gameView).width, y: CGFloat(row)*Brick.getBrickSize(gameView).height)
                    let identifier = row*Int(Constants.bricksPerRow) + col
                    let brick = Brick(view: gameView,
                                      origin: origin,
                                      size: Brick.getBrickSize(gameView),
                                      cornerRadius: Constants.brickCornerRadius,
                                      identifier: identifier)
                    breakoutBehavior.addBrick(brick, identifier: brick.identifier, boundary: brick.path)
                }
            }
        }
        
        let ball = Ball(view: gameView,
                        origin: gameView.center,
                        size: CGSize(width: Constants.ballSize, height: Constants.ballSize),
                        cornerRadius: Constants.ballSize/2)
        breakoutBehavior.addBall(ball)

        let paddleOrigin = CGPoint(x: gameView.center.x - Paddle.getPaddleSize(gameView).width/2,
                                   y: gameView.bounds.maxY - 5*Paddle.getPaddleSize(gameView).height)
        paddle = Paddle(view: gameView,
                            origin: paddleOrigin,
                            size: Paddle.getPaddleSize(gameView),
                            cornerRadius: Constants.paddleCornerRadius,
                            true)
        breakoutBehavior.addPaddle(paddle, identifier: paddle.identifier, boundary: paddle.path)
    }
    
    func movePaddle(dx: CGFloat) {  // negative values are left, possitive values are right
        paddle.move(dx)
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
        path = UIBezierPath(roundedRect: frame, cornerRadius: Constants.brickCornerRadius)
    }
    
    static func getBrickSize(gameView: UIView) -> CGSize {
        let width = gameView.bounds.width / Constants.bricksPerRow
        let height = gameView.bounds.height / (Constants.bricksPerRow * Constants.brickAspectRatio)
        return CGSize(width: width, height: height)
    }
}

private extension Paddle {
    convenience init(view: UIView, origin: CGPoint, size: CGSize, cornerRadius: CGFloat, _: Bool) {
        self.init(view: view, origin: origin, size: size, cornerRadius: cornerRadius)
        self.identifier = "Paddle"
        path = UIBezierPath(roundedRect: frame, cornerRadius: Constants.brickCornerRadius)
    }
    
    static func getPaddleSize(gameView: UIView) -> CGSize {
        let width = gameView.bounds.width / Constants.paddlesPerRow
        let height = gameView.bounds.height / (Constants.paddlesPerRow * Constants.paddleAspectRatio)
        return CGSize(width: width, height: height)
    }
    
    func move(dx: CGFloat) {  // negative values are left, possitive values are right
        if (self.frame.origin.x > self.superview!.frame.minX || dx>0) &&
            (self.frame.origin.x + Paddle.getPaddleSize(self.superview!).width < self.superview!.frame.maxX || dx<0) {
            self.frame.origin.x += dx
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