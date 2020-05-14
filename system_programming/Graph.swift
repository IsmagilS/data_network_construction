//
//  Graph.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 25.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation

class Graph {
    private(set) var vertexes = [Vertex]()
    private(set) var edges = [Edge]()
    private(set) var cables = [Cable]()
    private(set) var routers = [Router]()
    private(set) var trafficMatrix = [[Int]:Int]()
    private(set) var ways = [[Int]:[Edge]]()
    private(set) var secondWays = [[Int]:[Edge]]()
    private var bannedVertexes = [Vertex]()
    var intensity: Double = 1000
    
    func deleteVertex(_ vertex: Vertex) {
        while true {
            var didRemoveEdge = false
            for index2 in edges.indices {
                if edges[index2].from == vertex || edges[index2].to == vertex {
                    edges.swapAt(edges.count - 1, index2)
                    edges.remove(at: edges.count - 1)
                    didRemoveEdge = true
                    break
                }
            }
            if !didRemoveEdge {
                break
            }
        }
        
        for index in vertexes.indices {
            if vertex == vertexes[index] {
                vertexes.remove(at: index)
                break
            }
        }
    }
    
    func addVertex(_ vertex: Vertex) {
        vertexes.append(vertex)
    }
    
    func addCable(_ cable: Cable) {
        cables.append(cable)
    }
    
    func addRouter(_ router: Router) {
        routers.append(router)
    }
    
    func dijksdtra(start: Vertex, finish: Vertex, minimal: Int) -> Int? {
        var d = [Int: Int]()
        var pr = [Int: Int]()
        var u = [Int: Bool]()
        for vertex in vertexes {
            d[vertex.identifier] = Int.max
            u[vertex.identifier] = false
            pr[vertex.identifier] = -1
        }
        
        var key = [Int]()
        key.append(start.identifier)
        key.append(finish.identifier)
        
        d[start.identifier] = 0
        for _ in 0..<vertexes.count {
            var now: Vertex? = nil
            for vertex in vertexes {
                if !u[vertex.identifier]!, d[vertex.identifier]! != Int.max, (now == nil || d[now!.identifier]! > d[vertex.identifier]!) {
                    now = vertex
                }
            }
            if now == nil {
                break
            }
            u[now!.identifier] = true
            
            for (index, edge) in edges.enumerated() {
                if edge.from != now! || bannedVertexes.contains(edge.to) {
                    continue
                }
                if edge.from == start, edge.to == finish, ways[key] != nil, ways[key]!.count == 1, ways[key]!.last! == edge {
                    continue
                }
                
                let remainingFlow = edge.cable.capacity - edge.cable.currentFlow
                if remainingFlow < minimal {
                    continue
                }
                
                let to = edge.to
                let cost = Int(Double(edge.cable.price) * Double(distance(between: now!.point, and: to.point)))
                
                if d[to.identifier]! > d[now!.identifier]! + cost {
                    d[to.identifier] = d[now!.identifier]! + cost
                    pr[to.identifier] = index
                }
            }
        }
        
        if d[finish.identifier] == Int.max {
            return nil
        }
        
        if ways[key] == nil || ways[key]!.count == 0 {
            ways[key] = [Edge]()
            var vertex = finish
            var price = 0
            while vertex != start {
                if vertex != finish {
                    bannedVertexes.append(vertex)
                }
                edges[pr[vertex.identifier]!].cable.currentFlow += minimal
                price += edges[pr[vertex.identifier]!].cable.price
                edges[pr[vertex.identifier]!].cable.price = 0
                ways[key]!.append(edges[pr[vertex.identifier]!])
                vertex = edges[pr[vertex.identifier]!].from
            }
            
            return price
        }
        
        secondWays[key] = [Edge]()
        var vertex = finish
        var price = 0
        while vertex != start {
            edges[pr[vertex.identifier]!].cable.currentFlow += minimal
            price += edges[pr[vertex.identifier]!].cable.price
            edges[pr[vertex.identifier]!].cable.price = 0
            secondWays[key]!.append(edges[pr[vertex.identifier]!])
            vertex = edges[pr[vertex.identifier]!].from
        }
        
        return price
    }
    
