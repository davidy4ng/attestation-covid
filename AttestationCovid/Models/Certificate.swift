//
//  Attestation.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import Foundation

enum CertificateError: Error {
    case missingInfo(String)
}

extension CertificateError: LocalizedError {
    var errorDescription: String? {
        if case let CertificateError.missingInfo(key) = self {
            return NSLocalizedString("error.missingInfo", comment: "") + "\(key)"
        }
        return nil
    }
}

struct Certificate: Codable {
    struct Motive: OptionSet, Codable {
        let rawValue: Int

        static let pro = Motive(rawValue: 1 << 0)
        static let shop = Motive(rawValue: 1 << 1)
        static let health = Motive(rawValue: 1 << 2)
        static let family = Motive(rawValue: 1 << 3)
        static let handicap = Motive(rawValue: 1 << 4)
        static let brief = Motive(rawValue: 1 << 5)
        static let administrative = Motive(rawValue: 1 << 6)
        static let tig = Motive(rawValue: 1 << 7)
        static let school = Motive(rawValue: 1 << 8)

        var displayableValue: String {
            var values: [String] = []
            if contains(.pro) { values.append("travail") }
            if contains(.shop) { values.append("courses") }
            if contains(.health) { values.append("sante") }
            if contains(.family) { values.append("famille") }
            if contains(.handicap) { values.append("handicap") }
            if contains(.brief) { values.append("sport") }
            if contains(.administrative) { values.append("judiciaire") }
            if contains(.tig) { values.append("missions") }
            if contains(.school) { values.append("ecole") }

            return values.joined(separator: "-")
        }
    }

    var firstname: String
    var lastname: String
    var birthdate: String
    var birthplace: String
    var address: String
    var city: String
    var zipCode: String
    var motives: Motive
    var date: Date

    var displayName: String {
        return "\(firstname) \(lastname)"
    }

    var fullAddress: String {
        return "\(address) \(zipCode) \(city)"
    }

    var formattedDate: String {
        return DateFormatter.date.string(from: date)
    }

    var formattedHour: String {
        return DateFormatter.hour.string(from: date)
    }

    var formattedMinute: String {
        return DateFormatter.minute.string(from: date)
    }

    init(firstname: String = "", lastname: String = "", birthdate: String = "", birthplace: String = "", address: String = "", city: String = "", zipCode: String = "", motives: Motive = [], date: Date = Date()) {
        self.firstname = firstname
        self.lastname = lastname
        self.birthdate = birthdate
        self.birthplace = birthplace
        self.address = address
        self.city = city
        self.zipCode = zipCode
        self.motives = motives
        self.date = date
    }

    func checkValidity() -> Result<Void, Error> {
        if firstname.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("firstname", comment: "")))
        }
        if lastname.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("lastname", comment: "")))
        }
        if birthdate.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("birthdate", comment: "")))
        }
        if birthplace.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("birthplace", comment: "")))
        }
        if address.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("address", comment: "")))
        }
        if city.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("city", comment: "")))
        }
        if zipCode.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("zipCode", comment: "")))
        }
        if motives.isEmpty {
            return .failure(CertificateError.missingInfo(NSLocalizedString("reason", comment: "")))
        }
        return .success(())
    }
}
