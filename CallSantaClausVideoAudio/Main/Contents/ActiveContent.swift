//
//  ActiveContent.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

class ActiveContent: AUI.BaseListContentView {
    var currentType: PreviewContent.PreviewType = .audio {
        didSet {
            avatarView.isHidden = currentType == .audio ? false : true
            nameLabel.isHidden = currentType == .audio ? false : true
            backgroundImage.isHidden = currentType == .audio ? true : false
            countdownLabel.textColor = currentType == .audio ? .santaPink : .santaRed
        }
    }
    
    let avatarView = AUI.ImageView()
    let nameLabel = AUI.Label()
    let countdownLabel = AUI.Label()
    let statusLabel = AUI.Label()
    let recordingIndicator = UIView()
    let endButton = CallActionButton(icon: "phone.down.fill", title: "End", color: .santaLightRed)
    let backgroundImage = AUI.ImageView()
    let errorView = AUI.VerticalView().isHidden(true)
    let okButton = AUI.Button()
    
    override func setup() {
        super.setup()
        okButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            errorView.isHidden = true
        }
        backgroundImage.isHidden = true
        backgroundImage.with(image: .videoCallBackground)
        
        recordingIndicator.backgroundColor = .santaLightRed
        recordingIndicator.layer.cornerRadius = 6
        recordingIndicator.isHidden = true
        
        errorView
            .with(backgroundColor: .white)
            .with(cornerRadius: 15)
            .withViews {
                AUI.Label()
                    .with(font: .boldSystemFont(ofSize: 20))
                    .with(textColor: .santaRed)
                    .with(margin: .top(16))
                    .with(horizontalAligment: .center)
                    .with(title: "Bad connection")
                AUI.Label()
                    .with(margin: .top(8))
                    .with(horizontalAligment: .center)
                    .with(font: .systemFont(ofSize: 14))
                    .with(textColor: .santaPink)
                    .with(title: "Video may load slower")
                okButton
                    .with(cornerRadius: 25)
                    .with(backgroundColor: .santaYellow)
                    .with(text: "Ok")
                    .with(horizontalAligment: .center)
                    .with(textColor: .santaRed)
                    .with(font: .boldSystemFont(ofSize: 15))
                    .with(estimatedHeight: 50)
                    .with(estimatedWidth: 180)
                    .with(margin: .vertical(16))
            }
        addSubview(backgroundImage)
        addSubview(endButton)
        addSubview(recordingIndicator)
        withViews {
            AUI.VerticalView()
                .with(horizontalAligment: .center)
                .with(margin: .top(80))
                .withViews {
                    avatarView
                        .with(image: .photoSanta)
                        .with(horizontalAligment: .center)
                        .with(cornerRadius: 25)
                        .with(estimatedWidth: 50)
                        .with(estimatedHeight: 50)
                    nameLabel
                        .with(font: .boldSystemFont(ofSize: 24))
                        .with(textColor: .white)
                        .with(horizontalAligment: .center)
                        .with(title: "Santa Claus")
                        .with(margin: .top(16))
                    countdownLabel
                        .with(horizontalAligment: .center)
                        .with(textColor: .santaPink)
                        .with(font: .systemFont(ofSize: 17))
                        .with(margin: .top(4))
                    statusLabel
                        .with(horizontalAligment: .center)
                        .with(textColor: .white.withAlphaComponent(0.8))
                        .with(font: .systemFont(ofSize: 14))
                        .with(margin: .top(8))
                }
        }
        
        addSubview(errorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = CGSize(width: bounds.width - 32, height: 151)
        errorView.frame = CGRect(
            x: (bounds.width - size.width) / 2,
            y: (bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )

        backgroundImage.frame = bounds
        applySantaGradient()
        let bottomInset: CGFloat = 80

        let x = (bounds.width - 80) / 2
        let y = bounds.height - 80 - bottomInset

        endButton.frame = CGRect(
            x: x,
            y: y,
            width: 80,
            height: 80
        )
        
        recordingIndicator.frame = CGRect(
            x: 20,
            y: 60,
            width: 12,
            height: 12
        )
    }
    
    func updateCallTimer(_ seconds: Int) {
        let m = seconds / 60
        let s = seconds % 60
        countdownLabel.text = String(format: "%02d:%02d", m, s)
    }
    
    // MARK: - Recording Indicator
    
    func showRecordingIndicator() {
        recordingIndicator.isHidden = false
        startPulseAnimation()
    }
    
    func hideRecordingIndicator() {
        recordingIndicator.isHidden = true
        stopPulseAnimation()
    }
    
    private func startPulseAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.3
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        recordingIndicator.layer.add(animation, forKey: "pulse")
    }
    
    private func stopPulseAnimation() {
        recordingIndicator.layer.removeAnimation(forKey: "pulse")
    }
    
    // MARK: - Status Updates
    
    func updateStatus(_ status: String) {
        statusLabel.text = status
    }
}

