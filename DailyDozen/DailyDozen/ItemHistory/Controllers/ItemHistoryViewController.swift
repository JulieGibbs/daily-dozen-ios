//
//  ItemHistoryViewController.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 16.11.17.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit
import FSCalendar

class ItemHistoryBuilder {

    // MARK: - Nested
    private struct Keys {
        static let storyboard = "ItemHistory"
    }

    // MARK: - Methods
    /// Instantiates and returns the initial view controller for a storyboard.
    ///
    /// - Parameter title: An item name.
    /// - Returns: The initial view controller in the storyboard.
    static func instantiateController(with title: String, itemId: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: Keys.storyboard, bundle: nil)
        guard
            let viewController = storyboard
                .instantiateInitialViewController() as? ItemHistoryViewController
            else { fatalError("There should be a controller") }
        viewController.title = title
        viewController.itemId = itemId

        return viewController
    }
}

class ItemHistoryViewController: UIViewController {

    private struct Keys {
        static let cell = "DateCell"
    }

    private let realm = RealmProvider()
    var itemId = 0

    @IBOutlet weak var calendarView: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.register(DateCell.self, forCellReuseIdentifier: Keys.cell)
    }
}

// MARK: - FSCalendarDataSource
extension ItemHistoryViewController: FSCalendarDataSource {

    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard
            let cell = calendar
                .dequeueReusableCell(withIdentifier: Keys.cell, for: date, at: .current) as? DateCell
            else { fatalError("There should be a cell") }

        let states = realm.getDoze(for: date).items[itemId].states
        let selectedStates = states.filter { $0 }

        cell.configure(for: selectedStates.count, maximum: states.count)

        return cell
    }
}

// MARK: - FSCalendarDelegate
extension ItemHistoryViewController: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard
            let viewController = navigationController?
                .viewControllers[1] as? PagerViewController
            else { return }

        viewController.updateDate(date)
        navigationController?.popViewController(animated: true)
    }
}
