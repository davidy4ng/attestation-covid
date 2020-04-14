//
//  DateUtils.swift
//  AttestationCovid
//
//  Created by David Yang on 14/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import Foundation

extension Date {
    func dateByAdding(year: Int) -> Date? {
        var dateComponents = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        dateComponents.year = year

        return calendar.date(byAdding: dateComponents, to: self)
    }
}
