//
//  OnboardingSubInfoController.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

class OnboardingSubInfoController: UIViewController {
    let contentView = OnboardingSubInfoContent()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.nextButton.actionBlock = { _ in
            AppCoordinator.shared.showSubscription()
        }
    }
}
