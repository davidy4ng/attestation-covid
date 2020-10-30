//
//  CertificateListViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class CertificateListViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var deleteAllCertificatesButton: UIBarButtonItem!
    
    // MARK: Attributes
    
    private var certificates: [URL] = []
    
    private var documentDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: Viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells
        self.registerCells()
        
        // Delete all certificates
        self.deleteAllCertificatesButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                
                self?.showDeleteAllCertificatesAlert()
                
            })
            .disposed(by: self.disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Reload data
        self.load {
            
            // Reload tableView
            self.tableView.reloadData()
            
        }
        
    }
    
    // MARK: Methods
    
    private func registerCells() {
        tableView.register(FileCell.self, forCellReuseIdentifier: FileCell.identifier)
    }
    
    private func load(completion: () -> Void) {
        if let documentDirectory = documentDirectory,
           let files = try? FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: []) {
            self.certificates = files
            completion()
        }
    }
    
    private func removeCertificate(at index: Int) throws {
        try FileManager.default.removeItem(at: self.certificates[index])
        self.certificates.remove(at: index)
    }
    
    private func removeAllCertificates() throws {
        
        // Foreach certificate index
        try self.certificates.forEach { (url: URL) in
            
            // Delete item at url
            try FileManager.default.removeItem(at: url)
            
        }
        
        // Reload data
        self.load() {
            
            // Reload tableView
            self.tableView.reloadData()
            
        }
        
    }
    
    private func showDeleteAllCertificatesAlert() {
        
        // Alert controller
        let alertController = UIAlertController(title: NSLocalizedString("certificates.deleteall.alert.title", comment: ""),
                                                message: NSLocalizedString("certificates.deleteall.alert.message", comment: ""),
                                                preferredStyle: .alert)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: NSLocalizedString("certificates.deleteall.alert.cancel", comment: ""),
                                         style: .default,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        // Delete action
        let deleteAction = UIAlertAction(title: NSLocalizedString("certificates.deleteall.alert.delete", comment: ""),
                                         style: .destructive,
                                         handler: { [weak self] _ in
                                            
                                            do {
                                                
                                                // Remove all certificates
                                                try self?.removeAllCertificates()
                                                
                                            }
                                            catch {
                                                
                                                self?.showAlert(message: "Une erreur s'est produite. Impossible de supprimer les attestations")
                                                
                                            }
                                            
                                         })
        alertController.addAction(deleteAction)
        
        // Show alert
        self.present(alertController,
                     animated: true,
                     completion: nil)
        
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try removeCertificate(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                showAlert(message: "Une erreur s'est produite. Impossible de supprimer l'attestation")
            }
        }
    }
}
