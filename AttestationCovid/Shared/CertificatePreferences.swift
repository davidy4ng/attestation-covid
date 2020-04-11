//
//  CertificatePreferences.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import Foundation

protocol CertificatePreferences {
    var firstname: String { get set }
    var lastname: String { get set }
    var birthday: String { get set }
    var birthplace: String { get set }
    var address: String { get set }
    var city: String { get set }
    var zipCode: String { get set }
}

class DefaultCertificatePreferences: CertificatePreferences {
    private var userDefaults = UserDefaults.standard

    enum CertificatePreferencesKeys: String {
        case kFirstname
        case kLastname
        case kBirthday
        case kBirthplace
        case kAddress
        case kCity
        case kZipCode
    }

    var firstname: String {
        get {
            return userDefaults.string(forKey: CertificatePreferencesKeys.kFirstname.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: CertificatePreferencesKeys.kFirstname.rawValue)
        }
    }

    var lastname: String {
        get {
            return userDefaults.string(forKey: CertificatePreferencesKeys.kLastname.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: CertificatePreferencesKeys.kLastname.rawValue)
        }
    }

    var birthday: String {
        get {
            return userDefaults.string(forKey: CertificatePreferencesKeys.kBirthday.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: CertificatePreferencesKeys.kBirthday.rawValue)
        }
    }

    var birthplace: String {
        get {
            return userDefaults.string(forKey: CertificatePreferencesKeys.kBirthplace.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: CertificatePreferencesKeys.kBirthplace.rawValue)
        }
    }

    var address: String {
        get {
            return userDefaults.string(forKey: CertificatePreferencesKeys.kAddress.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: CertificatePreferencesKeys.kAddress.rawValue)
        }
    }

    var city: String {
        get {
            return userDefaults.string(forKey: CertificatePreferencesKeys.kCity.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: CertificatePreferencesKeys.kCity.rawValue)
        }
    }

    var zipCode: String {
        get {
            return userDefaults.string(forKey: CertificatePreferencesKeys.kZipCode.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: CertificatePreferencesKeys.kZipCode.rawValue)
        }
    }

}
