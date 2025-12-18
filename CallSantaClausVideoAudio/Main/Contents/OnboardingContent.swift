//
//  OnboardingContent.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

class OnboardingContent: AUI.BaseListContentView {
    let skipButton = AUI.Button()
    let logo = AUI.ImageView()
    let titleLabel = AUI.Label()
    let descriptionLabel = AUI.Label()
    let nextButton = AUI.Button()
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor(hexValue: 0xC52027)
        withViews {
            skipButton
                .with(font: .boldSystemFont(ofSize: 14))
                .with(textColor: .white)
                .with(text: "Skip")
                .with(horizontalAligment: .right)
                .with(margin: .right(16).top(56))
            logo
                .with(horizontalAligment: .center)
                .with(margin: .top(26).horizontal(16))
            titleLabel
                .with(horizontalAligment: .center)
                .with(margin: .horizontal(16).top(32))
                .with(font: .boldSystemFont(ofSize: 26))
                .with(textColor: .white)
                .with(numberOfLines: 0)
                .with(textAlignment: .center)
            descriptionLabel
                .with(horizontalAligment: .center)
                .with(margin: .horizontal(16).top(12))
                .with(textAlignment: .center)
                .with(font: .systemFont(ofSize: 15))
                .with(numberOfLines: 0)
                .with(textColor: UIColor(hexValue: 0xFFB4B8))
            nextButton
                .with(cornerRadius: 25)
                .with(backgroundColor: UIColor(hexValue: 0xFCD67C))
                .with(text: "Next")
                .with(textColor: UIColor(hexValue: 0xC52027))
                .with(font: .boldSystemFont(ofSize: 15))
                .with(horizontalAligment: .fill)
                .with(estimatedHeight: 50)
                .with(margin: .horizontal(16).top(32))
        }
    }
    
    func setPageInfo(info: OnboardingPage) {
        logo.with(image: info.image)
        titleLabel.with(title: info.title)
        descriptionLabel.with(title: info.description)
        setNeedsLayout()
        layoutIfNeeded()
    }
}
