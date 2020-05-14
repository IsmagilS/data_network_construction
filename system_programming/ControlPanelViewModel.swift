//
//  ControlPanelViewModel.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 12.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation
import UIKit

class ControlPanelViewModel {
    private(set) var actionButtonFrame = CGRect()
    private(set) var firstTextFieldFrame = CGRect()
    private(set) var secondTextFieldFrame = CGRect()
    private(set) var thirdTextFieldFrame = CGRect()
    private(set) var fourthTextFieldFrame = CGRect()
    private(set) var upperBoundFrame = CGRect()
    
    init(in rect: CGRect, with model: ControlPanelModel) {
        upperBoundFrame = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width, height: 3.0))
        
        let actionButtonWidth = model.buttonText.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]).width
        actionButtonFrame.size.width = actionButtonWidth
        actionButtonFrame.size.height = 30.0
        let upperSpacing = (rect.height - actionButtonFrame.height) / 3
        actionButtonFrame.origin = rect.origin.offset(dx: leftSpacing, dy: upperSpacing)
        
        let firstTextWidth = model.firstTextPlaceholder.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]).width
        firstTextFieldFrame.size.width = firstTextWidth
        let firstTextFieldOrigin = CGPoint(x: actionButtonFrame.maxX + CGFloat(buttonToTextSpacing), y: actionButtonFrame.minY)
        let firstTextFieldSize = CGSize(width: max(firstTextFieldFrame.width, 2 * actionButtonFrame.height), height: actionButtonFrame.height)
        firstTextFieldFrame = CGRect(origin: firstTextFieldOrigin, size: firstTextFieldSize)
        
        let secondTextWidth = model.secondTextPlaceholder.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]).width
        secondTextFieldFrame.size.width = secondTextWidth
        let secondTextFieldOrigin = CGPoint(x: firstTextFieldFrame.maxX + CGFloat(buttonToTextSpacing), y: actionButtonFrame.minY)
        let secondTextFieldSize = CGSize(width: max(secondTextFieldFrame.width, 2 * actionButtonFrame.height), height: actionButtonFrame.height)
        secondTextFieldFrame = CGRect(origin: secondTextFieldOrigin, size: secondTextFieldSize)
        
        let thirdTextWidth = model.thirdTextPlaceholder.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]).width
        thirdTextFieldFrame.size.width = thirdTextWidth
        let thirdTextFieldOrigin = CGPoint(x: firstTextFieldOrigin.x, y: firstTextFieldFrame.maxY + upperSpacing / 2)
        let thirdTextFieldSize = CGSize(width: max(thirdTextFieldFrame.width, 2 * actionButtonFrame.height), height: actionButtonFrame.height)
        
        let fourthTextWidth = model.fourthTextPlaceholder.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]).width
        fourthTextFieldFrame.size.width = fourthTextWidth
        let fourthTextFieldOrigin = CGPoint(x: secondTextFieldOrigin.x, y: firstTextFieldFrame.maxY + upperSpacing / 2)
        let fourthTextFieldSize = CGSize(width: max(fourthTextFieldFrame.width, 2 * actionButtonFrame.height), height: actionButtonFrame.height)
        
        if model.state == .vertex {
            thirdTextFieldFrame = CGRect(origin: thirdTextFieldOrigin, size: thirdTextFieldSize)
            fourthTextFieldFrame = CGRect(origin: fourthTextFieldOrigin, size: fourthTextFieldSize)
        } else if model.state == .network {
            secondTextFieldFrame = CGRect.zero
            thirdTextFieldFrame = CGRect.zero
            fourthTextFieldFrame = CGRect.zero
        } else {
            thirdTextFieldFrame = CGRect.zero
            fourthTextFieldFrame = CGRect.zero
        }
    }
    
    let leftSpacing = CGFloat(10.0)
    let rightSpacing = CGFloat(10.0)
    let buttonToTextSpacing = CGFloat(20.0)
}
