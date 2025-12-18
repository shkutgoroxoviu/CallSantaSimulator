//
//  WishlistController.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

class WishlistController: UIViewController {
    let contentView = WishlistContent()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addButton.actionBlock = { [weak self] _ in
            self?.showAddWishScreen()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppCoordinator.shared.tabBarController?.showTabBar()
    }
    
    // MARK: - Add Wish
    
    private func showAddWishScreen() {
        let addVC = AddWishController()
        addVC.onAdd = { [weak self] newItem in
            WishlistStorage.shared.add(item: newItem)
            self?.contentView.reloadItems()
        }
       present(addVC, animated: true)
    }
}
