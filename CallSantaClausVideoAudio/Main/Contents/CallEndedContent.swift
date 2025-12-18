//
//  CallEndedContent.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

class CallEndedContent: AUI.BaseListContentView {
    let avatarView = AUI.ImageView()
    let nameLabel = AUI.Label()
    let countdownLabel = AUI.Label()
    let makeNewButton = AUI.Button()
    let shareButton = AUI.Button()
    let closeButton = AUI.Button()
    
    override func setup() {
        super.setup()
        makeNewButton
            .with(cornerRadius: 25)
            .with(backgroundColor: .santaYellow)
            .with(text: "Make a new call")
            .with(textColor: .santaRed)
            .with(font: .boldSystemFont(ofSize: 15))
            .with(horizontalAligment: .fill)
            .with(estimatedHeight: 50)
            .with(margin: .horizontal(16).top(24))
        shareButton
            .with(cornerRadius: 25)
            .with(backgroundColor: .santaYellow)
            .with(text: "Share")
            .with(textColor: .santaRed)
            .with(font: .boldSystemFont(ofSize: 15))
            .with(horizontalAligment: .fill)
            .with(estimatedHeight: 50)
            .with(margin: .horizontal(16).top(24))
        addSubview(makeNewButton)
        addSubview(shareButton)
        
        withViews {
            closeButton
                .with(image: UIImage(systemName: "xmark"))
                .with(horizontalAligment: .right)
                .with(margin: .right(16).top(60))
                .with(tintColor: .white)
            nameLabel
                .with(font: .boldSystemFont(ofSize: 24))
                .with(textColor: .white)
                .with(horizontalAligment: .center)
                .with(title: "Call ended")
                .with(margin: .top(40))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applySantaGradient()
        
        let bottomInset: CGFloat = 180
        let buttonWidth = bounds.width - 32
        let buttonHeight: CGFloat = 50
        
        let x = (bounds.width - buttonWidth) / 2
        let y = bounds.height - bottomInset
        
        makeNewButton.frame = CGRect(
            x: x,
            y: y,
            width: buttonWidth,
            height: buttonHeight
        )
        
        shareButton.frame = CGRect(
            x: x,
            y: y + buttonHeight + 24,
            width: buttonWidth,
            height: buttonHeight
        )
    }
    
    func updateCallTimer(_ seconds: Int) {
        let m = seconds / 60
        let s = seconds % 60
        countdownLabel.text = String(format: "%02d:%02d", m, s)
    }
}
