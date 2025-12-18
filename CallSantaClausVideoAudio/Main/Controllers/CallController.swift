//
//  CallController.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

class CallController: UIViewController {
    let contentView = CallContent()
    
    var currentType: PreviewContent.PreviewType = .audio
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppCoordinator.shared.tabBarController?.hideTabBar()
        navigationController?.isNavigationBarHidden = true
        contentView.declineButton.button.actionBlock = { [weak self] _ in
            guard let self else { return }
            navigationController?.popToRootViewController(animated: true)
        }
        
        contentView.acceptButton.button.actionBlock = { [weak self] _ in
            guard let self else { return }
            AppCoordinator.shared.showActiveCall(previewType: currentType)
        }
    }
}
