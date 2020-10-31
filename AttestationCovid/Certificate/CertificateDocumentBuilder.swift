//
//  AttestationDocumentBuilder.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import Foundation
import PDFKit

enum CertificateDocumentBuilderError: Error {
    case unableToOpenCertificate
}

private enum AnnotationWidth {
    case fittingPage(CGFloat)
    case width(CGFloat)
}

struct CertificateDocumentBuilder {

    static func buildDocument(from attestation: Certificate, creationDate: Date = Date()) throws -> PDFDocument {
        guard let document = PDFDocument(url: Bundle.main.url(forResource: "certificate", withExtension: "pdf")!) else {
            throw CertificateDocumentBuilderError.unableToOpenCertificate
        }

        let mainPage = document.page(at: 0)
        let pageWidth = mainPage?.bounds(for: .mediaBox).width ?? 600

        mainPage?.addAnnotation(makeTextAnnotation(text: attestation.displayName, x: 123, y: 696, width: .fittingPage(pageWidth)))
        mainPage?.addAnnotation(makeTextAnnotation(text: attestation.birthdate, x: 123, y: 674, width: .fittingPage(pageWidth)))
        mainPage?.addAnnotation(makeTextAnnotation(text: attestation.birthplace, x: 300, y: 674, width: .fittingPage(pageWidth)))
        mainPage?.addAnnotation(makeTextAnnotation(text: attestation.fullAddress, x: 134, y: 652, width: .fittingPage(pageWidth)))

        if attestation.motives.contains(.pro) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 576))
        }
        if attestation.motives.contains(.shop) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 531))
        }
        if attestation.motives.contains(.health) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 475))
        }
        if attestation.motives.contains(.family) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 435))
        }
        if attestation.motives.contains(.handicap) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 393))
        }
        if attestation.motives.contains(.brief) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 354))
        }
        if attestation.motives.contains(.administrative) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 292))
        }
        if attestation.motives.contains(.tig) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 253))
        }
        if attestation.motives.contains(.school) {
            mainPage?.addAnnotation(makeCheckmarkAnnotation(x: 74, y: 208))
        }

        mainPage?.addAnnotation(makeTextAnnotation(text: attestation.city, x: 111, y: 175, width: .fittingPage(pageWidth)))
        mainPage?.addAnnotation(makeTextAnnotation(text: attestation.formattedDate, x: 92, y:152, width: .width(80)))
        
        let time = attestation.formattedHour + ":" + attestation.formattedMinute
        mainPage?.addAnnotation(makeTextAnnotation(text: time, x: 255, y: 152, width: .width(60)))

        let qrImage = try CertificateQRCodeBuilder.build(from: attestation, creationDate: creationDate)
        mainPage?.addAnnotation(makeImageAnnotation(image: qrImage, x: pageWidth - 170, y: 110, width: 100, height: 100))
        makeCreationDateAnnotations(creationDate: creationDate).forEach { mainPage?.addAnnotation($0) }

        let qrPage = PDFPage()
        let qrPageHeight = qrPage.bounds(for: .mediaBox).height
        qrPage.addAnnotation(makeImageAnnotation(image: qrImage, x: 50, y: qrPageHeight - 350, width: 300, height: 300))
        document.insert(qrPage, at: 1)

        return document
    }

    private static func makeTextAnnotation(text: String, x: CGFloat, y: CGFloat, width: AnnotationWidth, fontSize: CGFloat = 11) -> PDFAnnotation {
        let safeMargin: CGFloat = 50
        let adjustedYDelta: CGFloat = -8

        let widthValue: CGFloat = {
            switch width {
            case .fittingPage(let pageWidth):
                return pageWidth - x - safeMargin
            case .width(let value):
                return value
            }
        }()

        let annotation = PDFAnnotation(bounds: CGRect(x: x, y: y + adjustedYDelta, width: widthValue, height: 20), forType: .freeText, withProperties: nil)
        annotation.contents = text
        annotation.color = .clear
        annotation.fontColor = .black
        annotation.font = UIFont(name: "Helvetica", size: fontSize)
        annotation.alignment = .left

        return annotation
    }

    private static func makeCheckmarkAnnotation(x: CGFloat, y: CGFloat) -> PDFAnnotation {
        let adjustedYDelta: CGFloat = -8
        let annotation = PDFAnnotation(bounds: CGRect(x: x, y: y + adjustedYDelta, width: 20, height: 25), forType: .freeText, withProperties: nil)
        annotation.contents = "X"
        annotation.color = .clear
        annotation.fontColor = .black
        annotation.font = UIFont(name: "Helvetica", size: 18)
        annotation.alignment = .left

        return annotation
    }

    private static func makeCreationDateAnnotations(creationDate: Date) -> [PDFAnnotation] {
        let date = DateFormatter.date.string(from: creationDate)
        let time = DateFormatter.shortTime.string(from: creationDate)
        let line1Annotation = makeTextAnnotation(text: "Date de création:", x: 464, y: 100, width: .width(80), fontSize: 7)
        let line2Annotation = makeTextAnnotation(text: "\(date) à \(time)", x: 455, y: 94, width: .width(80), fontSize: 7)

        return [line1Annotation, line2Annotation]
    }

    private static func makeImageAnnotation(image: UIImage, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> PDFAnnotation {
        let annotation = PDFImageAnnotation(image, bounds: CGRect(x: x, y: y, width: width, height: height), properties: nil)
        return annotation
    }
}

class PDFImageAnnotation: PDFAnnotation {
    var image: UIImage?

    convenience init(_ image: UIImage?, bounds: CGRect, properties: [AnyHashable : Any]?) {
        self.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        self.image = image
    }

    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        super.draw(with: box, in: context)

        // Drawing the image within the annotation's bounds.
        guard let cgImage = image?.cgImage else { return }
        context.draw(cgImage, in: bounds)
    }
}
