//
//  ServingsViewController.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 18.10.17.
//  Copyright © 2017 Nutritionfacts.org. All rights reserved.
//

import UIKit
import RealmSwift

class ServingsViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate {

    // MARK: - Outlets
    @IBOutlet private weak var dataProvider: ServingsDataProvider!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let realm = try? Realm(configuration: RealmConfig.servings.configuration) else {
            fatalError("There should be a realm")
        }

        let doze = realm.objects(Doze.self).first ?? RealmConfig.initialDoze

        dataProvider.viewModel = DozeViewModel(doze: doze)

        tableView.dataSource = dataProvider
        tableView.delegate = self
    }

    // MARK: - Servings UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let servingsCell = cell as? ServingsCell else { return }
        servingsCell.stateCollection.delegate = self
        servingsCell.stateCollection.dataSource = dataProvider
        servingsCell.stateCollection.reloadData()
    }

    // MARK: - States UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var states = dataProvider.viewModel.itemStates(for: collectionView.tag)
        states[indexPath.row] = !states[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? StateCell else {
            fatalError("There should be a cell")
        }
        cell.configure(with: states[indexPath.row])
        let id = dataProvider.viewModel.itemID(for: collectionView.tag)
        if let realm = try? Realm(configuration: RealmConfig.servings.configuration) {
            do {
                try realm.write {
                    realm.create(Item.self, value: ["id": id, "states": states], update: true)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
