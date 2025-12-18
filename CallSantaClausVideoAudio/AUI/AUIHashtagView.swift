// Created by AliveBe on 19.12.2023.

import Foundation
import UIKit

extension AUI {
    class HashtagView: AUI.HorizontalView {
        enum ImagePosition {
            case left
            case right
        }

        let label = AUI.Label()
        let imageView = AUI.ImageView()

        var imagePosition: ImagePosition = .left {
            didSet {
                updateViewOrder()
            }
        }

        var text: String? {
            get { return label.text }
            set { label.text = newValue }
        }

        var image: UIImage? {
            get { return imageView.image }
            set {
                imageView.image = newValue
                imageView.isHidden = newValue == nil
            }
        }

        @discardableResult func with(image: UIImage?) -> Self {
            self.image = image
            return self
        }

        @discardableResult func with(imageSize: CGSize) -> Self {
            self.imageView.with(estimatedSize: imageSize)
            return self
        }

        @discardableResult func with(text: String?) -> Self {
            self.text = text
            return self
        }
        
        @discardableResult func with(attributedText: NSAttributedString?) -> Self {
            self.label.attributedText = attributedText
            return self
        }

        @discardableResult func with(onlyText: String?) -> Self {
            self.isHidden = onlyText?.isEmpty ?? true
            self.text = onlyText
            return self
        }

        @discardableResult func with(textColor: UIColor?) -> Self {
            self.label.textColor = textColor
            return self
        }

        @discardableResult func with(font: UIFont?) -> Self {
            self.label.font = font
            return self
        }

        @discardableResult func with(backgorundColor: UIColor?) -> Self {
            self.backgroundColor = backgorundColor
            return self
        }

        @discardableResult func with(imagePosition: ImagePosition) -> Self {
            self.imagePosition = imagePosition
            return self
        }

        override func setup() {
            super.setup()
            imageView
                .with(verticalAligment: .center)
                .with(horizontalAligment: .center)
                .with(estimatedHeight: 16)
                .with(estimatedWidth: 16)
                .with(contentMode: .scaleAspectFit)

            label
                .with(verticalAligment: .center)
                .with(horizontalAligment: .center)

            self.with(cornerRadius: 4)
                .with(spacing: 4)
                .with(textColor: .black)
                .with(font: .systemFont(ofSize: 12))
                .with(padding: .all(5))
                .with(clipsToBounds: true)
                .with(backgroundColor: .lightGray)

            updateViewOrder()
        }

        private func updateViewOrder() {
            switch imagePosition {
            case .left:
                self.with(views: [imageView, label])
            case .right:
                self.with(views: [label, imageView])
            }
        }
    }
}

