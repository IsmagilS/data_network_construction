//
//  Vertex.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 04.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation
import UIKit

class Vertex: Equatable {
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    private(set) var identifier: Int
    var point: CGPoint
    let weight: Double
    let delta: Double
    var router: Router?
    
    init(_ x: CGFloat, _ y: CGFloat, _ weight: Double, _ delta: Double) {
        point = CGPoint(x: x, y: y)
        self.weight = weight
        self.delta = delta
        identifier = Vertex.getUniqueIdentifier()
    }
    
    init (_ point: CGPoint, _ weight: Double, _ delta: Double) {
        self.point = point
        self.weight = weight
        self.delta = delta
        identifier = Vertex.getUniqueIdentifier()
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
