//
//  Geometry.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 05.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation
import UIKit

func sqr(_ value: CGFloat) -> CGFloat {
    return value * value
}

func distance(between pointA: CGPoint, and pointB: CGPoint) -> CGFloat {
    return sqrt(sqr(pointA.x - pointB.x) + sqr(pointA.y - pointB.y))
}

func middle(between pointA: CGPoint, and pointB: CGPoint) -> CGPoint {
    return CGPoint(x: (pointA.x + pointB.x) / 2, y: (pointA.y + pointB.y) / 2)
}

func rotate(_ vector: CGPoint, _ degrees: CGFloat) -> CGPoint {
    return CGPoint(x: vector.x * cos(degrees) - vector.y * sin(degrees),
                   y: vector.x * sin(degrees) + vector.y * cos(degrees))
}

func normalized(_ vector: CGPoint) -> CGPoint {
    let len = distance(between: vector, and: CGPoint.zero)
    return CGPoint(x: vector.x / len, y: vector.y / len)
}
