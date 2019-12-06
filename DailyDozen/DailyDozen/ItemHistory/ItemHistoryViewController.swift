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
    private struct Strings {
        static let storyboard = "ItemHistory"
    }

    // MARK: - Methods
    /// Instantiates and returns the initial view controller for a storyboard.
    ///
    /// - Parameter heading: An item display heading.
    /// - Returns: The initial item histor view controller in the storyboard.
    static func instantiateController(heading: String, itemType: DataCountType) -> UIViewController {
        let storyboard = UIStoryboard(name: Strings.storyboard, bundle: nil)
        guard
            let viewController = storyboard
                .instantiateInitialViewController() as? ItemHistoryViewController
            else { fatalError("Did not instantiate `ItemHistory` controller") }
        viewController.title = heading
        viewController.itemType = itemType

        return viewController
    }
}

class ItemHistoryViewController: UIViewController {

    // MARK: - Nested
    private struct Strings {
        static let cell = "DateCell"
    }

    // MARK: - Properties
    private let realm = RealmProvider()
    fileprivate var itemType: DataCountType!

    // MARK: - Outlets
    @IBOutlet private weak var calendarView: FSCalendar!

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(DateCell.self, forCellReuseIdentifier: Strings.cell)
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
                .dequeueReusableCell(withIdentifier: Strings.cell, for: date, at: .current) as? DateCell
            else { fatalError("There should be a cell") }

        guard date < Date() else { return cell }

        let itemsDict = realm.getDailyTracker(date: date).itemsDict
        if let statesCount = itemsDict[itemType]?.count {
            cell.configure(for: statesCount, maximum: itemType.maxServings)
        } else {
            cell.configure(for: 0, maximum: itemType.maxServings)
        }
        
        return cell
    }
}

// MARK: - FSCalendarDelegate
extension ItemHistoryViewController: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard
            let viewController = navigationController?
                .viewControllers[1] as? ServingsPagerViewController
            else { return }

        viewController.updateDate(date)
        navigationController?.popViewController(animated: true)
    }
}
