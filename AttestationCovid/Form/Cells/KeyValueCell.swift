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
    @IBOutlet private weak var valueTextField: UITextField!

    func configure(name: String, placeholderValue: String = "", value: String = "") {
        nameLabel.text = name
        valueTextField.placeholder = placeholderValue
        valueTextField.text = value
    }
}
