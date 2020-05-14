//
//  Edge.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 12.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation

class Edge: Equatable {
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private(set) var identifier: Int
    private(set) var cable: Cable
    var from: Vertex
    var to: Vertex
    var type = 0
    
    init(from: Vertex, to: Vertex, cable: Cable) {
        self.from = from
        self.to = to
        self.cable = Cable(capacity: cable.capacity, price: cable.price)
        identifier = Edge.getUniqueIdentifier()
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
