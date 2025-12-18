// Created by AliveBe on 06.12.2023.

import UIKit

extension AUI {
    class Label: UILabel, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var aui_borderColor: UIColor?
        
        var aui_text: String? {
            get { text }
            set {
                guard text != newValue else { return }
                text = newValue
            }
        }

        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        
        override var isHidden: Bool {
            get { super.isHidden || text == nil }
            set { super.isHidden = newValue}
        }
        
        @discardableResult func with(title: String?) -> Self {
            self.text = title
            return self
        }
        
        @discardableResult func with(attributedText: NSAttributedString?) -> Self {
            self.attributedText = attributedText
            return self
        }
        
        @discardableResult func with(height: CGFloat?) -> Self {
            self.estimatedHeight = height
            return self
        }
        
        @discardableResult func with(width: CGFloat?) -> Self {
            self.estimatedWidth = width
            return self
        }
        
        @discardableResult func with(horizontalAligment: AUI.HorizontalAligment) -> Self {
            self.horizontalAligment = horizontalAligment
            return self
        }
        
        @discardableResult func with(textColor: UIColor?) -> Self {
            self.textColor = textColor
            return self
        }
        
        @discardableResult func with(numberOfLines: Int) -> Self {
            self.numberOfLines = numberOfLines
            return self
        }
        
        @discardableResult func with(lineBreakMode: NSLineBreakMode) -> Self {
            self.lineBreakMode = lineBreakMode
            return self
        }
        
        @discardableResult func with(font: UIFont) -> Self {
            self.font = font
            return self
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size.inset(by: padding)).inset(by: padding.flipped)
            result.height = estimatedHeight ?? result.height
            result.width = estimatedWidth ?? result.width
            result.width += 2
            return result
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.transform = aui_packTransform
        }
        
        func setup() {
            textColor = .black
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
}

extension UILabel {
    func setTextWithTrailingImage(
        text: String,
        image: UIImage,
        imageSize: CGSize = CGSize(width: 14, height: 14),
        baselineOffset: CGFloat = 0
    ) {
        let fullString = NSMutableAttributedString(string: text + " ")

        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(
            x: 0,
            y: baselineOffset,
            width: imageSize.width,
            height: imageSize.height
        )

        let imageString = NSAttributedString(attachment: attachment)
        fullString.append(imageString)

        self.attributedText = fullString
    }
}


typealias Attributes = [NSAttributedString.Key: Any]

extension UILabel {
    convenience init(
        text: String? = "",
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 0
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @discardableResult
    func text(_ text: String?) -> Self {
        if attributedText != nil {
            guard let text = text else {
                self.attributedText = nil
                return self
            }
            self.attributedText = NSAttributedString(string: text)
        } else {
            self.text = text
        }
        return self
    }

    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> UILabel {
        self.attributedText = attributedText
        return self
    }

    @discardableResult
    func with(textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
}