    private func addAllEdges() {
        for cable in cables {
            for vertex in vertexes {
                for secondVertex in vertexes {
                    if vertex != secondVertex {
                        edges.append(Edge(from: vertex, to: secondVertex, cable: cable))
                    }
                }
            }
        }
    }
    
    func buildNetwork(with totalTraffic: Double) -> Int {
        edges.removeAll()
        ways.removeAll()
        secondWays.removeAll()
        intensity = totalTraffic
        trafficMatrix.removeAll()
        var orientedSum: Double = 0
        for from in vertexes {
            for to in vertexes {
                if from != to {
                    orientedSum += from.weight * to.weight * intensity
                }
            }
        }
        
        for from in vertexes {
            for to in vertexes {
                var key = [Int]()
                key.append(from.identifier)
                key.append(to.identifier)
                
                if from != to {
                    trafficMatrix[key] = Int(from.weight * to.weight * intensity * intensity / orientedSum * from.delta / (from.delta + to.delta))
                }
            }
        }
        
        addAllEdges()
        var totalPrice = 0
        for from in vertexes {
            for to in vertexes {
                if from == to {
                    continue
                }
                bannedVertexes.removeAll()
                var key = [Int]()
                key.append(from.identifier)
                key.append(to.identifier)
                
                let need = trafficMatrix[key]!
                
                let price = dijksdtra(start: from, finish: to, minimal: need)
                if price == nil {
                    addAllEdges()
                    
                    let secondPrice = dijksdtra(start: from, finish: to, minimal: need)
                    totalPrice += secondPrice ?? 0
                } else {
                    totalPrice += price!
                }
                
                let priceSecondWay = dijksdtra(start: from, finish: to, minimal: need)
                if priceSecondWay == nil {
                    addAllEdges()
                    
                    let secondPriceSecondWay = dijksdtra(start: from, finish: to, minimal: need)
                    totalPrice += secondPriceSecondWay ?? 0
                } else {
                    totalPrice += priceSecondWay!
                }
            }
        }
        
        while true {
            var didRemoveEdge = false
            for (index, edge) in edges.enumerated() {
                if edge.cable.price > 0 {
                    edges.remove(at: index)
                    didRemoveEdge = true
                    break
                }
            }
            if !didRemoveEdge {
                break
            }
        }
        
        for vertex in vertexes {
            var currentTraffic = 0.0
            for secondVertex in vertexes {
                if secondVertex == vertex {
                    continue
                }
                var key = [Int]()
                key.append(vertex.identifier)
                key.append(secondVertex.identifier)
                for edge in ways[key] ?? [Edge]() {
                    currentTraffic += Double(edge.cable.currentFlow)
                }
                for edge in secondWays[key] ?? [Edge]() {
                    currentTraffic += Double(edge.cable.currentFlow)
                }
                key.reverse()
                for edge in ways[key] ?? [Edge]() {
                    currentTraffic += Double(edge.cable.currentFlow)
                }
                for edge in secondWays[key] ?? [Edge]() {
                    currentTraffic += Double(edge.cable.currentFlow)
                }
            }
            
            for router in routers {
                if Double(router.capacity) >= currentTraffic {
                    if vertex.router?.price ?? Int.max > router.price {
                        vertex.router = Router(capacity: router.capacity, price: router.price)
                    }
                }
            }
        }
        
        return totalPrice
    }
    
    func buildPath(_ from: Int, _ to: Int) {
        var key = [Int]()
        key.append(from)
        key.append(to)
        for edge in edges {
            edge.type = 0
        }
        
        if ways[key] != nil {
            for edge in ways[key]!  {
                edge.type = 1
            }
        }
        if secondWays[key] != nil {
            for edge in secondWays[key]! {
                edge.type = 2
            }
        }
    }
}
