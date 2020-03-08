//
//  TweakDetailSection.swift
//  DailyDozen
//
//  Copyright © 2019 Nutritionfacts.org. All rights reserved.
//

import UIKit

enum TweakDetailSection: Int {
    
    private struct Nibs {
        static let activityHeaderNib = "TweakDetailActivityHeader"
        static let activityHeaderUnitNib = "TweakDetailActivityUnitHeader"
        static let descriptionHeaderNib = "TweakDetailDescriptionHeader"
    }
    
    case activity, description
    
//    var headerHeight: CGFloat {
//        switch self {
//        case .activity:
//            // :UNITS_VISIBILITY: Handle imperial|metric unit button visibility
//            let shouldShowTypeToggle = UserDefaults.standard.bool(forKey: SettingsKeys.unitsTypeToggleShowPref)
//            if shouldShowTypeToggle {
//                return 75 // Height: "Activity" + "Units"
//            } else {
//                return 50 // Height: "Activity" only
//            }
//        case .description:
//            return 50
//        }
//    }
    
    func headerHeight(itemTypeKey: String) -> CGFloat {
        let metricEqualsImperial = TweakTextsProvider.shared.isMetricEqualToImperial(itemTypeKey: itemTypeKey)
        switch self {
        case .activity:
            // :UNITS_VISIBILITY: Handle imperial|metric unit button visibility
            let shouldShowTypeToggle = UserDefaults.standard.bool(forKey: SettingsKeys.unitsTypeToggleShowPref)
            if shouldShowTypeToggle && !metricEqualsImperial {
                return 75 // Height: "Activity" + "Units"
            } else {
                return 50 // Height: "Activity" only
            }
        case .description:
            return 50
        }
    }

    var rowHeight: CGFloat {
        switch self {
        case .activity:
            return 75
        case .description:
            return 75
        }
    }
    
    func headerTweaksView(itemTypeKey: String) -> UIView? {
           switch self {
           case .activity:
               // :UNITS_VISIBILITY: Handle imperial|metric unit button visibility
               let shouldShowTypeToggle = UserDefaults.standard.bool(forKey: SettingsKeys.unitsTypeToggleShowPref)
               if shouldShowTypeToggle == false {
                   return Bundle.main
                       .loadNibNamed(Nibs.activityHeaderNib, owner: nil)?.first as? UIView
               }
               if TweakTextsProvider.shared.isMetricEqualToImperial(itemTypeKey: itemTypeKey) {
                   return Bundle.main
                       .loadNibNamed(Nibs.activityHeaderNib, owner: nil)?.first as? UIView
               }
               // Handle imperial vs. metric units
               if let unitsTypePrefStr = UserDefaults.standard.string(forKey: SettingsKeys.unitsTypePref),
                   let currentUnitsType = UnitsType(rawValue: unitsTypePrefStr),
                   let uiView: UIView = Bundle.main
                       .loadNibNamed(Nibs.activityHeaderUnitNib, owner: nil)?
                       .first as? UIView {
                   // Handle imperial vs. metric units
                   let buttons = uiView.subviews(ofType: UIButton.self)
                   for btn in buttons {
                       btn.setTitle(currentUnitsType.title, for: .normal)
                   }              
                   return uiView
               }
               return nil
           case .description:
               return Bundle.main
                   .loadNibNamed(Nibs.descriptionHeaderNib, owner: nil)?.first as? UIView
           }
       }
    
}
