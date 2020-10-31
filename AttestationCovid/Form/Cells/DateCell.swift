//
//  DateCell.swift
//  AttestationCovid
//
//  Created by Thomas Brichart on 31/10/2020.
//  Copyright © 2020 Thomas Brichart. All rights reserved.
//

import UIKit

final class DateCell: UITableViewCell {
    static let identifier: String = "DateCellIdentifier"
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        }
    }
    
    private var valueChangedHandler: ((Date) -> Void)?
    
    func configure(name: String, mode: UIDatePicker.Mode, defaultDate: Date = Date(timeIntervalSince1970: 0), minDate: Date? = nil, maxDate: Date? = nil, valueChangedHandler: ((Date) -> Void)? = nil) {
        nameLabel.text = name
        datePicker.date = defaultDate
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = mode
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate

        self.valueChangedHandler = valueChangedHandler
        
        if let valueChangedHandler = valueChangedHandler {
            valueChangedHandler(defaultDate)
        }
    }
}

extension DateCell {
    @objc private func dateValueChanged() {
        valueChangedHandler?(datePicker.date)
    }
}

