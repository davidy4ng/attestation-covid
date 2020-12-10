//
//  AttestationQRCodeBuilder.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

enum CertificateQRCodeBuilderError: Error {
    case qrCodeGeneratorUnavailable
    case qrCodeGenrationFailed
    case qrCodeConversionToCGImageFailed
}

struct CertificateQRCodeBuilder {
    static func build(from attestation: Certificate, creationDate: Date) throws -> UIImage {
        let formattedCreationDate = DateFormatter.date.string(from: creationDate)
        let formattedCreationTime = DateFormatter.shortTime.string(from: creationDate)

        let strings: [String] = [
            "Cree le: \(formattedCreationDate) a \(formattedCreationTime)",
            "Nom: \(attestation.lastname)",
            "Prenom: \(attestation.firstname)",
            "Naissance: \(attestation.birthdate) a \(attestation.birthplace)",
            "Adresse: \(attestation.fullAddress)",
            "Sortie: \(attestation.formattedDate) a \(attestation.formattedHour)h\(attestation.formattedMinute)",
            "Motifs: \(attestation.motives.displayableValue)"
        ]

        let content = strings.joined(separator: ";\n")
        let data = content.data(using: .utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            throw CertificateQRCodeBuilderError.qrCodeGeneratorUnavailable
        }

        qrFilter.setValue(data, forKey: "inputMessage")

        guard let qrImage = qrFilter.outputImage else {
            throw CertificateQRCodeBuilderError.qrCodeGenrationFailed
        }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else {
            throw CertificateQRCodeBuilderError.qrCodeConversionToCGImageFailed
        }

        return UIImage(cgImage: cgImage)
    }
}
