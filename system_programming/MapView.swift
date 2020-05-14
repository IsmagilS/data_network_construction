//
//  MapView.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 04.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation
import UIKit

class MapView: UIView {
    private(set) var radius: CGFloat = 20.0
    private(set) var mapScale: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    private var mapOffsetX: CGFloat = 0.0 { didSet { setNeedsDisplay() } }
    private var mapOffsetY: CGFloat = 0.0 { didSet { setNeedsDisplay() } }
    
    private var minX = CGFloat.infinity
    private var maxX = -CGFloat.infinity
    private var minY = CGFloat.infinity
    private var maxY = -CGFloat.infinity
    private var ratioX: CGFloat = 0.0
    private var ratioY: CGFloat = 0.0
    
    var highlightedEdge: Edge?
    
    @objc func adjustMapScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            mapScale *= recognizer.scale
            recognizer.scale = 1.0
            if mapScale < 1.0/10 {
                mapScale = 1.0/10
            }
            if mapScale > 10 {
                mapScale = 10
            }
        default:
            break
        }
    }
    
    @objc func adjustMapOffset(byHandlingGestureRecognizedBy recognizer: UIPanGestureRecognizer) {
        if recognizer.view != self {
            return
        }
        
        switch recognizer.state {
        case .ended:
            mapOffsetX += -recognizer.translation(in: recognizer.view).x
            mapOffsetY += -recognizer.translation(in: recognizer.view).y
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
        case .changed:
            mapOffsetX += -recognizer.translation(in: recognizer.view).x
            mapOffsetY += -recognizer.translation(in: recognizer.view).y
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        layoutIfNeeded()
        minX = CGFloat.infinity
        maxX = -CGFloat.infinity
        minY = CGFloat.infinity
        maxY = -CGFloat.infinity
        
        for current in graph.vertexes {
            minX = min(minX, current.point.x)
            maxX = max(maxX, current.point.x)
            minY = min(minY, current.point.y)
            maxY = max(maxY, current.point.y)
        }
        minX -= radius
        maxX += radius
        minY -= radius
        maxY += radius
        
        let magic = min(bounds.width, bounds.height)
        
        ratioX = (magic * 0.98) / (maxX - minX)
        ratioY = (magic * 0.98) / (maxY - minY)
        
        drawVertexes()
        drawEdges()
    }
    
    private func drawVertexes() {
        var points = [CGPoint]()
        for current in graph.vertexes {
            points.append(CGPoint(x: current.point.x, y: current.point.y))
        }
        
        for index in points.indices {
            points[index] = applyTransformation(to: points[index], in: bounds)
        }
        
        for current in points {
            let path = UIBezierPath()
            
            path.addArc(withCenter: current, radius: CGFloat(radius) * mapScale, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            path.close()
            
            path.lineWidth = CGFloat(0.5) * mapScale
            UIColor.lightBlue.setFill()
            UIColor.lightBlue.setStroke()
            path.fill()
            path.stroke()
        }
    }
    
    private func drawEdges() {
        var countEdges = [[Int]: Int]()
        for edge in graph.edges {
            var from = CGPoint(x: edge.from.point.x, y: edge.from.point.y)
            var to = CGPoint(x: edge.to.point.x, y: edge.to.point.y)
            
            var key = [Int]()
            key.append(edge.from.identifier)
            key.append(edge.to.identifier)
            key.sort()
            if countEdges[key] != nil {
                countEdges[key]! += 1
            } else {
                countEdges[key] = 2
            }
            
            from = applyTransformation(to: from, in: bounds)
            to = applyTransformation(to: to, in: bounds)
            var mid = middle(between: from, and: to)
            
            if (edge.from.identifier < edge.to.identifier) {
                swap(&from, &to)
            }
            
            var vector = CGPoint(x: to.x - from.x, y: to.y - from.y)
            vector.x /= distance(between: from, and: to)
            vector.y /= distance(between: from, and: to)
            
            if countEdges[key]! % 2 == 0 {
                vector = rotate(vector, CGFloat.pi / 2)
            } else {
                vector = rotate(vector, -CGFloat.pi / 2)
            }
            
            mid.x += vector.x * CGFloat((countEdges[key]!) / 2) * 80 * mapScale
            mid.y += vector.y * CGFloat((countEdges[key]!) / 2) * 80 * mapScale
            let path = UIBezierPath()
            path.move(to: from)
            path.addQuadCurve(to: to, controlPoint: mid)
            path.lineWidth = 3.0 * mapScale
            
            if edge == highlightedEdge {
                path.lineWidth = 6.0 * mapScale
            }
            
            if edge.type == 0 {
                UIColor.lightBlue.setFill()
                UIColor.lightBlue.setStroke()
            } else if edge.type == 1 {
                UIColor.red.setFill()
                UIColor.red.setStroke()
            } else {
                UIColor.orange.setFill()
                UIColor.orange.setStroke()
            }
            path.stroke()
            
            if (edge.from.identifier < edge.to.identifier) {
                swap(&from, &to)
            }
            
            let arrow = UIBezierPath()
            
            var drawPoint = to
            vector = CGPoint(x: to.x - mid.x, y: to.y - mid.y)
            vector = normalized(vector)
            vector = rotate(vector, CGFloat.pi)
            drawPoint.x += vector.x * radius * mapScale
            drawPoint.y += vector.y * radius * mapScale
            arrow.move(to: drawPoint)
            
            drawPoint.x += vector.x * radius / 2 * mapScale
            drawPoint.y += vector.y * radius / 2 * mapScale
            if countEdges[key]! % 2 == 1 {
                vector = rotate(vector, CGFloat.pi / 2)
            } else {
                vector = rotate(vector, -CGFloat.pi / 2)
            }
            if (edge.from.identifier < edge.to.identifier) {
                vector = rotate(vector, CGFloat.pi)
            }
            drawPoint.x += vector.x * 2.5 * mapScale
            drawPoint.y += vector.y * 2.5 * mapScale
            arrow.addLine(to: drawPoint)
            
            drawPoint.x -= vector.x * 6 * mapScale
            drawPoint.y -= vector.y * 6 * mapScale
            arrow.addLine(to: drawPoint)
            
            arrow.close()
            arrow.lineWidth = 3.0 * mapScale
            if edge == highlightedEdge {
                arrow.lineWidth = 6.0 * mapScale
            }
            arrow.stroke()
            arrow.fill()
        }
    }
    
    func applyTransformation(to point: CGPoint, in bounds: CGRect) -> CGPoint {
        let magic = min(bounds.width, bounds.height)
        var newPoint = point
        newPoint = newPoint.offset(dx: -minX, dy: -minY)
        newPoint = newPoint.adjustCoordinates(multiplierX: ratioX, multiplierY: ratioY)
        newPoint = newPoint.offset(dx: magic * 0.01, dy: magic * 0.01)
        newPoint = newPoint.adjustCoordinates(multiplierX: mapScale, multiplierY:mapScale)
        newPoint = newPoint.offset(dx: -mapOffsetX, dy: -mapOffsetY)
        return newPoint
    }
    
    func applyReverseTransformation(to point: CGPoint, in bounds: CGRect) -> CGPoint {
        let magic = min(bounds.width, bounds.height)
        var newPoint = point
        newPoint = newPoint.offset(dx: mapOffsetX, dy: mapOffsetY)
        newPoint = newPoint.adjustCoordinates(multiplierX: 1 / mapScale, multiplierY: 1 / mapScale)
        newPoint = newPoint.offset(dx: -magic * 0.01, dy: -magic * 0.01)
        newPoint = newPoint.adjustCoordinates(multiplierX: 1 / ratioX, multiplierY: 1 / ratioY)
        newPoint = newPoint.offset(dx: minX, dy: minY)
        return newPoint
    }
}

extension CGPoint {
    func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        let newX = x + CGFloat(dx)
        let newY = y + CGFloat(dy)
        return CGPoint(x: newX, y: newY)
    }
    
    func adjustCoordinates(multiplierX: CGFloat, multiplierY: CGFloat) -> CGPoint {
        let newX = x * CGFloat(multiplierX)
        let newY = y * CGFloat(multiplierY)
        return CGPoint(x: newX, y: newY)
    }
}
