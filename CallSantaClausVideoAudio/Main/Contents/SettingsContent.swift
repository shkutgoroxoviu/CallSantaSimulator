//
//  SettingsContent.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

class SettingsContent: AUI.BaseListContentView {
    
    let notifyButton = AUI.Button()
    let titleLabel = AUI.Label()
    private(set) var rateAppItem = SettingsItemView(title: "Rate the app", image: .heart)
    private(set) var privacyItem = SettingsItemView(title: "Privacy policy", image: .privacy)
    private(set) var termsItem = SettingsItemView(title: "Terms of use", image: .terms)

    private var itemsStack = AUI.VerticalView()

    override func setup() {
        super.setup()
        backgroundColor = .santaRed
        
        withViews {
            AUI.ZStackView()
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(65))
                .withViews {
                    titleLabel
                        .with(font: .boldSystemFont(ofSize: 18))
                        .with(textColor: .white)
                        .with(title: "Settings")
                        .with(horizontalAligment: .center)
                        .with(verticalAligment: .center)
                    
                    notifyButton
                        .with(image: UIImage(systemName: "bell.fill"))
                        .with(tintColor: .white)
                        .with(estimatedWidth: 80)
                        .with(estimatedHeight: 30)
                        .with(horizontalAligment: .right)
                        .with(verticalAligment: .center)
                }
            
            itemsStack
                .with(horizontalAligment: .fill)
                .with(margin: .top(20).horizontal(16))
                .with(spacing: 20)
                .withViews {
                    rateAppItem
                    privacyItem
                    termsItem
                }
        }
    }
}

class SettingsItemView: AUI.HorizontalView {
    let titleLabel = AUI.Label()
    let image = AUI.ImageView()
    
    var onTap: (() -> Void)?
    
    init(title: String, image: UIImage) {
        titleLabel.text = title
        self.image.image = image
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        horizontalAligment = .fill
        verticalAligment = .center
        with(spacing: 8)
        with(cornerRadius: 20)
        with(padding: .vertical(12))
        with(backgroundColor: .santaCardRed)
        withViews {
            image
                .with(margin: .left(12))
            
            titleLabel
                .with(font: .systemFont(ofSize: 16))
                .with(textColor: .white)
                .with(horizontalAligment: .fill)
                .with(verticalAligment: .center)
                .with(margin: .right(12))
                .with(numberOfLines: 0)
        }
        
        addTapGestureRecognizer { [weak self] in
            self?.onTap?()
        }
    }
}
