//
//  CheckCell.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

final class CheckCell: UITableViewCell {
    static let identifier: String = "CheckCellIdentifier"

    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var checkButton: CheckButton!

    var valueChangedHandler: ((Bool) -> Void)?

    func configure(content: String, selected: Bool = false, valueChangedHandler: ((Bool) -> Void)? = nil) {
        contentLabel.text = content
        checkButton.isSelected = selected
        checkButton.onSelectionChange = valueChangedHandler
    }
}
