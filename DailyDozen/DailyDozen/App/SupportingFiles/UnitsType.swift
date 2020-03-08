//
//  UnitsType.swift
//  DailyDozen
//
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import Foundation

/// Units System Type: imperial or metric
/// 
/// Related Localization Files: 
/// * DozeDetailSizeUnitHeader
/// * Localizable.strings
/// * SettingsLayout
/// * TweakDetailActivityUnitHeader
enum UnitsType: String {

    case imperial
    case metric

    /// Returns localized name for the unit system currently in use.
    var title: String {
        switch self {
        case .imperial:
            return NSLocalizedString("UnitToggle.imperial", comment: "Units toggle button text: imperial measurement system")
        case .metric:
            return NSLocalizedString("UnitToggle.metric", comment: "Units toggle button text: metric measurement system")
        }
    }
    
    /// Returns toggled type for the current type.
    var toggledType: UnitsType {
        return self == .metric ? UnitsType.imperial : UnitsType.metric
    }
}
