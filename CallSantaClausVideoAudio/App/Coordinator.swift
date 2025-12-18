//
//  Coordinator.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    var tabBarController: MainTabBarController? { get set }
    func start(window: UIWindow)
}

// MARK: - Main App Coordinator
final class AppCoordinator: Coordinator {
    static let shared = AppCoordinator()
    
    var tabBarController: MainTabBarController?
    private var window: UIWindow?

    func start(window: UIWindow) {
        self.window = window
        
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if isFirstLaunch {
            showOnboardingFlow()
        } else {
            showMainFlow()
        }
    }

    // MARK: - Onboarding
    func showOnboardingFlow() {
        guard let window = window else { return }
        let onboardingVC = OnboardingController()
        let navController = UINavigationController(rootViewController: onboardingVC)
        navController.isNavigationBarHidden = true
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
        showMainFlow()
    }

    // MARK: - Main flow
    func showMainFlow() {
        guard let window = window else { return }
        let tabBar = MainTabBarController()
        tabBar.setupControllers() 
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        self.tabBarController = tabBar
    }

    // MARK: - Навигация внутри текущей вкладки
    private func currentNavigationController() -> UINavigationController? {
        return tabBarController?.selectedViewController as? UINavigationController
    }

    func showPreview(previewType: PreviewContent.PreviewType) {
        let previewVC = PreviewController()
        previewVC.contentView.currentType = previewType
        currentNavigationController()?.pushViewController(previewVC, animated: true)
    }
    
    func showSubscription() {
        let subVC = SubscriptionController()
        
        if let nav = window?.rootViewController as? UINavigationController {
            nav.pushViewController(subVC, animated: true)
        } else if let nav = currentNavigationController() {
            nav.pushViewController(subVC, animated: true)
        }
    }
    
    func showOnboardingBenefits() {
        let onboardingVC = OnboardingSubInfoController()
        
        if let nav = window?.rootViewController as? UINavigationController {
            nav.pushViewController(onboardingVC, animated: true)
        } else if let nav = currentNavigationController() {
            nav.pushViewController(onboardingVC, animated: true)
        }
    }

    func showCall(previewType: PreviewContent.PreviewType) {
        let callVC = CallController()
        callVC.currentType = previewType
        currentNavigationController()?.pushViewController(callVC, animated: true)
    }

    func showActiveCall(previewType: PreviewContent.PreviewType) {
        let activeCallVC = ActiveCallController()
        activeCallVC.currentType = previewType
        currentNavigationController()?.pushViewController(activeCallVC, animated: true)
    }

    func showCallEnded(previewType: PreviewContent.PreviewType) {
        let callEndedVC = CallEndedController()
        callEndedVC.currentType = previewType
        currentNavigationController()?.pushViewController(callEndedVC, animated: true)
    }
}
