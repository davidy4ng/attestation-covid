//
//  PDFAttestationViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit
import WebKit

final class CertificateViewController: UIViewController {
    private lazy var viewer: WKWebView = {
        let webView = WKWebView(frame: view.bounds)
        return webView
    }()

    let documentURL: URL

    init(documentURL: URL) {
        self.documentURL = documentURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view.addSubview(viewer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Attestation"

        let closeBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewer.load(URLRequest(url: documentURL))
    }

    @objc
    private func close() {
        dismiss(animated: true, completion: nil)
    }

}
