//
//  OnboardingSubInfoContent.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

class OnboardingSubInfoContent: AUI.BaseListContentView {
    let skipButton = AUI.Button()
    let titleLabel = AUI.Label()
    let hdVideoCard = BenefitCard(
        title: "HD video",
        description: "HD video creates the illusion of a real call, which will look as realistic and vivid as possible.",
        icon: .photoOfSnowflake1
    )
    let unlimitedCallsCard = BenefitCard(
        title: "Removing the limit on\nthe number of calls",
        description: "The limit on the number of calls is lifted, so you will have the opportunity to organize a holiday for each child.",
        icon: .photoOfSnowflake2
    )
    let noAdsCard = BenefitCard(
        title: "No ads",
        description: "All screens will be cleared of ads, so there will be no surprises.",
        icon: .photoOfSnowflake3
    )
    let nextButton = AUI.Button()
    
    override func setup() {
        super.setup()
        backgroundColor = .santaRed
        
        withViews {
            skipButton
                .with(font: .systemFont(ofSize: 14))
                .with(textColor: .white)
                .with(text: "Skip")
                .with(horizontalAligment: .right)
                .with(margin: .right(16).top(56))
            
            titleLabel
                .with(horizontalAligment: .center)
                .with(margin: .horizontal(16).top(32))
                .with(font: .boldSystemFont(ofSize: 26))
                .with(textColor: .white)
                .with(numberOfLines: 0)
                .with(textAlignment: .center)
                .with(title: "Additional features\nwith a subscription")
            
            hdVideoCard
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(24))
            
            unlimitedCallsCard
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(12))
            
            noAdsCard
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(12))
            
            nextButton
                .with(cornerRadius: 25)
                .with(backgroundColor: .santaYellow)
                .with(text: "Next")
                .with(textColor: .santaRed)
                .with(font: .boldSystemFont(ofSize: 15))
                .with(horizontalAligment: .fill)
                .with(estimatedHeight: 50)
                .with(margin: .horizontal(16).top(32).bottom(40))
        }
    }
}

class BenefitCard: AUI.LeftRightView {
    let contentStack = AUI.VerticalView()
    let titleLabel = AUI.Label()
    let descriptionLabel = AUI.Label()
    let iconImageView = AUI.ImageView()
    
    init(title: String, description: String, icon: UIImage) {
        super.init(frame: .zero)
        titleLabel.with(title: title)
        descriptionLabel.with(title: description)
        iconImageView.with(image: icon)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        backgroundColor = .santaCardRed
        with(cornerRadius: 20)
        with(padding: .all(16))
        leftView = contentStack
            .with(horizontalAligment: .fill)
            .with(margin: .right(15))
            .withViews {
                titleLabel
                    .with(font: .boldSystemFont(ofSize: 15))
                    .with(textColor: .white)
                    .with(numberOfLines: 0)
                
                descriptionLabel
                    .with(font: .systemFont(ofSize: 13))
                    .with(textColor: .santaPink)
                    .with(numberOfLines: 0)
                    .with(margin: .top(4))
            }
        rightView = iconImageView
            .with(contentMode: .scaleAspectFit)
            .with(estimatedWidth: 50)
            .with(estimatedHeight: 50)
            .with(verticalAligment: .center)
    }
}
