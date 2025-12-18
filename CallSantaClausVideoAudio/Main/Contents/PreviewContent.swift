//
//  CallSantaContent.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

// MARK: - Preview Screen
class PreviewContent: AUI.BaseListContentView {
    enum PreviewType {
        case video
        case audio
    }
    
    enum ErrorType {
        case noWifi
        case errorLoading
    }
    
    var currentErrorType: ErrorType = .noWifi {
        didSet {
            validateView.isHidden = true
            errorView.isHidden = false
            if currentErrorType == .noWifi {
                changeErrorElements(title: "No internet connection", image: .noWifi, subtitle: "Please check your internet connection")
                contactSupportButton.isHidden = true
            } else {
                changeErrorElements(title: "Error loading video", image: .error, subtitle: "Check your internet connection or contact\ncustomer support")
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var currentType: PreviewType = .audio {
        didSet {
            titleLabel.text = currentType == .audio ? "Audio preview" : "Video preview"
            backgroundImage.isHidden = currentType == .audio ? true : false
            waveformView.alpha = currentType == .audio ? 1 : 0
            countdownLabel.textColor = currentType == .audio ? .santaPink : .santaRed
        }
    }
    
    let backButton = AUI.Button()
    let titleLabel = AUI.Label()
    let waveformView = AUI.ImageView()
    let startCallButton = AUI.Button()
    let countdownLabel = AUI.Label()
    let backgroundImage = AUI.ImageView()
    let errorView = AUI.VerticalView().isHidden(true)
    let errorImage = AUI.ImageView()
    let errorTitle = AUI.Label()
    let errorSubtitle = AUI.Label()
    let validateView = AUI.VerticalView()
    let tryAgainButton = AUI.Button()
    let contactSupportButton = AUI.Button()
    
    override func setup() {
        super.setup()
        backgroundColor = .santaRed
        backgroundImage.isHidden = true
        backgroundImage.with(image: .videoCallBackground)
        addSubview(backgroundImage)
        contactSupportButton.isDisableOnTap = true
        withViews {
            AUI.HorizontalView()
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(70))
                .withViews {
                    backButton
                        .with(image: UIImage(systemName: "arrow.left"))
                        .with(tintColor: .white)
                    
                    titleLabel
                        .with(font: .boldSystemFont(ofSize: 17))
                        .with(textColor: .white)
                        .with(title: "Audio preview")
                        .with(horizontalAligment: .center)
                    
                    AUI.BaseView().with(estimatedWidth: 24)
                }
            errorView
                .with(margin: .top(200).horizontal(16))
                .with(spacing: 8)
                .with(horizontalAligment: .fill)
                .withViews {
                    errorImage
                        .with(image: .error)
                        .with(horizontalAligment: .center)
                    errorTitle
                        .with(font: .boldSystemFont(ofSize: 17))
                        .with(textColor: .white)
                        .with(title: "No internet connection")
                        .with(horizontalAligment: .center)
                    errorSubtitle
                        .with(font: .systemFont(ofSize: 15))
                        .with(textColor: .santaPink)
                        .with(textAlignment: .center)
                        .with(title: "Please check your internet connection")
                        .with(horizontalAligment: .center)
                        .with(numberOfLines: 0)
                    AUI.HorizontalView()
                        .with(spacing: 12)
                        .with(margin: .top(10))
                        .with(horizontalAligment: .center)
                        .withViews {
                            tryAgainButton
                                .with(cornerRadius: 25)
                                .with(backgroundColor: .santaYellow)
                                .with(text: "Try again")
                                .with(textColor: .santaRed)
                                .with(font: .boldSystemFont(ofSize: 15))
                                .with(estimatedHeight: 50)
                                .with(estimatedWidth: 180)
                            contactSupportButton
                                .with(cornerRadius: 25)
                                .with(backgroundColor: .santaFillYellow)
                                .with(text: "Contact support")
                                .with(textColor: .santaPink)
                                .with(font: .boldSystemFont(ofSize: 15))
                                .with(estimatedHeight: 50)
                                .with(estimatedWidth: 180)
                        }
                }
            validateView
                .with(horizontalAligment: .fill)
                .withViews {
                    waveformView
                        .with(image: .audioIcon)
                        .with(contentMode: .scaleAspectFit)
                        .with(horizontalAligment: .center)
                        .with(margin: .horizontal(16).vertical(240))
                    
                    startCallButton
                        .with(cornerRadius: 25)
                        .with(backgroundColor: .santaYellow)
                        .with(text: "Start call")
                        .with(textColor: .santaRed)
                        .with(font: .boldSystemFont(ofSize: 15))
                        .with(horizontalAligment: .fill)
                        .with(estimatedHeight: 50)
                        .with(margin: .horizontal(16).top(40))
                    
                    countdownLabel
                        .with(font: .systemFont(ofSize: 14))
                        .with(textColor: .white)
                        .with(title: "The call will begin in 00:05")
                        .with(horizontalAligment: .center)
                        .with(margin: .top(16).bottom(40))
                }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImage.frame = bounds
    }
    
    func changeErrorElements(title: String, image: UIImage, subtitle: String) {
        errorImage
            .with(image: image)
        errorTitle
            .with(title: title)
        errorSubtitle
            .with(title: subtitle)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func showValidateView() {
        validateView.isHidden = false
        errorView.isHidden = true
        setNeedsLayout()
        layoutIfNeeded()
    }

    func updateCountdown(_ seconds: Int) {
        let sec = max(0, seconds)
        let formatted = String(format: "%02d", sec)
        countdownLabel.text = "The call will begin in 00:\(formatted)"
    }
}
