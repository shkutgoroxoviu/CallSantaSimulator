//
//  MainContent.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

class MainContent: AUI.BaseListContentView {
    let headerImageView = AUI.ImageView()
    let titleLabel = AUI.Label()
    let subtitleLabel = AUI.Label()
    let segmentContainer = AUI.HorizontalView()
    let videoCallButton = AUI.Button()
    let voiceCallButton = AUI.Button()
    let startCallButton = AUI.Button()
    
    var sendCurrentPreviewType: ((PreviewContent.PreviewType) -> Void)?

    private let selectedColorBG = UIColor.santaYellow
    private let selectedColorText = UIColor.santaRed
    private let unselectedColorBG = UIColor.clear
    private let unselectedColorText = UIColor.santaPink
    
    override func setup() {
        super.setup()
        backgroundColor = .santaRed
        
        setupSegmentActions()

        withViews {
            AUI.ZStackView()
                .with(horizontalAligment: .fill)
                .withViews {
                    headerImageView
                        .with(image: .header)
                        .with(contentMode: .scaleAspectFill)
                        .with(horizontalAligment: .fill)
                    
                    titleLabel
                        .with(font: .boldSystemFont(ofSize: 18))
                        .with(textColor: .white)
                        .with(title: "Call Santa Claus")
                        .with(horizontalAligment: .center)
                        .with(margin: .top(56))
                    
                    subtitleLabel
                        .with(font: .boldSystemFont(ofSize: 24))
                        .with(textColor: .white)
                        .with(title: "Choose a suitable template")
                        .with(horizontalAligment: .center)
                        .with(margin: .top(100))
                }
            
            segmentContainer
                .with(backgroundColor: .santaFillYellow)
                .with(cornerRadius: 15)
                .with(horizontalAligment: .center)
                .with(margin: .top(20))
                .withViews {
                    videoCallButton
                        .with(text: "Video call")
                        .with(font: .systemFont(ofSize: 14))
                        .with(textColor: .white)
                        .with(backgroundColor: .clear)
                        .with(cornerRadius: 15)
                        .with(estimatedHeight: 40)
                        .with(padding: .horizontal(56).vertical(16))

                    voiceCallButton
                        .with(text: "Voice call")
                        .with(font: .systemFont(ofSize: 14))
                        .with(textColor: .santaRed)
                        .with(backgroundColor: .santaYellow)
                        .with(cornerRadius: 15)
                        .with(estimatedHeight: 40)
                        .with(padding: .horizontal(56).vertical(16))
                }
            
            TemplatesGridView()
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(20))
            
            startCallButton
                .with(cornerRadius: 25)
                .with(backgroundColor: .santaYellow)
                .with(text: "Start Santa call")
                .with(textColor: .santaRed)
                .with(font: .boldSystemFont(ofSize: 15))
                .with(horizontalAligment: .fill)
                .with(estimatedHeight: 50)
                .with(margin: .horizontal(16).top(24))
        }
    }

    // MARK: - Segment Logic

    private func setupSegmentActions() {
        videoCallButton.addTarget(self, action: #selector(videoTapped), for: .touchUpInside)
        voiceCallButton.addTarget(self, action: #selector(voiceTapped), for: .touchUpInside)
    }

    @objc private func videoTapped() {
        setSegment(selectedIndex: 0)
        sendCurrentPreviewType?(.video)
    }

    @objc private func voiceTapped() {
        setSegment(selectedIndex: 1)
        sendCurrentPreviewType?(.audio)
    }

    private func setSegment(selectedIndex: Int) {
        let selectedButton = (selectedIndex == 0) ? videoCallButton : voiceCallButton
        let unselectedButton = (selectedIndex == 0) ? voiceCallButton : videoCallButton

        selectedButton.with(backgroundColor: selectedColorBG)
        selectedButton.with(textColor: selectedColorText)

        unselectedButton.with(backgroundColor: unselectedColorBG)
        unselectedButton.with(textColor: unselectedColorText)
    }
}


class TemplateCard: AUI.ZStackView {
    let imageView = AUI.ImageView()
    let titleLabel = AUI.Label()
    
    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        imageView.with(image: image)
        titleLabel.with(title: title)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        with(cornerRadius: 16)
        clipsToBounds = true
        
        withViews {
            imageView
                .with(horizontalAligment: .fill)
                .with(verticalAligment: .fill)
            
            AUI.ZStackView()
                .with(backgroundColor: UIColor.black.withAlphaComponent(0.3))
                .with(horizontalAligment: .fill)
                .with(verticalAligment: .bottom)
                .with(estimatedHeight: 49)
                .withViews {
                    titleLabel
                        .with(font: .boldSystemFont(ofSize: 13))
                        .with(textColor: .white)
                        .with(numberOfLines: 2)
                        .with(textAlignment: .center)
                        .with(horizontalAligment: .center)
                        .with(verticalAligment: .center)
                }
        }
    }
    
    func setSelected(_ isSelected: Bool) {
        layer.borderWidth = isSelected ? 1 : 0
        layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
    }
}

class TemplatesGridView: AUI.VerticalView {

    private var cards: [TemplateCard] = []
    private var selectedIndex: Int? = nil

    override func setup() {
        super.setup()

        let card1 = TemplateCard(image: .classic, title: "Classic greeting card")
        let card2 = TemplateCard(image: .greetingNorth, title: "Greeting from North pole")
        let card3 = TemplateCard(image: .greetingSanta, title: "Greetings from Santa and animals")
        let card4 = TemplateCard(image: .thanks, title: "Thanks for the letter")
        cards = [card1, card2, card3, card4]

        for (index, card) in cards.enumerated() {
            card.tag = index
            card.addTapGestureRecognizer { [weak self] in
                self?.selectCard(at: card.tag)
            }
        }

        let row1 = AUI.HorizontalView()
        let row2 = AUI.HorizontalView()
        
        withViews {
            row1.with(horizontalAligment: .fill).withViews {
                card1.with(estimatedSize: .square(173))
                AUI.BaseView().with(estimatedWidth: 12)
                card2.with(estimatedSize: .square(173))
            }

            row2.with(horizontalAligment: .fill).with(margin: .top(12)).withViews {
                card3.with(estimatedSize: .square(173))
                AUI.BaseView().with(estimatedWidth: 12)
                card4.with(estimatedSize: .square(173))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.selectCard(at: 0)
        }
    }

    
    func selectCard(at index: Int) {
        for (i, card) in cards.enumerated() {
            card.setSelected(i == index)
        }
        selectedIndex = index
    }
}
