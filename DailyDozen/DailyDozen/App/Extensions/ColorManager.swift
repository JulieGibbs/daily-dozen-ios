//
//  ColorManager.swift
//  DailyDozen
//
//  Copyright © 2021 Nutritionfacts.org. All rights reserved.
//

import UIKit

struct ColorManager {
    
    enum ColorManagerTheme {
        case primaryDark
        case primaryLight
        case primaryAuto
        case testPreview
    }

    static let style = ColorManager()

    let theme: ColorManagerTheme
    
    init() {
        if let identifier = Bundle.main.bundleIdentifier,
           identifier == "com.nutritionfacts.dailydozen.testml" {
            theme = .testPreview
        } else {
            // :NYI: preference based colorTheme
            theme = .primaryLight
        }
    }
    
    var chartLabel: UIColor {
        return UIColor.blueDarkColor
    }
    
    var chartWeigthAM: UIColor {
        return UIColor.yellowSunglowColor
    }
    
    var chartWeigthPM: UIColor {
        return UIColor.redFlamePeaColor
    }

    var checkboxBorderChecked: UIColor {
        return mainMedium
    }

    var checkboxBorderUnchecked: UIColor {
        return UIColor.grayLightColor
    }
    
    var mainMedium: UIColor {
        return UIColor(named: "BrandGreen") ??
            UIColor(red: 127/255, green: 192/255, blue: 76/255, alpha: 1)
    }

    var mainBackgroundGray: UIColor {
        return UIColor.lightGray
    }

    var mainForeground: UIColor {
        return mainMedium
    }
    
//
//    var mainLight: UIColor {
//
//    }
    
    var streakBronze: UIColor {
        return UIColor.streakBronzeColor
    }
    
    var streakGold: UIColor {
        return UIColor.streakGoldColor
    }

    var streakSilver: UIColor {
        return UIColor.streakSilverColor
    }
    
    var textWhite: UIColor {
        return UIColor.white
    }

    var textBlack: UIColor {
        return UIColor.black
    }

}
