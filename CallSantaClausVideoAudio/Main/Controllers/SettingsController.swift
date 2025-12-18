//
//  SettingsController.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit
internal import StoreKit

class SettingsController: UIViewController {
    let contentView = SettingsContent()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.rateAppItem.onTap = { [weak self] in
            self?.requestAppReview()
        }

        contentView.privacyItem.onTap = { [weak self] in
            self?.openPrivacy()
        }

        contentView.termsItem.onTap = { [weak self] in
            self?.openTerms()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppCoordinator.shared.tabBarController?.showTabBar()
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func openPrivacy() {
        let urlString = "https://docs.google.com/document/d/1eXwqgRES02ern8xOEto-d4wLLPYXY91pJ5WKyyAY0ss/edit?tab=t.0"

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTerms() {
        let urlString = "https://docs.google.com/document/d/1La6MTlmndplRlHvp2ONGfe7NGtGwuSwLB1dZTOoQdIk/edit?tab=t.0"

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}


