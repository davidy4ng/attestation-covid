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
                let indexPath: IndexPath!
                
                if i == 0 {
                    indexPath = IndexPath(row: i, section: 0)
                } else {
                    indexPath = IndexPath(row: i - 1, section: 1)
                }
                
                do {
                    try self.removeCertificate(at: indexPath)
                } catch {
                    self.showAlert(message: NSLocalizedString("error.cannotDeleteAttestation", comment: ""))
                }
            }
            
            self.tableView.reloadData()
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
            messageLabel.numberOfLines = 1
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .none
        }
     
        return certificates.count < 2 ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if certificates.count < 2 {
            return nil
        }
        
        return section == 0 ? NSLocalizedString("filesection.latest", comment: "") : NSLocalizedString("filesection.other", comment: "")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !certificates.isEmpty else { return 0 }
        
        if section == 0 || certificates.count < 2 {
            return 1
        } else {
            return certificates.count - 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.identifier, for: indexPath) as? FileCell else {
            fatalError("Could not dequeue FileCell")
        }
        
        let certificate = indexPath.section == 0 ? certificates[indexPath.row] : certificates[indexPath.row + 1]
        
        let dateString = certificate.lastPathComponent.split(separator: "_")[1]
        let timeString = certificate.lastPathComponent.split(separator: "_")[2].split(separator: ".")[0]
        
        let dateAndTime = dateString + "_" + timeString
        if let date = DateFormatter.readableDateTime.date(from: String(dateAndTime)) {
        
            let string = NSLocalizedString("attestation.generated.on", comment: "") + DateFormatter.date.string(from: date) + NSLocalizedString("attestation.generated.at", comment: "") + DateFormatter.time.string(from: date)
        
            cell.textLabel?.text = string
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let documentURL = indexPath.section == 0 ? certificates[indexPath.row] : certificates[indexPath.row + 1]

        let attestationViewController = CertificateViewController(documentURL: documentURL)
        let navigationController = UINavigationController(rootViewController: attestationViewController)
        present(navigationController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try removeCertificate(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                showAlert(message: NSLocalizedString("error.cannotDeleteAttestation", comment: ""))
            }
        }
    }
}

extension CertificateListViewController {
    private func removeCertificate(at indexPath: IndexPath) throws {
        
        let index = indexPath.section == 0 ? indexPath.row : indexPath.row + 1
        
        try FileManager.default.removeItem(at: certificates[index])
        certificates.remove(at: index)
    }
}
