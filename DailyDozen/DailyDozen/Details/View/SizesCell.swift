//
//  SizesCell.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 10.11.17.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit

class SizesCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String) {
        titleLabel.text = title
    }
}
