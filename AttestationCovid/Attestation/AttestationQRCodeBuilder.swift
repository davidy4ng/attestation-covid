//
//  AttestationQRCodeBuilder.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

struct AttestationQRCodeBuilder {
    static func build(from attestation: Attestation, creationDate: Date) -> UIImage {
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

        let content = strings.joined(separator: "; ")
        let data = content.data(using: .ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            fatalError("QR code generation unavailable")
        }

        qrFilter.setValue(data, forKey: "inputMessage")

        guard let qrImage = qrFilter.outputImage else {
            fatalError("QR code generation failed")
        }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else {
            fatalError("QR code conversion to CGImage failed")
        }

        return UIImage(cgImage: cgImage)
    }
}
