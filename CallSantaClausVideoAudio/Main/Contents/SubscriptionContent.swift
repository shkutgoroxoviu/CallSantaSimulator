//
//  SubscriptionController.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit
internal import Combine

class SubscriptionContent: AUI.BaseListContentView {
    let skipButton = AUI.Button()
    let titleLabel = AUI.Label()
    
    let monthlyOption = SubscriptionOptionCard(period: "1 month", price: "2$ per month")
    let yearlyOption = SubscriptionOptionCard(period: "1 year", price: "1.2$ per month")
    
    let trialLabel = AUI.Label()
    let proceedButton = AUI.Button()
    
    var selectedOption: SubscriptionOptionCard?
    
    var cancellables = Set<AnyCancellable>()
    
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
                .with(title: "Select the period")
            
            monthlyOption
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(40))
                .addTapGestureRecognizer { [weak self] in self?.selectOption(self?.monthlyOption) }
            
            yearlyOption
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(12))
                .addTapGestureRecognizer { [weak self] in self?.selectOption(self?.yearlyOption) }
            
            trialLabel
                .with(font: .systemFont(ofSize: 14))
                .with(textColor: .santaPink)
                .with(title: "+ 3-day trial period")
                .with(horizontalAligment: .left)
                .with(margin: .left(16).top(16))
            
            proceedButton
                .with(cornerRadius: 25)
                .with(backgroundColor: .santaYellow)
                .with(text: "Proceed to subscription")
                .with(textColor: .santaRed)
                .with(font: .boldSystemFont(ofSize: 15))
                .with(horizontalAligment: .fill)
                .with(estimatedHeight: 50)
                .with(margin: .horizontal(16).top(40).bottom(40))
        }
    }
    
    func selectOption(_ option: SubscriptionOptionCard?) {
        [monthlyOption, yearlyOption].forEach { $0.isSelected = false }
        
        selectedOption = option
        selectedOption?.isSelected = true
    }
}

class SubscriptionOptionCard: AUI.HorizontalView {
    let radioButton = AUI.ImageView()
    let contentStack = AUI.VerticalView()
    let periodLabel = AUI.Label()
    let priceLabel = AUI.Label()
    
    var isSelected: Bool = false {
        didSet { updateAppearance() }
    }
    
    init(period: String, price: String) {
        super.init(frame: .zero)
        periodLabel.with(title: period)
        priceLabel.with(title: price)
        setup()
    }
    
    @MainActor required init?(coder: NSCoder) { fatalError() }
    
    override func setup() {
        super.setup()
        with(cornerRadius: 16)
        with(padding: .all(16))
        with(spacing: 0)
        updateAppearance()
        
        withViews {
            radioButton
                .with(estimatedWidth: 24)
                .with(estimatedHeight: 24)
            
            contentStack
                .with(margin: .left(10))
                .withViews {
                    periodLabel.with(font: .boldSystemFont(ofSize: 16)).with(textColor: .white)
                    priceLabel.with(font: .systemFont(ofSize: 14)).with(textColor: .santaPink).with(margin: .top(4))
                }
        }
    }
    
    private func updateAppearance() {
        backgroundColor = .santaFillYellow.withAlphaComponent(0.3)
        layer.borderColor = UIColor.santaPink.cgColor
        layer.borderWidth = isSelected ? 2 : 0
        radioButton.with(image: isSelected ? .selectedButton : .unselected)
    }
}

