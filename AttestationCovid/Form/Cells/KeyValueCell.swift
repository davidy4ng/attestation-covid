//
//  KeyValueCell.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

final class KeyValueCell: UITableViewCell {
    static let identifier: String = "KeyValueCellIdentifier"

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField! {
        didSet {
            valueTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        }
    }
    private var valueChangedHandler: ((String) -> Void)?

    func configure(name: String, placeholderValue: String = "", value: String = "", valueChangedHandler: ((String) -> Void)? = nil) {
        nameLabel.text = name
        valueTextField.placeholder = placeholderValue
        valueTextField.text = value
        valueTextField.inputView = nil
        valueTextField.returnKeyType = .next
        valueTextField.delegate = self
        self.valueChangedHandler = valueChangedHandler
    }
}

extension KeyValueCell {
    @objc private func textValueChanged() {
        valueChangedHandler?(valueTextField.text ?? "")
    }

    @objc private func dismissKeyboard() {
        valueTextField.resignFirstResponder()
    }
}

extension KeyValueCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find next cell
        if let nextCell = self.superview?.viewWithTag(self.tag + 1) as? UITableViewCell {
            if let nextCell = nextCell as? KeyValueCell {
                nextCell.valueTextField.becomeFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
