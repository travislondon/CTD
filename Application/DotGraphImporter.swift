//
//  DotGraphImporter.swift
//  Dots
//
//  Created by Travis London on 1/13/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import Foundation
import SpriteKit

public class DotGraphImporter {
    var dotNodes = [SKShapeNode]()
    
    public func importDotGraph(path: URL) -> [SKShapeNode] {
        dotNodes.removeAll()
        var nodes = [SKShapeNode]()
        do {
            let dotGraph = try String(contentsOf: path.appendingPathExtension("dotGraph"), encoding: String.Encoding.utf8)
            nodes = (getNodesFromGraph(dotGraph: dotGraph))
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return nodes
    }
 
    func getNodesFromGraph(dotGraph: String) -> [SKShapeNode] {
        var nodes = [SKShapeNode]()
        let entries = dotGraph.characters.split(separator: "\n")
        for entry in entries {
            let node = createNodeForEntry(entry: String.init(entry))
            nodes.append(node)
        }
        return nodes
    }
    
    func createNodeForEntry(entry: String) -> SKShapeNode {
        let values = entry.characters.split(separator: ",")
        assert(values.count == 5, "Found an entry which did not conform to expected input.")
        let type = String.init(values[0])
        if(type == "Dot") {
            let dot = ShapeNode.init(rectOf: CGSize.init(width: CGFloat(24.0), height: CGFloat(12.0)), cornerRadius: 22)
            dot.lineWidth = 2
            dot.strokeColor = SKColor.lightGray
            dot.fillColor = SKColor.lightGray
            dot.isUserInteractionEnabled = false
            dot.zPosition = 1
            let x = String.init(values[1])
            let y = String.init(values[2])
            dot.position = CGPoint(x: CGFloat((x as NSString).floatValue), y: CGFloat((y as NSString).floatValue))
            dotNodes.append(dot)
            return dot
        } else if(type == "Line") {
            let startX = String.init(values[1])
            let startY = String.init(values[2])
            let endX = String.init(values[3])
            let endY = String.init(values[4])
            let x1 = CGFloat((startX as NSString).floatValue)
            let x2 = CGFloat((endX as NSString).floatValue)
            let y1 = CGFloat((startY as NSString).floatValue)
            let y2 = CGFloat((endY as NSString).floatValue)
            let startPoint = CGPoint(x: x1, y: y1)
            let endPoint = CGPoint(x: x2, y: y2)
            
            let startDot = GameScene.isOverDot(dots: dotNodes, at: startPoint, closestDotTest: true, threshold: GameScene.isOverThreshold)
            let endDot =   GameScene.isOverDot(dots: dotNodes, at: endPoint, closestDotTest: true, threshold: GameScene.isOverThreshold)
            let myLine = GameScene.makeLine(firstDot: startDot as! ShapeNode, secondDot: endDot as! ShapeNode, dotOfInterest: startDot as! ShapeNode, children: [LineNode]())
            return myLine
        }
        return SKShapeNode()
    }
    
}
