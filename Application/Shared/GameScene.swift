//
//  GameScene.swift
//  TestingCrossPlatform
//
//  Created by Travis London on 12/31/16.
//  Copyright © 2016 Travis London. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

public class LineNode :SKShapeNode {
    var pointOne = CGPoint(x: -9999.99, y: -9999.99)
    var pointTwo = CGPoint(x: -9999.99, y: -9999.99)
    public static func initWithPoints(pathToDraw: CGMutablePath, pointOne: CGPoint, pointTwo: CGPoint) -> LineNode {
        let node = LineNode(path: pathToDraw)
        node.pointOne = pointOne
        node.pointTwo = pointTwo
        return node
    }
    
    public func getStartPoint() -> CGPoint {
        return pointOne
    }
    
    public func getEndPoint() -> CGPoint {
        return pointTwo
    }
}
public class ShapeNode :SKShapeNode {}

class GameScene: SKScene {

    var countingDown = false
    public static var nilDot : SKShapeNode? = ShapeNode()
    public static var nilLine : SKShapeNode? = LineNode()
    var dotOfInterest = ShapeNode()
    public static var isOverThreshold = CGFloat(24)
    var creation: Bool = true
    fileprivate var currentTouchDownLocation = CGPoint.zero
    fileprivate var duringMove = false
    fileprivate var multitouch = false
    var dotNode : ShapeNode?
    
    func setUpScene() {
        // Create shape node to use during mouse interaction
        self.dotNode = ShapeNode.init(rectOf: CGSize.init(width: 24, height: 12), cornerRadius: 22)
        
        if let dotNode = self.dotNode {
            
            dotNode.lineWidth = 2.0
        }
        
        dotOfInterest = (GameScene.nilDot as! ShapeNode?)!
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    
    public static func lineExists(line otherLine: LineNode, children : [LineNode]) -> Bool {
        for line in children {
            if((otherLine.pointOne == line.pointOne && otherLine.pointTwo == line.pointTwo) || (otherLine.pointOne == line.pointTwo && otherLine.pointTwo == line.pointOne)) {
                return true
            }
        }
        return false
    }

    func makeDot(at pos: CGPoint, color: SKColor) {
        // see if the position already contains a dot
        // if not create a dot
        let dots = children.filter { $0.isKind(of: ShapeNode.self) }
        let dotOver = GameScene.isOverDot(dots: dots as! [SKShapeNode], at: pos, closestDotTest: false, threshold: GameScene.isOverThreshold)
        if(!self.children.contains(dotOver)) {
            if let dot = self.dotNode?.copy() as! ShapeNode? {
                dot.position = pos
                dot.strokeColor = color
                dot.fillColor = color
                dot.isUserInteractionEnabled = false
                dot.zPosition = 1
                self.addChild(dot)
                setDotOfInterest(dot: dot)
            }
        }
    }

    public static func makeLine(firstDot: ShapeNode, secondDot: ShapeNode, dotOfInterest: ShapeNode, children: [LineNode]) -> LineNode {
        // draw a line between this dot and the last one if it exists
        if(dotOfInterest != GameScene.nilDot && firstDot != secondDot) {
            let startX = firstDot.frame.midX
            let startY = firstDot.frame.midY
            let endX = secondDot.frame.midX
            let endY = secondDot.frame.midY
            // make the start point the one farthest left, we need them ordered
            // for comparison
            var startPoint = CGPoint(x: startX, y: startY)
            var endPoint = CGPoint(x: endX, y: endY)
            if(startX > endX) {
                let sPoint = startPoint
                startPoint = endPoint
                endPoint = sPoint
            }
            let pathToDraw:CGMutablePath = CGMutablePath()
            let myLine:LineNode = LineNode.initWithPoints(pathToDraw:pathToDraw, pointOne: startPoint, pointTwo: endPoint)
            
            pathToDraw.move(to: startPoint)
            pathToDraw.addLine(to: endPoint)
            
            myLine.path = pathToDraw
            myLine.strokeColor = SKColor.cyan
            myLine.zPosition = 0
            
            // do not use the line if it already exists
            if(GameScene.lineExists(line: myLine, children: children)) {
                return GameScene.nilLine as! LineNode
            }
        
            return myLine
        }
        return GameScene.nilLine as! LineNode
    }

    func isOverControlArea(position location:CGPoint) -> Bool {
        return false
    }
    
    public static func getDistance(pointOne: CGPoint, pointTwo: CGPoint) -> CGFloat {
        let x = abs(pointOne.x - pointTwo.x)
        let y = abs(pointOne.y - pointTwo.y)
        let distance = sqrt(pow(x, 2) + pow(y, 2))
        return distance
    }
    
    func isWithinThreshold(pointOne: CGPoint, pointTwo: CGPoint) -> Bool {
        let distance = GameScene.getDistance(pointOne: pointOne, pointTwo: pointTwo)
        if(distance <= GameScene.isOverThreshold) {
            return true
        }
        return false
    }
    
    public static func isOverDot(dots: [SKShapeNode], at pos: CGPoint, closestDotTest closest: Bool, threshold: CGFloat) -> SKShapeNode {
        var closestDot =  GameScene.nilDot
        var distance = CGFloat.init(99999)
        for shape in dots {
            // check the touch position for a location within the bounds
            // of the existing dots
            if(shape.contains(pos)) {
                return shape 
            } else {
                if(closest) {
                    let currentDistance = getDistance(pointOne: shape.position, pointTwo: pos)
                    // store closest dot
                    if(distance > currentDistance) {
                        distance = currentDistance
                        closestDot = shape as! ShapeNode
                    }
                }
            }
        }
        if(distance <= threshold) {
            return closestDot!
        }
        return GameScene.nilDot!
    }
    
    func setDotOfInterest(dot: ShapeNode) {
        self.dotOfInterest = dot
    }

    
    func getDotOfInterest() -> ShapeNode {
        return self.dotOfInterest
    }
    
    func clearLines() {
        let lines = children.filter { $0.isKind(of: LineNode.self) }
        removeChildren(in: lines)
    }
    
    class func newGameScene() -> GameScene {
        return GameScene()
    }
    
    func resetGame() {}
  
    func resetBoard() {
        setDotOfInterest(dot: (GameScene.nilDot as! ShapeNode?)!)
    }

    func performFinish() {}

    /*
     This is the main entry point from the UI
     */
    func handleTouchEvent(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.countingDown) {
            return
        }
        let originalDotOfInterest = getDotOfInterest()
        let touchLocation = touches.first!.location(in: self)
        if(touches.count == 1) {
            let dots = children.filter { $0.isKind(of: ShapeNode.self) }
            var threshold = GameScene.isOverThreshold
            if(duringMove) {
                threshold = threshold * 3
            }
            let existingDot = GameScene.isOverDot(dots: dots as! [SKShapeNode], at: touchLocation, closestDotTest: true, threshold: threshold)
            if(existingDot == GameScene.nilDot && creation) {
                makeDot(at: touchLocation, color: SKColor.lightGray)
            } else if (existingDot != GameScene.nilDot) {
                setDotOfInterest(dot: (existingDot as? ShapeNode)!)
            }
            // do not create a line if there is no original dot of
            // interest
            if(originalDotOfInterest != GameScene.nilDot && originalDotOfInterest != getDotOfInterest()) {
                let lines = children.filter { $0.isKind(of: LineNode.self) }
                let newLine = GameScene.makeLine(firstDot: originalDotOfInterest, secondDot: getDotOfInterest(), dotOfInterest: dotOfInterest, children: lines as! [LineNode])
                if(newLine != GameScene.nilLine) {
                    addChild(newLine)
                }
            }
        }
    }

