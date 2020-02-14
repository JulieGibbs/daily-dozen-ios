//
//  TweakDetailViewModel.swift
//  DailyDozen
//
//  Copyright © 2020 Nutritionfacts.org. All rights reserved.
//

import UIKit

struct TweakDetailViewModel {
    
    // MARK: - Properties
    private let info: TweakDetailsInfo.Item
    private let itemTypeKey: String
    
    var unitsType: UnitsType
    
    /// Returns the main topic url.
    var topicURL: URL {
        return LinksService.shared.link(forTopic: info.topic)
    }
    
    /// Returns the number of items in the metric sizes.
    var activityCount: Int {
        return 1
    }
    
    /// Returns the number of items in the types.
    var descriptinParagraphCount: Int {
        return info.description.count
    }
    /// Returns the item name.
    var itemTitle: String {
        return info.heading
    }
    
    /// Returns an image of the item.
    var detailsImage: UIImage? {
        return UIImage(named: "detail_\(itemTypeKey)")
    }
    
    // MARK: - Inits
    init(itemTypeKey: String, info: TweakDetailsInfo.Item) {
        self.itemTypeKey = itemTypeKey
        self.info = info
        
        if let unitsTypePrefStr = UserDefaults.standard.string(forKey: SettingsKeys.unitsTypePref),
            let unitsTypePref = UnitsType(rawValue: unitsTypePrefStr) {
            self.unitsType = unitsTypePref
        } else {
            // :NYI:ToBeLocalized: set initial default based on device language
            self.unitsType = UnitsType.imperial
            UserDefaults.standard.set(self.unitsType.rawValue, forKey: SettingsKeys.unitsTypePref)
        }
    }
    
    // MARK: - Methods
    /// Returns a size description for the current index.
    ///
    /// - Parameter index: The current index.
    /// - Returns: A description string.
    func activity(index: Int) -> String {
        if unitsType == .metric {
            return info.activity.metric
        } else {
            return info.activity.imperial
        }
    }
    
    /// Returns a tuple of the type name and type link state for the current index.
    ///
    /// - Parameter index: The current index.
    /// - Returns: A tuple of the type name and type link.
    func descriptionParagraph(index: Int) -> String {
        return info.description[index]
    }

}
