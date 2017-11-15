//
//  VitaminsViewController.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 15.11.17.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit

class VitaminsBuilder {

    // MARK: - Nested
    struct Keys {
        static let xib = "VitaminsInfo"
    }

    // MARK: - Methods
    /// Instantiates and returns the VitaminsViewController.
    ///
    /// - Parameter storyboardName: A storyboard name.
    /// - Returns: The initial view controller in the storyboard.
    static func instantiateController() -> VitaminsViewController {
        let viewController = VitaminsViewController(nibName: Keys.xib, bundle: nil)
        viewController.modalPresentationStyle = .overCurrentContext
        return viewController
    }
}

class VitaminsViewController: UIViewController {

    weak var tapDelegate: Interactable?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.isOpaque = false
        view.backgroundColor = UIColor.clear
    }

    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
        tapDelegate?.viewDidTap()
    }
}
