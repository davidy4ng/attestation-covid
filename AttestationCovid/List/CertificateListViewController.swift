//
//  CertificateListViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

final class CertificateListViewController: UITableViewController {

    private var certificates: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        load {
            tableView.reloadData()
        }
    }

    private func registerCells() {
        tableView.register(FileCell.self, forCellReuseIdentifier: FileCell.identifier)
    }

    private func load(completion: () -> Void) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let files = try? FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: []) {
            self.certificates = files
            completion()
        }

    }
}

extension CertificateListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certificates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.identifier, for: indexPath) as? FileCell else {
            fatalError("Could not dequeue FileCell")
        }

        cell.textLabel?.text = certificates[indexPath.row].lastPathComponent

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let documentURL = certificates[indexPath.row]

        let attestationViewController = CertificateViewController(documentURL: documentURL)
        let navigationController = UINavigationController(rootViewController: attestationViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