    func getResults() -> String {
        let result = getResultString()
        var strings = result.components(separatedBy: "\n")
        strings.sort()
        var sorted = ""
        for string in strings {
            sorted += string + "\n"
        }
        return String(sorted)
    }

    func getResultString() -> String {
        let shapesAndLines = self.children.filter { $0.isKind(of: ShapeNode.self) || $0.isKind(of: LineNode.self) }
        var result = ""
        for node in shapesAndLines {
            if(node.isKind(of: ShapeNode.self)) {
                result = result + "Dot,"
                result = result + node.position.x.description + ","
                result += node.position.y.description + ","
                result += node.frame.width.description + ","
                result += node.frame.height.description + "\n"
           } else if(node.isKind(of: LineNode.self)) {
                let line = node as! LineNode
                result = result + "Line,"
                result = result + line.getStartPoint().x.description + ","
                result += line.getStartPoint().y.description + ","
                result += line.getEndPoint().x.description + ","
                result += line.getEndPoint().y.description + "\n"
            }
        
        }
        return result
    }
    
    public func handleInputFromDialog(result: String) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}

#if os(iOS) || os(tvOS)
    // Touch-based event handling
    extension GameScene {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if(currentTouchDownLocation == CGPoint.zero) {
                currentTouchDownLocation = touches.first!.location(in: self)
            } else {
                multitouch = true
            }
            handleTouchEvent(touches, with: event)
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            duringMove = true
            if(!multitouch) {
                handleTouchEvent(touches, with: event)
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            // clear dot of interest
            setDotOfInterest(dot: (GameScene.nilDot as! ShapeNode?)!)
            let dots = children.filter { $0.isKind(of: ShapeNode.self) }
            let dotOver = GameScene.isOverDot(dots: dots as! [SKShapeNode], at: touches.first!.location(in: self), closestDotTest: true, threshold: GameScene.isOverThreshold)
            let touchDownDot = GameScene.isOverDot(dots: dots as! [SKShapeNode], at: currentTouchDownLocation, closestDotTest: true, threshold: GameScene.isOverThreshold)
            if(dotOver != touchDownDot && !duringMove) {
                setDotOfInterest(dot: touchDownDot as! ShapeNode)
            } else {
                currentTouchDownLocation = CGPoint.zero
                duringMove = false
                multitouch = false
            }
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
    }
#endif
