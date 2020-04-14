//
//  KeyValueCell.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

final class KeyValueCell: UITableViewCell {
    enum InputType {
        case text
        case date(DateFormatter, defaultDate: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil)
        case time(DateFormatter)
    }

    static let identifier: String = "KeyValueCellIdentifier"

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField! {
        didSet {
            valueTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        }
    }
    private var inputType: InputType = .text
    private var valueChangedHandler: ((String) -> Void)?

    func configure(name: String, placeholderValue: String = "", value: String = "", inputType: InputType = .text, valueChangedHandler: ((String) -> Void)? = nil) {
        nameLabel.text = name
        valueTextField.placeholder = placeholderValue
        valueTextField.text = value
        self.inputType = inputType
        switch inputType {
        case .date(let formatter, let defaultDate, let minDate, let maxDate):
            let currentDate = Date()
            let date = formatter.date(from: value) ?? defaultDate ?? currentDate
            valueTextField.inputView = makeDatePickerInputView(mode: .date, date: date, maxDate: maxDate, minDate: minDate)
            valueTextField.inputAccessoryView = nil
        case .time(let formatter):
            let date = formatter.date(from: value) ?? Date()
            valueTextField.inputView = makeDatePickerInputView(mode: .time, date: date)
            valueTextField.inputAccessoryView = nil
        default:
            valueTextField.inputView = nil
            valueTextField.inputAccessoryView = makeToolbarAccessoryView()
        }
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

extension KeyValueCell {
    private func makeToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPickerView))
        toolbar.items = [flexibleSpace, doneButton]

        return toolbar
    }

    private func makeToolbarAccessoryView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))

        let toolbar = makeToolbar()

        containerView.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        return containerView
    }

    private func makeDatePickerInputView(mode: UIDatePicker.Mode, date: Date, maxDate: Date? = nil, minDate: Date? = nil) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 300))

        let toolbar = makeToolbar()

        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.date = date
        if (maxDate != nil) {
          picker.maximumDate = maxDate
        }
        if (minDate != nil) {
          picker.minimumDate = minDate
        }
    
        picker.addTarget(self, action: #selector(updateDateTextValue(_:)), for: .valueChanged)

        containerView.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true

        containerView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.topAnchor.constraint(equalTo: toolbar.bottomAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        return containerView
    }

    @objc private func updateDateTextValue(_ sender: UIDatePicker) {
        switch inputType {
        case .date(let formatter, _, _, _):
            valueTextField.text = formatter.string(from: sender.date)
            textValueChanged()
        case .time(let formatter):
            valueTextField.text = formatter.string(from: sender.date)
            textValueChanged()
        default:
            break
        }
    }

    @objc private func dismissPickerView() {
        valueTextField.resignFirstResponder()
    }
}
