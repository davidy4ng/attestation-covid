//
//  ViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

final class FormViewController: UITableViewController {

    private let certificatePreferences = DefaultCertificatePreferences()

    private lazy var attestation: Certificate = {
        var attestation = Certificate()
        attestation.firstname = certificatePreferences.firstname
        attestation.lastname = certificatePreferences.lastname
        attestation.birthdate = certificatePreferences.birthday
        attestation.birthplace = certificatePreferences.birthplace
        attestation.address = certificatePreferences.address
        attestation.city = certificatePreferences.city
        attestation.zipCode = certificatePreferences.zipCode
        return attestation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return FormSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FormSection(rawValue: section) {
        case .info?:
            return FormSection.InfoContent.allCases.count
        case .motives?:
            return FormSection.MotivesContent.allCases.count
        case .date?:
            return FormSection.DateContent.allCases.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = FormSection(rawValue: indexPath.section) else {
            fatalError("Unknown section for indexPath")
        }

        switch (section, indexPath.row) {
        // INFO section
        case (.info, FormSection.InfoContent.firstname.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("firstname", comment: ""), placeholderValue: "Jean", value: certificatePreferences.firstname) { [weak self] value in
                self?.certificatePreferences.firstname = value
                self?.attestation.firstname = value
            }
            return cell
        case (.info, FormSection.InfoContent.lastname.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("lastname", comment: ""), placeholderValue: "Dupont", value: certificatePreferences.lastname) { [weak self] value in
                self?.certificatePreferences.lastname = value
                self?.attestation.lastname = value
            }
            return cell
        case (.info, FormSection.InfoContent.birthdate.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("birthdate", comment: ""), placeholderValue: "01/01/1970", value: certificatePreferences.birthday, inputType: .birthdate(DateFormatter.date)) { [weak self] value in
                self?.certificatePreferences.birthday = value
                self?.attestation.birthdate = value
            }
            return cell
        case (.info, FormSection.InfoContent.birthplace.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("birthplace", comment: ""), placeholderValue: "Lyon", value: certificatePreferences.birthplace) { [weak self] value in
                self?.certificatePreferences.birthplace = value
                self?.attestation.birthplace = value
            }
            return cell
        case (.info, FormSection.InfoContent.address.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("address", comment: ""), placeholderValue: "99 Avenue de France", value: certificatePreferences.address) { [weak self] value in
                self?.certificatePreferences.address = value
                self?.attestation.address = value
            }
            return cell
        case (.info, FormSection.InfoContent.city.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("city", comment: ""), placeholderValue: "Paris", value: certificatePreferences.city) { [weak self] value in
                self?.certificatePreferences.city = value
                self?.attestation.city = value
            }
            return cell
        case (.info, FormSection.InfoContent.zipCode.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("zipCode", comment: ""), placeholderValue: "75001", value: certificatePreferences.zipCode) { [weak self] value in
                self?.certificatePreferences.zipCode = value
                self?.attestation.zipCode = value
            }
            return cell

        // MOTIVES section
        case (.motives, FormSection.MotivesContent.pro.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.pro", comment: ""), selected: attestation.motives.contains(.pro)) { [weak self] value in
                if value {
                    self?.attestation.motives.insert(.pro)
                } else {
                    self?.attestation.motives.remove(.pro)
                }
            }
            return cell
        case (.motives, FormSection.MotivesContent.shop.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.shop", comment: ""), selected: attestation.motives.contains(.shop)) { [weak self] value in
                if value {
                    self?.attestation.motives.insert(.shop)
                } else {
                    self?.attestation.motives.remove(.shop)
                }
            }
            return cell
        case (.motives, FormSection.MotivesContent.health.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.health", comment: ""), selected: attestation.motives.contains(.health)) { [weak self] value in
                if value {
                    self?.attestation.motives.insert(.health)
                } else {
                    self?.attestation.motives.remove(.health)
                }
            }
            return cell
        case (.motives, FormSection.MotivesContent.family.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.family", comment: ""), selected: attestation.motives.contains(.family)) { [weak self] value in
                if value {
                    self?.attestation.motives.insert(.family)
                } else {
                    self?.attestation.motives.remove(.family)
                }
            }
            return cell
        case (.motives, FormSection.MotivesContent.brief.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.brief", comment: ""), selected: attestation.motives.contains(.brief)) { [weak self] value in
                if value {
                    self?.attestation.motives.insert(.brief)
                } else {
                    self?.attestation.motives.remove(.brief)
                }
            }
            return cell
        case (.motives, FormSection.MotivesContent.administrative.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.administrative", comment: ""), selected: attestation.motives.contains(.administrative)) { [weak self] value in
                if value {
                    self?.attestation.motives.insert(.administrative)
                } else {
                    self?.attestation.motives.remove(.administrative)
                }
            }
            return cell
        case (.motives, FormSection.MotivesContent.tig.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.tig", comment: ""), selected: attestation.motives.contains(.tig)) { [weak self] value in
                if value {
                    self?.attestation.motives.insert(.tig)
                } else {
                    self?.attestation.motives.remove(.tig)
                }
            }
            return cell

        // DATE section
        case (.date, FormSection.DateContent.date.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("date", comment: ""), value: DateFormatter.date.string(from: attestation.date), inputType: .date(DateFormatter.date)) { [weak self] dateString in
                guard let self = self else { return }
                let timeString = DateFormatter.time.string(from: self.attestation.date)
                let newDateString = "\(dateString) \(timeString)"
                if let newDate = DateFormatter.dateTime.date(from: newDateString) {
                    self.attestation.date = newDate
                }
            }
            return cell
        case (.date, FormSection.DateContent.time.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("time", comment: ""), value: DateFormatter.time.string(from: attestation.date), inputType: .time(DateFormatter.time)) { [weak self] timeString in
                guard let self = self else { return }
                let dateString = DateFormatter.date.string(from: self.attestation.date)
                let newDateString = "\(dateString) \(timeString)"
                if let newDate = DateFormatter.dateTime.date(from: newDateString) {
                    self.attestation.date = newDate
                }
            }
            return cell

        default:
            fatalError("Unknown row for indexPath")
        }
    }

    private func keyValueCell(_ tableView: UITableView, indexPath: IndexPath) -> KeyValueCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KeyValueCell.identifier, for: indexPath) as? KeyValueCell else {
            fatalError("Could not dequeue KeyValueCell")
        }
        cell.selectionStyle = .none
        return cell
    }

    private func checkCell(_ tableView: UITableView, indexPath: IndexPath) -> CheckCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckCell.identifier, for: indexPath) as? CheckCell else {
            fatalError("Could not dequeue CheckCell")
        }
        cell.selectionStyle = .none
        return cell
    }

    @IBAction func generateAttestation(_ sender: Any) {
        switch attestation.checkValidity() {
        case .success:
            print("generation du pdf")
            do {
                let creationDate = Date()
                let document = try CertificateDocumentBuilder.buildDocument(from: attestation, creationDate: creationDate)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let filename = String(format: NSLocalizedString("filename", comment: ""), DateFormatter.readableDateTime.string(from: creationDate))
                if let destinationPath = documentDirectory?.appendingPathComponent(filename) {
                    document.write(to: destinationPath)
                    let attestationViewController = CertificateViewController(documentURL: destinationPath)
                    let navigationController = UINavigationController(rootViewController: attestationViewController)
                    present(navigationController, animated: true, completion: nil)
                } else {
                    self.showAlert(message: "Impossible de sauvegarder le fichier.")
                }
            } catch {
                self.showAlert(message: error.localizedDescription)
            }
        case .failure(let error):
            self.showAlert(message: error.localizedDescription)
        }
    }

}
