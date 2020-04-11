//
//  ViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 11/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit

final class FormViewController: UITableViewController {

    var attestation = Attestation(firstname: "David", lastname: "Yang", birthdate: "26/08/1988", birthplace: "Montauban", address: "17 avenue pierre et marie curie", city: "Bouillargues", zipCode: "30230", motives: [.family], date: Date())

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Saisissez les informations"
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
            cell.configure(name: NSLocalizedString("firstname", comment: ""), value: attestation.firstname)
            return cell
        case (.info, FormSection.InfoContent.lastname.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("lastname", comment: ""), value: attestation.lastname)
            return cell
        case (.info, FormSection.InfoContent.birthdate.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("birthdate", comment: ""), value: attestation.birthdate)
            return cell
        case (.info, FormSection.InfoContent.birthplace.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("birthplace", comment: ""), value: attestation.birthplace)
            return cell
        case (.info, FormSection.InfoContent.address.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("address", comment: ""), value: attestation.address)
            return cell
        case (.info, FormSection.InfoContent.city.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("city", comment: ""), value: attestation.city)
            return cell
        case (.info, FormSection.InfoContent.zipCode.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("zipCode", comment: ""), value: attestation.zipCode)
            return cell

            // MOTIVES section
        case (.motives, FormSection.MotivesContent.pro.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.pro", comment: ""), selected: attestation.motives.contains(.pro))
            return cell
        case (.motives, FormSection.MotivesContent.shop.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.shop", comment: ""), selected: attestation.motives.contains(.shop))
            return cell
        case (.motives, FormSection.MotivesContent.health.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.health", comment: ""), selected: attestation.motives.contains(.health))
            return cell
        case (.motives, FormSection.MotivesContent.family.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.family", comment: ""), selected: attestation.motives.contains(.family))
            return cell
        case (.motives, FormSection.MotivesContent.brief.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.brief", comment: ""), selected: attestation.motives.contains(.brief))
            return cell
        case (.motives, FormSection.MotivesContent.administrative.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.administrative", comment: ""), selected: attestation.motives.contains(.administrative))
            return cell
        case (.motives, FormSection.MotivesContent.tig.rawValue):
            let cell = self.checkCell(tableView, indexPath: indexPath)
            cell.configure(content: NSLocalizedString("motive.tig", comment: ""), selected: attestation.motives.contains(.tig))
            return cell

            // DATE section
        case (.date, FormSection.DateContent.date.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("date", comment: ""), value: DateFormatter.date.string(from: attestation.date))
            return cell
        case (.date, FormSection.DateContent.time.rawValue):
            let cell = self.keyValueCell(tableView, indexPath: indexPath)
            cell.configure(name: NSLocalizedString("time", comment: ""), value: DateFormatter.time.string(from: attestation.date))
            return cell

        default:
            fatalError("Unknown row for indexPath")
        }
    }

    private func keyValueCell(_ tableView: UITableView, indexPath: IndexPath) -> KeyValueCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KeyValueCell.identifier, for: indexPath) as? KeyValueCell else {
            fatalError("Could not dequeue KeyValueCell")
        }
        return cell
    }

    private func checkCell(_ tableView: UITableView, indexPath: IndexPath) -> CheckCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckCell.identifier, for: indexPath) as? CheckCell else {
            fatalError("Could not dequeue CheckCell")
        }
        return cell
    }

    @IBAction func generateAttestation(_ sender: Any) {
        switch attestation.checkValidity() {
        case .success:
            print("generation du pdf")
            do {
                let document = try AttestationDocumentBuilder.buildDocument(from: attestation)
                let attestationViewController = AttestationViewController(document: document)
                self.navigationController?.pushViewController(attestationViewController, animated: true)
            } catch {
                self.showAlert(message: error.localizedDescription)
            }
        case .failure(let error):
            self.showAlert(message: error.localizedDescription)
        }
    }

}

