//
//  MainTabController.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

enum Tab: CaseIterable {
    case callSanta
    case wishlist
    case settings

    var title: String {
        switch self {
        case .callSanta: return "Call Santa"
        case .wishlist: return "Wishlist"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .callSanta: return "phone.fill"
        case .wishlist: return "gift.fill"
        case .settings: return "gearshape.fill"
        }
    }

    var controller: UIViewController {
        switch self {
        case .callSanta:
            return MainController()

        case .wishlist:
            return WishlistController()

        case .settings:
            return SettingsController()
        }
    }
}

class MainTabBarController: UITabBarController {

    private let customTabBar = CustomTabBar()
    private var controllers: [UINavigationController] = []

    override var selectedIndex: Int {
        didSet {
            customTabBar.setSelected(index: selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideSystemTabBar()
        setupControllers()
        setupCustomTabBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutCustomTabBar()
    }

    private func hideSystemTabBar() {
        tabBar.isHidden = true
        tabBar.frame = .zero
    }

    func setupControllers() {
        controllers = Tab.allCases.map { tab in
            let controller = tab.controller
            let navController = UINavigationController(rootViewController: controller)
            navController.isNavigationBarHidden = true
            return navController
        }

        setViewControllers(controllers, animated: true)
    }

    private func setupCustomTabBar() {
        view.addSubview(customTabBar)

        customTabBar.onTabSelected = { [weak self] index in
            self?.selectedIndex = index
        }

        customTabBar.setSelected(index: 0)
    }

    private func layoutCustomTabBar() {
        let safeBottom = view.safeAreaInsets.bottom
        let height: CGFloat = 70
        let width: CGFloat = 300
        let x = (view.bounds.width - width) / 2
        let y = view.bounds.height - height - safeBottom

        customTabBar.frame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )

        customTabBar.layer.cornerRadius = height / 2
        customTabBar.layer.masksToBounds = true
    }
    
    public func showTabBar() {
        customTabBar.isHidden = false
    }
    
    public func hideTabBar() {
        customTabBar.isHidden = true
    }
}


class CustomTabBar: AUI.HorizontalView {
    var onTabSelected: ((Int) -> Void)?

    private let selectedColor = UIColor.santaYellow
    private let normalColor   = UIColor.santaPink

    private struct TabItem {
        let button: AUI.Button
        let label: AUI.Label
        let title: String
        let icon: String
    }

    private lazy var tabs: [TabItem] = [
        TabItem(button: AUI.Button(), label: AUI.Label(), title: "Call Santa", icon: "phone.fill"),
        TabItem(button: AUI.Button(), label: AUI.Label(), title: "Wishlist",   icon: "gift.fill"),
        TabItem(button: AUI.Button(), label: AUI.Label(), title: "Settings",   icon: "gearshape.fill")
    ]

    override func setup() {
        super.setup()

        backgroundColor = .clear
        horizontalAligment = .fill
        verticalAligment = .center
        spacing = 60
        padding = .vertical(8).horizontal(20)

        views = tabs.map { tab in
            tab.button.verticalAligment = .center
            tab.button.with(estimatedSize: .square(44))
            tab.button.with(image: UIImage(systemName: tab.icon))
            tab.button.tintColor = normalColor
            tab.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            tab.button.tag = tabs.firstIndex(where: { $0.button === tab.button }) ?? 0

            tab.label.text = tab.title
            tab.label.font = UIFont.systemFont(ofSize: 10)
            tab.label.textAlignment = .center
            tab.label.textColor = normalColor

            return AUI.VerticalView()
                .withViews({
                    tab.button
                    tab.label
                        .with(horizontalAligment: .center)
                })
        }

        setSelected(index: 0)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: 70)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let index = tabs.firstIndex(where: { $0.button === sender }) ?? 0
        onTabSelected?(index)
        setSelected(index: index)
    }

    func setSelected(index: Int) {
        for (i, tab) in tabs.enumerated() {
            let isSelected = (i == index)
            tab.button.isSelected = isSelected
            tab.button.tintColor = isSelected ? selectedColor : normalColor
            tab.label.textColor = isSelected ? selectedColor : normalColor
        }
    }
}



