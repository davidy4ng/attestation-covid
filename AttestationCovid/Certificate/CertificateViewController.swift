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

        title = NSLocalizedString("certificate", comment: "")
        
        let closeBarButtonItem: UIBarButtonItem!
        let shareBarButtonItem: UIBarButtonItem!
        
        if #available(iOS 13.0, *) {
            closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
            shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        } else {
            closeBarButtonItem = UIBarButtonItem(title: NSLocalizedString("done", comment: ""), style: .done, target: self, action: #selector(close))
            shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        }
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
        navigationItem.leftBarButtonItem = shareBarButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewer.load(URLRequest(url: documentURL))
    }

    @objc
    private func close() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func share() {
        let activityViewController = UIActivityViewController(activityItems: [documentURL], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
