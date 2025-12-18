//
//  CallEndedController.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

class CallEndedController: UIViewController {
    let contentView = CallEndedContent()
    
    var currentType: PreviewContent.PreviewType = .audio
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppCoordinator.shared.tabBarController?.hideTabBar()
        navigationController?.isNavigationBarHidden = true
        contentView.closeButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            navigationController?.popToRootViewController(animated: true)
        }
        contentView.makeNewButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            AppCoordinator.shared.showPreview(previewType: currentType)
        }
    }
}
