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
    
    // Constraints outlets for iOS 12 compatibility
    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenConstraint: NSLayoutConstraint!
    @IBOutlet weak var topPickerConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        }
    }
    
    private var valueChangedHandler: ((Date) -> Void)?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if #available(iOS 14.0, *) {} else {
            bottomLabelConstraint.isActive = false
            betweenConstraint.isActive = false
            topPickerConstraint.isActive = false
            
            NSLayoutConstraint.activate([
                nameLabel.heightAnchor.constraint(equalToConstant: 30),
                nameLabel.rightAnchor.constraint(greaterThanOrEqualTo: nameLabel.superview!.rightAnchor, constant: 16),
                nameLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: 8),
                datePicker.leftAnchor.constraint(equalTo: datePicker.superview!.leftAnchor, constant: 16)
            ])
        }
    }
    
    func configure(name: String, mode: UIDatePicker.Mode, defaultDate: Date = Date(timeIntervalSince1970: 0), minDate: Date? = nil, maxDate: Date? = nil, valueChangedHandler: ((Date) -> Void)? = nil) {
        nameLabel.text = name
        datePicker.date = defaultDate
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        
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

