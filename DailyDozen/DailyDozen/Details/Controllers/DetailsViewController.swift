//
//  DetailsViewController.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 31.10.17.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit

// MARK: - Builder
class DetailsBuilder {
    
    // MARK: - Nested
    struct Strings {
        static let storyboard = "Details"
        static let storyboardNoImage = "DetailsNoImage"
    }
    
    // MARK: - Methods
    /// Instantiates and returns the initial view controller for a storyboard.
    ///
    /// - Parameter itemTypeKey: An item type key string.
    /// - Returns: The initial view controller in the storyboard.
    static func instantiateController(itemTypeKey: String) -> DetailsViewController {
        
        let storyboard = itemTypeKey.prefix(4) == "doze" ?
            UIStoryboard(name: Strings.storyboard, bundle: nil) :
            UIStoryboard(name: Strings.storyboardNoImage, bundle: nil)
        guard
            let viewController = storyboard
                .instantiateInitialViewController() as? DetailsViewController
            else { fatalError("Did not instantiate `Details` controller") }
        
        viewController.setViewModel(itemTypeKey: itemTypeKey)
        
        return viewController
    }
}

// MARK: - Controller
class DetailsViewController: UIViewController {
    
    // MARK: - Nested
    private struct Keys {
        static let videos = "VIDEOS"
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dataProvider: DetailsDataProvider!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailsImageView: UIImageView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataProvider
        tableView.delegate = self
        
        if let dataCountType = dataProvider.dataCountType {
            if dataCountType.typeKey.prefix(4) == "doze" {
                // DetailsViewController VIDEOS
                navigationItem.rightBarButtonItem = UIBarButtonItem(
                    title: Keys.videos,
                    style: .done,
                    target: self,
                    action: #selector(barItemPressed)
                )
            }
        }
        
        detailsImageView.image = dataProvider.viewModel.detailsImage
        titleLabel.text = dataProvider.viewModel.itemTitle
    }
    
    // MARK: - Methods
    /// Sets a view model for the current item.
    ///
    /// - Parameter item: The current item name.
    func setViewModel(itemTypeKey: String) {
        dataProvider.viewModel = TextsProvider.shared.getDetails(itemTypeKey: itemTypeKey)
        dataProvider.dataCountType = DataCountType(typeKey: itemTypeKey)
    }
    
    /// Opens the main topic url in the browser.
    @objc private func barItemPressed() {
        UIApplication.shared
            .open(dataProvider.viewModel.topicURL,
                  options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                  completionHandler: nil)
    }
    
    // MARK: - Actions
    /// Updates the tableView for the current unit type.
    ///
    /// - Parameter sender: The button.
    @IBAction private func unitsChanged(_ sender: UIButton) {
        let sectionIndex = DetailsSection.sizes.rawValue
        guard
            let unitsTypePrefStr = UserDefaults.standard.string(forKey: SettingsKeys.unitsTypePref),
            let currentUnitsType = UnitsType(rawValue: unitsTypePrefStr),
            let indexPaths = tableView.indexPathsForRows(in: tableView.rect(forSection: sectionIndex))
            else { return }
        
        let newUnitsType: UnitsType = currentUnitsType.toggledType
        UserDefaults.standard.set(newUnitsType.rawValue, forKey: SettingsKeys.unitsTypePref)
        let title = newUnitsType.title
        sender.setTitle(title, for: .normal)
        dataProvider.viewModel.unitsType = newUnitsType
        tableView.reloadRows(at: indexPaths, with: .fade)
    }
    
    /// Opens the type topic url in the browser.
    ///
    /// - Parameter sender: The button.
    @IBAction private func linkButtonPressed(_ sender: UIButton) {
        guard let url = dataProvider.viewModel.typeTopicURL(index: sender.tag) else { return }
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

// MARK: - UITableViewDelegate
extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = DetailsSection(rawValue: indexPath.section) else {
            fatalError("There should be a section type")
        }
        
        if sectionType == .types &&
            dataProvider.dataCountType.isTweak {
            let x = CGFloat(0.0)
            let y = CGFloat(0.0)
            let height = CGFloat(0.0)
            let width = tableView.contentSize.width * 0.70
            let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
            label.numberOfLines = 0 // allows label to have as many lines as needed
            
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            let font = UIFont(name: "Helvetica Neue", size: 14.0)
            label.font = font
            
            let typeKey = dataProvider.dataCountType.typeKey
            let typeData = TextsProvider.shared
                .getDetails(itemTypeKey: typeKey)
                .typeData(index: indexPath.row)
            
            label.text  = "\(typeData.name)\n margin"
            label.sizeToFit()
            //print("indexPath: \(indexPath)")
            //print("\(label.fs_width) w x \(label.fs_height) h")
            return label.fs_height
        }
        
        return sectionType.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = DetailsSection(rawValue: section) else {
            fatalError("There should be a section type")
        }
        return sectionType.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = DetailsSection(rawValue: section) else {
            fatalError("There should be a section type")
        }
        if let dataCountType = dataProvider.dataCountType {
            if dataCountType.typeKey.prefix(5) == "tweak" {
                return sectionType.headerTweaksView
            }
        }
        return sectionType.headerView
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
