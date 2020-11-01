//
//  CertificateListViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

final class CertificateListViewController: UITableViewController {
    
    @IBOutlet private weak var deleteAllButton: UIButton!
    
    @IBAction func deleteAllCertificates(_ sender: Any) {
        let alertController = UIAlertController(title: "Confirmation", message: NSLocalizedString("alert.deleteAllAttestion", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive, handler: { _ in
            for i in (0..<self.certificates.count).reversed() {
                let indexPath = IndexPath(row: i, section: 0)
                
                do {
                    try self.removeCertificate(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    self.showAlert(message: NSLocalizedString("error.cannotDeleteAttestation", comment: ""))
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private var certificates: [URL] = []

    private var documentDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        tableView.tableFooterView = UIView()
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
        if let documentDirectory = documentDirectory, var files = try? FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: []) {
                // Sort by date, show newest on top of the list
                try? files.sort { (leftUrl: URL, rightUrl: URL) -> Bool in

                let leftAttributes = try FileManager.default.attributesOfItem(atPath: leftUrl.path)
                let rightAttributes = try FileManager.default.attributesOfItem(atPath: rightUrl.path)

                return (leftAttributes[.creationDate] as? Date ?? Date()) > (rightAttributes[.creationDate] as? Date ?? Date())
            }
            
            self.certificates = files
            completion()
        }

    }
}

extension CertificateListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if certificates.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = UIView()
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = NSLocalizedString("filelist.empty", comment: "")
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 1
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .none
        }
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certificates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.identifier, for: indexPath) as? FileCell else {
            fatalError("Could not dequeue FileCell")
        }

        let dateString = certificates[indexPath.row].lastPathComponent.split(separator: "_")[1]
        let timeString = certificates[indexPath.row].lastPathComponent.split(separator: "_")[2].split(separator: ".")[0]
        
        let dateAndTime = dateString + "_" + timeString
        if let date = DateFormatter.readableDateTime.date(from: String(dateAndTime)) {
        
            let string = NSLocalizedString("attestation.generated.on", comment: "") + DateFormatter.date.string(from: date) + NSLocalizedString("attestation.generated.at", comment: "") + DateFormatter.time.string(from: date)
        
            cell.textLabel?.text = string
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let documentURL = certificates[indexPath.row]

        let attestationViewController = CertificateViewController(documentURL: documentURL)
        let navigationController = UINavigationController(rootViewController: attestationViewController)
        present(navigationController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try removeCertificate(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                showAlert(message: NSLocalizedString("error.cannotDeleteAttestation", comment: ""))
            }
        }
    }
}

extension CertificateListViewController {
    private func removeCertificate(at index: Int) throws {
        try FileManager.default.removeItem(at: certificates[index])
        certificates.remove(at: index)
    }
}
