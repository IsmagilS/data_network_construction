//
//  ViewController.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 04.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import UIKit

var graph = Graph()

class MapViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlue
    }
    
    @IBOutlet weak var mapView: MapView! {
        didSet {
            let pinch = UIPinchGestureRecognizer(target: mapView, action: #selector(mapView.adjustMapScale(byHandlingGestureRecognizedBy:)))
            mapView.addGestureRecognizer(pinch)
            
            let pan = UIPanGestureRecognizer(target: mapView, action: #selector(mapView.adjustMapOffset(byHandlingGestureRecognizedBy:)))
            mapView.isUserInteractionEnabled = true
            mapView.addGestureRecognizer(pan)
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(removeVertex(byHandlingGestureRecognizedBy:)))
            longPress.minimumPressDuration = 1.0
            longPress.allowableMovement = 0.01
            mapView.addGestureRecognizer(longPress)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(byHandlingGestureRecognizedBy:)))
            mapView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var controlPanelView: ControlPanelView! {
        didSet {
            controlPanelView.actionButton.addTarget(self, action: #selector(addVertexAction(sender:)), for: .touchUpInside)
            controlPanelView.actionButton.addTarget(self, action: #selector(addCableAction(sender:)), for: .touchUpInside)
            controlPanelView.actionButton.addTarget(self, action: #selector(buildNetworkAction(sender:)), for: .touchUpInside)
            controlPanelView.actionButton.addTarget(self, action: #selector(buildPathAction(sender:)), for: .touchUpInside)

            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(increaseControlPanelState(byHandlingGestureRecognizedBy:)))
            swipeRight.direction = .right
            controlPanelView.addGestureRecognizer(swipeRight)

            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(decreaseControlPanelState(byHandlingGestureRecognizedBy:)))
            swipeLeft.direction = .left
            controlPanelView.addGestureRecognizer(swipeLeft)
            
            controlPanelView.firstTextField.delegate = self
            controlPanelView.secondTextField.delegate = self
            controlPanelView.thirdTextField.delegate = self
            controlPanelView.fourthTextField.delegate = self
        }
    }
    
    @objc func increaseControlPanelState(byHandlingGestureRecognizedBy recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            switch controlPanelView.model.state {
            case .vertex:
                controlPanelView.model.state = .router
            case .router:
                controlPanelView.model.state = .cable
            case .cable:
                controlPanelView.model.state = .network
            case .network:
                controlPanelView.model.state = .path
            case .path:
                controlPanelView.model.state = .vertex
            }
            controlPanelView.updateViewFromModel()
        default:
            break
        }
    }
    
    @objc func decreaseControlPanelState(byHandlingGestureRecognizedBy recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            switch controlPanelView.model.state {
            case .vertex:
                controlPanelView.model.state = .path
            case.path:
                controlPanelView.model.state = .network
            case .network:
                controlPanelView.model.state = .cable
            case .cable:
                controlPanelView.model.state = .router
            case .router:
                controlPanelView.model.state = .vertex
            }
            controlPanelView.updateViewFromModel()
        default:
            break
        }
    }
    
    @objc func hideKeyBoard(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer) {
        controlPanelView.firstTextField.endEditing(true)
        controlPanelView.secondTextField.endEditing(true)
        controlPanelView.thirdTextField.endEditing(true)
        controlPanelView.fourthTextField.endEditing(true)
    }
    
    @objc func addVertexAction(sender: UIButton!) {
        switch controlPanelView.model.state {
        case .cable:
            return
        case .router:
            return
        case .vertex:
            break
        case .network:
            return
        case .path:
            return
        }
        
        if let x = Double(controlPanelView.firstTextField.text ?? "?"),
            let y = Double(controlPanelView.secondTextField.text ?? "?"),
            let weight = Double(controlPanelView.thirdTextField.text ?? "?"),
            let delta = Double(controlPanelView.fourthTextField.text ?? "?") {
            if delta == 0 || weight == 0 {
                return
            }
            
            let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            for vertex in graph.vertexes {
                if distance(between: vertex.point, and: point) <= mapView.radius {
                    return
                }
            }
            graph.addVertex(Vertex(point, weight, delta))
            
            mapView.setNeedsDisplay()
            controlPanelView.firstTextField.text = nil
            controlPanelView.secondTextField.text = nil
            controlPanelView.thirdTextField.text = nil
            controlPanelView.fourthTextField.text = nil
        }
    }
    
    @objc func addCableAction(sender: UIButton!) {
        switch controlPanelView.model.state {
        case .cable:
            break
        case .router:
            return
        case .vertex:
            return
        case .network:
            return
        case .path:
            return
        }
        
        if let capacity = Int(controlPanelView.firstTextField.text ?? "?"),
            let price = Int(controlPanelView.secondTextField.text ?? "?") {
            let cable = Cable(capacity: capacity, price: price)
            
            graph.addCable(cable)
            mapView.setNeedsDisplay()
            controlPanelView.firstTextField.text = nil
            controlPanelView.secondTextField.text = nil
        }
    }
    
    @objc func buildNetworkAction(sender: UIButton!) {
        switch controlPanelView.model.state {
        case .cable:
            return
        case .router:
            return
        case .vertex:
            return
        case .network:
            break
        case .path:
            return
        }
        
        if let totalTraffic = Double(controlPanelView.firstTextField.text ?? "?") {
            let _ = graph.buildNetwork(with: totalTraffic)
            mapView.setNeedsDisplay()
            controlPanelView.firstTextField.text = nil
        }
    }
    
    @objc func buildPathAction(sender: UIButton!) {
        switch controlPanelView.model.state {
        case .cable:
            return
        case .router:
            return
        case .vertex:
            return
        case .network:
            return
        case .path:
            break
        }
        
        if let from = Int(controlPanelView.firstTextField.text ?? "?"),
            let to = Int(controlPanelView.secondTextField.text ?? "?") {
            var cnt = 0
            for vertex in graph.vertexes {
                if vertex.identifier == from {
                    cnt += 1
                }
                if vertex.identifier == to {
                    cnt += 1
                }
            }
            
            if  cnt != 2 {
                return
            }
            
            graph.buildPath(from, to)
            
            mapView.setNeedsDisplay()
            controlPanelView.firstTextField.text = nil
            controlPanelView.secondTextField.text = nil
            controlPanelView.thirdTextField.text = nil
            controlPanelView.fourthTextField.text = nil
        }
    }
    
    @objc private func removeVertex(byHandlingGestureRecognizedBy recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .failed:
            break
        case.ended:
            let point = mapView.applyReverseTransformation(to: recognizer.location(in: mapView), in: mapView.bounds)
            if graph.vertexes.count > 0 {
                for vertex in graph.vertexes {
                    if distance(between: vertex.point, and: point) <= mapView.radius {
                        graph.deleteVertex(vertex)
                        break
                    }
                }
            }
        default:
            break
        }
        mapView.setNeedsDisplay()
    }
}

extension UIColor {
    static var lightBlue: UIColor {
        return UIColor(red: 1.0/256*135, green: 1.0/256*206, blue: 1.0/256*250, alpha: 1)
    }
    static var orange: UIColor {
        return UIColor(red: 1.0/256*237, green: 1.0/256*128, blue: 1.0/256*27, alpha: 1)
    }
    static var red: UIColor {
        return UIColor(red: 1.0/256*226, green: 1.0/256*31, blue: 1.0/256*37, alpha: 1)
    }
}
