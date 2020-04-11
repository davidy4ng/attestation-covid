//
//  PDFAttestationViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit
import PDFKit

final class AttestationViewController: UIViewController {
    private lazy var pdfView: PDFView = {
        let pdfView = PDFView(frame: view.bounds)
        return pdfView
    }()

    let document: PDFDocument

    init(document: PDFDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view.addSubview(pdfView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Attestation"

        pdfView.document = document
    }
}
