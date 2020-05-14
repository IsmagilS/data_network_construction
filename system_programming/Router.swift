//
//  Router.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 10.05.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation

class Router {
    private(set) var capacity: Int
    var currentFlow = 0
    var price: Int
    
    init(capacity: Int, price: Int) {
        self.capacity = capacity
        self.price = price
    }
}
