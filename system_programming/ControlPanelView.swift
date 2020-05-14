//
//  ControlPanelView.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 05.04.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import Foundation
import UIKit

class ControlPanelView: UIView {
    lazy var viewModel = ControlPanelViewModel(in: .zero, with: model)
    var model = ControlPanelModel()
    let actionButton = UIButton()
    let upperBound = UIView()
    let firstTextField = UITextField()
    let secondTextField = UITextField()
    let thirdTextField = UITextField()
    let fourthTextField = UITextField()
    
    func updateViewFromModel() {
        viewModel = ControlPanelViewModel(in: frame, with: model)
        firstTextField.placeholder = model.firstTextPlaceholder
        secondTextField.placeholder = model.secondTextPlaceholder
        thirdTextField.placeholder = model.thirdTextPlaceholder
        fourthTextField.placeholder = model.fourthTextPlaceholder
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: model.buttonText, attributes: attributes)
        actionButton.setAttributedTitle(attributedString, for: .normal)
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        firstTextField.font = UIFont.systemFont(ofSize: 15.0)
        firstTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        firstTextField.returnKeyType = UIReturnKeyType.done
        firstTextField.clearsOnBeginEditing = true
        firstTextField.textColor = .white
        firstTextField.clearButtonMode = .whileEditing
        
        secondTextField.font = UIFont.systemFont(ofSize: 15.0)
        secondTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        secondTextField.returnKeyType = UIReturnKeyType.done
        secondTextField.clearsOnBeginEditing = true
        secondTextField.textColor = .white
        secondTextField.clearButtonMode = .whileEditing
        
        thirdTextField.font = UIFont.systemFont(ofSize: 15.0)
        thirdTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        thirdTextField.returnKeyType = UIReturnKeyType.done
        thirdTextField.clearsOnBeginEditing = true
        thirdTextField.textColor = .white
        thirdTextField.clearButtonMode = .whileEditing
        
        fourthTextField.font = UIFont.systemFont(ofSize: 15.0)
        fourthTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        fourthTextField.returnKeyType = UIReturnKeyType.done
        fourthTextField.clearsOnBeginEditing = true
        fourthTextField.textColor = .white
        fourthTextField.clearButtonMode = .whileEditing
        
        updateViewFromModel()
        self.addSubview(upperBound)
        self.addSubview(actionButton)
        self.addSubview(firstTextField)
        self.addSubview(secondTextField)
        self.addSubview(thirdTextField)
        self.addSubview(fourthTextField)
    }
    
    override func draw(_ rect: CGRect) {
        viewModel = ControlPanelViewModel(in: rect, with: model)
        
        upperBound.frame = viewModel.upperBoundFrame
        upperBound.backgroundColor = .lightBlue

        actionButton.frame = viewModel.actionButtonFrame
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
        actionButton.backgroundColor = .lightBlue
        
        firstTextField.frame = viewModel.firstTextFieldFrame
        firstTextField.layer.cornerRadius = firstTextField.frame.height / 2
        firstTextField.backgroundColor = .lightBlue
        
        secondTextField.frame = viewModel.secondTextFieldFrame
        secondTextField.layer.cornerRadius = secondTextField.frame.height / 2
        secondTextField.backgroundColor = .lightBlue
        
        thirdTextField.frame = viewModel.thirdTextFieldFrame
        thirdTextField.layer.cornerRadius = thirdTextField.frame.height / 2
        thirdTextField.backgroundColor = .lightBlue
        
        fourthTextField.frame = viewModel.fourthTextFieldFrame
        fourthTextField.layer.cornerRadius = fourthTextField.frame.height / 2
        fourthTextField.backgroundColor = .lightBlue
    }
}
