//
//  RoundedButton.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 28.11.2017.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable
    var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat = 2 {
        didSet {
            layer.shadowRadius = 2
        }
    }

    @IBInspectable
    var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable
    var shadowOpacity: Float = 1 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    override var isEnabled: Bool {
        didSet {
            layer.borderColor = isEnabled ? borderColor.cgColor : borderColor.withAlphaComponent(0.5).cgColor
        }
    }
}
