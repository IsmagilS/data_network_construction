//
//  ControlPanelModel.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 12.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation

enum ControlPanelState {
    case vertex
    case router
    case cable
    case network
    case path
}

class ControlPanelModel {
    var state = ControlPanelState.vertex
    
    var buttonText: String {
        switch state {
        case .vertex:
            return "  Add vertex  "
        case .router:
            return "  Add router  "
        case .cable:
            return "  Add cable  "
        case .network:
            return "  Build network  "
        case .path:
            return "  Show path  "
        }
    }
    
    var firstTextPlaceholder: String {
        switch state {
        case .vertex:
            return "  x coordinate  "
        case .router:
            return "  capacity  "
        case .cable:
            return "  capacity  "
        case .network:
            return "  Total traffic  "
        case .path:
            return "  from vertex  "
        }
    }
    
    var secondTextPlaceholder: String {
        switch state {
        case .vertex:
            return "  y coordinate  "
        case .router:
            return "  price  "
        case .cable:
            return "  price per meter  "
        case .network:
            return ""
        case .path:
        return "  to vertex  "
        }
    }
    
    var thirdTextPlaceholder: String {
        switch state {
        case .vertex:
            return "  weight  "
        case .cable:
            return ""
        case .router:
            return ""
        case .network:
            return ""
        case .path:
            return ""
        }
    }
    
    var fourthTextPlaceholder: String {
        switch state {
        case .vertex:
            return "  delta  "
        case .cable:
            return ""
        case .router:
            return ""
        case .network:
            return ""
        case .path:
            return ""
        }
    }
}
