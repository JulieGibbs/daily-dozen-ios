//
//  Colors.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 29.01.2018.
//  Copyright © 2018 Nutritionfacts.org. All rights reserved.
//

import UIKit

/// `*Color` suffix indicates NutritionFacts app specific colors.
/// `*ColorNamed` suffix indicates colors named in NutritionFacts Press Media Kit
/// https://brandfolder.com/nutritionfacts/media-kit
extension UIColor {
    
    /// rgb(69,66,82) `#3C4252`
    static var blueDarkColor: UIColor {
        return UIColor(red: 60/255, green: 66/255, blue: 82/255, alpha: 1)
    }
    
    /// rgb(61,90,108) `#3D5A6C`
    static var blueFiordColor: UIColor {
        return UIColor(red: 61/255, green: 90/255, blue: 08/255, alpha: 1)
    }

    /// rgb(239,239,239) `#EFEFEF` Grayscale 93.7% Light
    static var grayGalleryColor: UIColor {
        return UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    }

    /// rgb(41,43,44) `#292B2C`
    static var grayJaguarColor: UIColor {
        return UIColor(red: 41/255, green: 43/255, blue: 44/255, alpha: 1)
    }
    
    /// rgb(213,213,213) `#D5D5D5` Grayscale 84% (83.52%)
    static var grayLightColor: UIColor {
        return UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
    }
    
    /// rgb(127,192,76) `#7FC04C`
    static var greenColor: UIColor {
        return UIColor(red: 127/255, green: 192/255, blue: 76/255, alpha: 1)
    }
    
    /// rgb(174,215,142) `#AED78E`
    static var greenLightColor: UIColor {
        return UIColor(red: 174/255, green: 215/255, blue: 142/255, alpha: 1)
    }
    
    /// rgb(108,174,117) `#6CAE75`
    static var greenIguanaColor: UIColor {
        return UIColor(red: 108/255, green: 174/255, blue: 117/255, alpha: 1)
    }
    
    /// rgb(255, 82, 82) `#FF5252`
    static var redCheckmarkColor: UIColor {
        return UIColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1)
    }
    
    /// rgb(198,108,108) `#C66C6C`
    static var redDarkColor: UIColor {
        return UIColor(red: 198/255, green: 108/255, blue: 108/255, alpha: 1)
    }

    /// rgb(228,87,46) `#E4572E`
    static var redFlamePeaColor: UIColor {
        return UIColor(red: 228/255, green: 87/255, blue: 46/255, alpha: 1)
    }

    /// rgb(235,193,64) `#EBC140`
    static var yellowColor: UIColor {
        return UIColor(red: 235/255, green: 193/255, blue: 64/255, alpha: 1)
    }
    
    /// rgb(253,212,69) `#FDD445`
    static var yellowSunglowColor: UIColor {
        return UIColor(red: 253/255, green: 212/255, blue: 69/255, alpha: 1)
    }

}
