//
//  ViewController.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

class MainController: UIViewController {
    let contentView = MainContent()
    
    var currentPreviewType: PreviewContent.PreviewType = .audio
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        contentView.sendCurrentPreviewType = { [weak self] type in
            guard let self else { return }
            self.currentPreviewType = type
        }
        contentView.startCallButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            AppCoordinator.shared.showPreview(previewType: currentPreviewType)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppCoordinator.shared.tabBarController?.showTabBar()
    }
}

