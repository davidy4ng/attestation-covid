//
//  FormViewModels.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import Foundation

enum FormSection: Int, CaseIterable {
    enum InfoContent: Int, CaseIterable {
        case firstname
        case lastname
        case birthdate
        case birthplace
        case address
        case city
        case zipCode
    }

    enum MotivesContent: Int, CaseIterable {
        case pro
        case shop
        case health
        case family
        case brief
        case administrative
        case tig
    }

    enum DateContent: Int, CaseIterable {
        case date
        case time
    }

    case info
    case motives
    case date
}
