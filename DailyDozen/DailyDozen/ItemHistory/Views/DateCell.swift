//
//  DateCell.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 21.11.2017.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit
import FSCalendar

class DateCell: FSCalendarCell {

    private weak var borderView: UIView!

    var borderColor = UIColor.white {
        didSet {
            borderView.backgroundColor = borderColor
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let borderView = UIView()
        contentView.insertSubview(borderView, at: 1)

        self.borderView = borderView
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let dx = (titleLabel.bounds.width - titleLabel.bounds.height) / 2
        borderView.frame = titleLabel.bounds.insetBy(dx: dx + 2, dy: 2)
        borderView.layer.cornerRadius = borderView.bounds.width / 2
    }
}
