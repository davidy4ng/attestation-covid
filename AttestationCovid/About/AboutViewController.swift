//
//  AboutViewController.swift
//  AttestationCovid
//
//  Created by David Yang on 12/04/2020.
//  Copyright © 2020 David Yang. All rights reserved.
//

import UIKit
import SafariServices

enum AboutSections: Int, CaseIterable {
    enum AppContent: Int, CaseIterable {
        case info
    }

    enum OfficialLinksContent: Int, CaseIterable {
        case webapp
    }

    enum SourceLinksContent: Int, CaseIterable {
        case github
        case fork
    }
    
    enum LicenceLinksContent: Int, CaseIterable {
        case licence
    }

    case app
    case officialLinks
    case sourceLinks
    case licenceLinks
}

final class AboutViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AboutCellIdentifier")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return AboutSections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch AboutSections(rawValue: section) {
        case .app?:
            return AboutSections.AppContent.allCases.count
        case .officialLinks?:
            return AboutSections.OfficialLinksContent.allCases.count
        case .sourceLinks?:
            return AboutSections.SourceLinksContent.allCases.count
        case .licenceLinks?:
            return AboutSections.LicenceLinksContent.allCases.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch AboutSections(rawValue: section) {
        case .officialLinks?:
            return NSLocalizedString("about.official.title", comment: "")
        case .sourceLinks?:
            return NSLocalizedString("about.sourceCode.title", comment: "")
        case .licenceLinks?:
            return NSLocalizedString("about.licence.title", comment: "")
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCellIdentifier", for: indexPath)

        let section = AboutSections(rawValue: indexPath.section)
        switch (section, indexPath.row) {
        case (.app, _):
            cell.textLabel?.text = NSLocalizedString("about.info", comment: "")
            cell.textLabel?.numberOfLines = 0
        case (.officialLinks, AboutSections.OfficialLinksContent.webapp.rawValue):
            cell.textLabel?.text = NSLocalizedString("about.web", comment: "")
            cell.textLabel?.numberOfLines = 1
        case (.sourceLinks, AboutSections.SourceLinksContent.github.rawValue):
            cell.textLabel?.text = NSLocalizedString("about.sourceCode.github", comment: "")
            cell.textLabel?.numberOfLines = 1
        case (.sourceLinks, AboutSections.SourceLinksContent.fork.rawValue):
            cell.textLabel?.text = NSLocalizedString("about.sourceCode.fork", comment: "")
            cell.textLabel?.numberOfLines = 1
        case (.licenceLinks, AboutSections.LicenceLinksContent.licence.rawValue):
            cell.textLabel?.text = NSLocalizedString("about.licence", comment: "")
            cell.textLabel?.numberOfLines = 1
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = AboutSections(rawValue: indexPath.section)

        switch (section, indexPath.row) {
        case (.officialLinks, AboutSections.OfficialLinksContent.webapp.rawValue):
            let url = URL(string: "https://media.interieur.gouv.fr/deplacement-covid-19/")!
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)

        case (.licenceLinks, AboutSections.LicenceLinksContent.licence.rawValue):
            let url = URL(string: "https://github.com/TheTrueTom/attestation-covid/blob/master/LICENSE")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }

        case (.sourceLinks, AboutSections.SourceLinksContent.github.rawValue):
            let url = URL(string: "https://github.com/TheTrueTom/attestation-covid/")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }

        case (.sourceLinks, AboutSections.SourceLinksContent.fork.rawValue):
            let url = URL(string: "https://github.com/davidy4ng/attestation-covid")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }

        default:
            break
        }
    }
}
