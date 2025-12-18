//
//  SubscriptionController.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit
internal import StoreKit
internal import Combine

class SubscriptionController: UIViewController {
    let contentView = SubscriptionContent()
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        super.loadView()
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppCoordinator.shared.tabBarController?.hideTabBar()

        Task {
            await StoreKitSubscriptionManager.shared.fetchProducts()
            setupProductBindings()
        }

        contentView.skipButton.actionBlock = { _ in
            AppCoordinator.shared.finishOnboarding()
        }

        contentView.proceedButton.addTarget(self, action: #selector(proceedToSubscription), for: .touchUpInside)
    }

    private func setupProductBindings() {
        let manager = StoreKitSubscriptionManager.shared

        guard manager.products.count >= 2 else { return }

        let weeklyProduct = manager.products.first { $0.id.contains("week") }
        let yearlyProduct = manager.products.first { $0.id.contains("year") }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let weekly = weeklyProduct {
                self.contentView.monthlyOption.tag = weekly.id.hashValue
                self.contentView.monthlyOption.priceLabel.text = manager.getPriceString(for: weekly)
                self.contentView.monthlyOption.periodLabel.text = manager.getSubscriptionPeriod(for: weekly)
            }
            if let yearly = yearlyProduct {
                self.contentView.yearlyOption.tag = yearly.id.hashValue
                self.contentView.yearlyOption.priceLabel.text = manager.getPriceString(for: yearly)
                self.contentView.yearlyOption.periodLabel.text = manager.getSubscriptionPeriod(for: yearly)
            }
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
        }
    }

    @objc private func proceedToSubscription() {
        guard let selectedOption = contentView.selectedOption else {
            print("⚠️ Не выбрана подписка")
            return
        }

        let manager = StoreKitSubscriptionManager.shared
        guard let product = manager.products.first(where: { $0.id.hashValue == selectedOption.tag }) else {
            print("❌ Продукт для выбранного варианта не найден")
            return
        }

        Task {
            await manager.purchase(product) { success, error in
                DispatchQueue.main.async {
                    if success {
                        print("✅ Подписка активирована")
                        AppCoordinator.shared.finishOnboarding()
                    } else {
                        print("❌ Ошибка покупки: \(error ?? "неизвестно")")
                    }
                }
            }
        }
    }
}
