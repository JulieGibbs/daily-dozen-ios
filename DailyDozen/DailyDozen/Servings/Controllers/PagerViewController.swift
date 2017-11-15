//
//  PagerViewController.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 18.10.17.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit

// MARK: - Builder
class PagerBuilder {

    // MARK: - Nested
    struct Keys {
        static let storyboard = "Pager"
    }

    // MARK: - Methods
    /// Instantiates and returns the initial view controller for a storyboard.
    ///
    /// - Parameter storyboardName: A storyboard name.
    /// - Returns: The initial view controller in the storyboard.
    static func instantiateController() -> UIViewController {
        let storyboard = UIStoryboard(name: Keys.storyboard, bundle: nil)
        guard
            let viewController = storyboard
                .instantiateInitialViewController()
            else { fatalError("There should be a controller") }

        return viewController
    }
}

// MARK: - Controller
class PagerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var dateButton: UIButton! {
        didSet {
            dateButton.layer.borderWidth = 1
            dateButton.layer.borderColor = dateButton.titleColor(for: .normal)?.cgColor
            dateButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet private weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.maximumDate = Date()
        }
    }

    // MARK: - Propeties
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale.current
        return formatter
    }()

    // MARK: - Actions
    @IBAction private func dateButtonPressed(_ sender: UIButton) {
        datePicker.isHidden = false
        dateButton.isHidden = true
    }

    @IBAction private func dateChanged(_ sender: UIDatePicker) {
        dateButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
        dateButton.isHidden = false
        datePicker.isHidden = true

        guard let viewController = childViewControllers.first as? ServingsViewController else { return }
        viewController.setViewModel(for: datePicker.date)
    }

    @IBAction func viewSwipped(_ sender: UISwipeGestureRecognizer) {
        let timeInterval = sender
            .direction == .left ? TimeInterval(floatLiteral: -86400)
            : TimeInterval(floatLiteral: 86400)
        let date = datePicker.date.addingTimeInterval(timeInterval)
        guard dateFormatter.string(from: date) <= dateFormatter.string(from: Date()) else {
            return
        }
        datePicker.setDate(date, animated: false)
        dateButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)

        guard let viewController = childViewControllers.first as? ServingsViewController else { return }
        viewController.setViewModel(for: datePicker.date)
    }
}
