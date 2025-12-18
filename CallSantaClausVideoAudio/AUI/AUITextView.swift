// Created by AliveBe on 16.04.2024.

import UIKit

extension AUI {
    final class SecureTextView: TextView, UITextViewDelegate {
        var isSecure: Bool = true {
            didSet { updateDisplayedText() }
        }

        private(set) var realText: String = ""

        override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            delegate = self
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            delegate = self
        }

        override var text: String! {
            get { isSecure ? realText : super.text }
            set {
                realText = newValue ?? ""
                updateDisplayedText()
            }
        }

        private func updateDisplayedText() {
            super.text =
                isSecure
                ? String(repeating: "•", count: realText.count) : realText
            placeholderLabel.isHidden = !realText.isEmpty
        }

        func textViewDidChange(_ textView: UITextView) {
            guard let displayed = super.text else { return }
            if displayed.count > realText.count {
                let added = displayed.suffix(displayed.count - realText.count)
                realText.append(contentsOf: added)
            } else {
                realText = String(realText.prefix(displayed.count))
            }
            updateDisplayedText()
            textChanged?(realText)
        }
    }

    class AUITextField: UITextField, AUIView, UITextFieldDelegate {
        private let notificationCenter = NotificationCenter.default

        var packHidden: Bool = false
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var margin: UIEdgeInsets = .zero
        var aui_borderColor: UIColor?

        var padding: UIEdgeInsets = .zero {
            didSet { setNeedsLayout() }
        }

        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil

        let placeholderLabel: AUI.Label = AUI.Label()

        var textChanged: ((String?) -> Void)?
        var beginEditing: (() -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        private func setup() {
            delegate = self
            borderStyle = .none
            backgroundColor = .clear
            placeholderLabel.margin = .zero
            placeholderLabel.verticalAligment = .center
            addSubview(placeholderLabel)

            notificationCenter.addObserver(self,
                                           selector: #selector(textDidChange),
                                           name: UITextField.textDidChangeNotification,
                                           object: self)
            notificationCenter.addObserver(self,
                                           selector: #selector(beginEdit),
                                           name: UITextField.textDidBeginEditingNotification,
                                           object: self)
        }

        deinit {
            notificationCenter.removeObserver(self)
        }

        @discardableResult func with(estimatedHeight: CGFloat) -> Self {
            self.estimatedHeight = estimatedHeight
            return self
        }

        @discardableResult func with(estimatedWidth: CGFloat) -> Self {
            self.estimatedWidth = estimatedWidth
            return self
        }

        @discardableResult func with(estimatedSize: CGSize) -> Self {
            self.estimatedWidth = estimatedSize.width
            self.estimatedHeight = estimatedSize.height
            return self
        }

        @discardableResult func with(textColor: UIColor) -> Self {
            self.textColor = textColor
            return self
        }

        @discardableResult func with(font: UIFont) -> Self {
            self.font = font
            return self
        }

        @discardableResult func with(text: String) -> Self {
            self.text = text
            return self
        }

        @discardableResult func with(placeHolderString: String?) -> Self {
            self.placeholderLabel.text = placeHolderString
            return self
        }

        @discardableResult func with(padding: UIEdgeInsets) -> Self {
            self.padding = padding
            return self
        }

        @objc private func textDidChange() {
            placeholderLabel.isHidden = !(text?.isEmpty ?? true)
            textChanged?(text)
        }

        @objc private func beginEdit() {
            beginEditing?()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            placeholderLabel.frame = placeholderLabel.aui_frame(inBounds: bounds.inset(by: padding))
            layer.transform = aui_packTransform
        }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size.inset(by: padding))
            if let h = estimatedHeight { result.height = h }
            if let w = estimatedWidth { result.width = w }
            return result.maxSize(with: placeholderLabel
                .sizeThatFits(size.inset(by: padding))
                .inset(by: placeholderLabel.margin.flipped))
        }

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: padding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: padding)
        }

        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: padding)
        }

        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            placeholderLabel.isHidden = !(text?.isEmpty ?? true)
            return true
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
    
    class TextView: UITextView, AUIView {
        private let notificationCenter = NotificationCenter.default

        var packHidden: Bool = false
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero { didSet { contentInset = padding } }
        var aui_borderColor: UIColor?

        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        let placeholderLabel: AUI.Label = AUI.Label()

        var textChanged: ((String?) -> Void)?
        var beginEditing: (() -> Void)?

        @discardableResult func with(estimatedHeight: CGFloat) -> Self {
            self.estimatedHeight = estimatedHeight
            return self
        }

        func with(placeHolderString: String?) -> Self {
            self.placeholderLabel.text = placeHolderString
            return self
        }

        @discardableResult func with(textContainerInset: UIEdgeInsets) -> Self {
            self.textContainerInset = textContainerInset
            return self
        }

        @discardableResult func with(font: UIFont) -> Self {
            self.font = font
            return self
        }

        @discardableResult func with(estimatedSize: CGSize) -> Self {
            self.estimatedWidth = estimatedSize.width
            self.estimatedHeight = estimatedSize.height
            return self
        }

        @discardableResult func with(textColor: UIColor) -> Self {
            self.textColor = textColor
            return self
        }

        @discardableResult func with(estimatedWidth: CGFloat) -> Self {
            self.estimatedWidth = estimatedWidth
            return self
        }

        @discardableResult func with(text: String) -> Self {
            self.text = text
            return self
        }

        override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        func setup() {
            notificationCenter.addObserver(
                self,
                selector: #selector(textDidChange),
                name: UITextView.textDidChangeNotification,
                object: self
            )
            notificationCenter.addObserver(
                self,
                selector: #selector(beginEdit),
                name: UITextView.textDidBeginEditingNotification,
                object: self
            )
            placeholderLabel.verticalAligment = .center
            placeholderLabel.margin = .horizontal(14)
            addSubview(placeholderLabel)
        }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size.inset(by: padding))
            result.height = estimatedHeight ?? result.height
            result.width = estimatedWidth ?? result.width
            result = result.inset(by: padding.flipped.top(0))
            return result.maxSize(
                with:
                    placeholderLabel
                    .sizeThatFits(size.inset(by: padding))
                    .inset(by: padding.flipped)
                    .inset(by: placeholderLabel.margin.flipped)
            )
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            placeholderLabel.frame = placeholderLabel.aui_frame(
                inBounds: bounds.inset(by: padding)
            )
            layer.transform = aui_packTransform
        }

        deinit {
            notificationCenter.removeObserver(self)
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
}

extension AUI.TextView {
    @objc func textDidChange() {
        textChanged?(text)
        placeholderLabel.isHidden = !text.isEmpty
    }

    @objc func beginEdit() {
        beginEditing?()
    }
}
