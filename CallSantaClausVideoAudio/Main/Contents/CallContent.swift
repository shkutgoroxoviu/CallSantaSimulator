//
//  CallContent.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

// MARK: - Incoming Call Screen
class CallContent: AUI.BaseListContentView {
    let avatarView = AUI.ImageView()
    let nameLabel = AUI.Label()
    let buttonsPanel = AUI.HorizontalView()
    let declineButton = CallActionButton(icon: "phone.down.fill", title: "Decline", color: .santaLightRed)
    let acceptButton = CallActionButton(icon: "phone.fill", title: "Accept", color: .santaGreen)
    
    override func setup() {
        super.setup()
        addSubview(buttonsPanel)
        buttonsPanel
            .withViews {
                declineButton
                AUI.BaseView().with(estimatedWidth: 60)
                acceptButton
            }
        withViews {
            AUI.HorizontalView()
                .with(margin: .top(80).left(32))
                .withViews {
                    avatarView
                        .with(image: .photoSanta)
                        .with(cornerRadius: 25)
                        .with(estimatedWidth: 50)
                        .with(estimatedHeight: 50)
                    
                    nameLabel
                        .with(font: .boldSystemFont(ofSize: 24))
                        .with(textColor: .white)
                        .with(title: "Santa Claus")
                        .with(margin: .left(12))
                        .with(verticalAligment: .center)
                }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applySantaGradient()
        let panelWidth: CGFloat = 300
        let panelHeight: CGFloat = 120
        let bottomInset: CGFloat = 80

        let x = (bounds.width - panelWidth) / 2
        let y = bounds.height - panelHeight - bottomInset

        buttonsPanel.frame = CGRect(
            x: x,
            y: y,
            width: panelWidth,
            height: panelHeight
        )
    }
}

class CallActionButton: AUI.VerticalView {
    let button = AUI.Button()
    let titleLabel = AUI.Label()
    
    init(icon: String, title: String, color: UIColor) {
        super.init(frame: .zero)
        button.with(image: UIImage(systemName: icon))
        button.with(backgroundColor: color)
        titleLabel.with(title: title)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        withViews {
            button
                .with(tintColor: .white)
                .with(cornerRadius: 30)
                .with(estimatedWidth: 60)
                .with(estimatedHeight: 60)
                .with(horizontalAligment: .center)
            
            titleLabel
                .with(font: .systemFont(ofSize: 12))
                .with(textColor: .white)
                .with(horizontalAligment: .center)
                .with(margin: .top(8))
        }
    }
}
