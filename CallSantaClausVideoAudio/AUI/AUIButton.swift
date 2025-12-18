// Created by AliveBe on 06.12.2023.

import UIKit

extension AUI {
    class Button: InactiveButton {
        var actionBlock: ((AUI.Button) async -> Void)? = nil
        var isDisableOnTap = false

        @discardableResult
        func withDisableOnTap(_ disableOnTap: Bool = true) -> Self {
            self.isDisableOnTap = disableOnTap
            return self
        }        
        
        @discardableResult func withAction(_ block: @escaping (AUI.Button) async -> Void) -> Self {
            self.actionBlock = block
            return self
        }
        
        override var isHighlighted: Bool {
            didSet {
                UIView.animate(withDuration: 0.15) {
                    self.alpha = self.isHighlighted ? 0.6 : 1.0
                }
            }
        }
        
        @objc override func buttonTapped() {
            super.buttonTapped()
            guard let actionBlock else { return }
            Task { @MainActor in
                if !isDisableOnTap {
                    await actionBlock(self)
                    return
                }
                let oldIsEnabled = self.isEnabled
                self.isEnabled = false
                self.showLoading()
                await actionBlock(self)
                self.isEnabled = oldIsEnabled
                self.hideLoading()
            }
        }
        
        override func setup() {
            super.setup()
        }
                
        ///https://stackoverflow.com/a/36539725
        var activityIndicator: AUI.ActivityIndicatorView?
        
        func showLoading() {
            self.titleLabel?.alpha = 0
            self.imageView?.isHidden = true
            if (activityIndicator == nil) {
                activityIndicator = createActivityIndicator()
            }
            showSpinning()
        }

        func hideLoading() {
            self.titleLabel?.alpha = 1
            self.imageView?.isHidden = false
            activityIndicator?.stopAnimating()
        }

        private func createActivityIndicator() -> AUI.ActivityIndicatorView {
            let activityIndicator = ActivityIndicatorView()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = .lightGray
            activityIndicator.horizontalAligment = .center
            activityIndicator.verticalAligment = .center
            return activityIndicator
        }

        private func showSpinning() {
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            if let activityIndicator {
                self.addSubview(activityIndicator)
            }
            activityIndicator?.startAnimating()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicator?.frame = activityIndicator?.aui_frame(inBounds: bounds) ?? .zero
            self.layer.transform = aui_packTransform
        }
    }
    
    class ViewButton: AUI.Button {
        var view: UIView? {
            didSet {
                if oldValue?.superview == self {
                    oldValue?.removeFromSuperview()
                }
                if let view = view {
                    view.isUserInteractionEnabled = false
                    addSubview(view)
                }
            }
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return view?.aui_size(thatFitSize: size.inset(by: padding)).inset(by: padding.flipped) ?? super.sizeThatFits(size)
        }
        
        @discardableResult
        func with(view: UIView?) -> Self {
            self.view = view
            return self
        }
        
        override func setup() {
            super.setup()
            self.configurationUpdateHandler = self.updateState
        }
        
        func updateState(_ button: UIButton) {
            
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            view?.frame = view?.aui_frame(inBounds: bounds.inset(by: padding)) ?? bounds.inset(by: padding)
            view?.layoutSubviews()
        }
    }
    
    class InactiveButton: UIButton, AUIView {
        var packHidden: Bool = false { didSet { self.alpha = packHidden ? 0 : 1 }}
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left

        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        var aui_borderColor: UIColor?
        let tappedSignal : Promise<AUI.InactiveButton> = Promise()

                
        var font: UIFont? {
            set {
                self.titleLabel?.font = newValue
            }
            get {
                self.titleLabel?.font
            }
        }
        
        @discardableResult func with(estimatedSize: CGSize) -> Self {
            self.estimatedHeight = estimatedSize.height
            self.estimatedWidth  = estimatedSize.width
            return self
        }
        
        @discardableResult func with(imageResource: ImageResource) -> Self {
            self.setImage(UIImage(resource: imageResource), for: .normal)
            return self
        }
        
        @discardableResult func with(estimatedHeight: CGFloat) -> Self {
            self.estimatedHeight = estimatedHeight
            return self
        }
        
        @available(*, deprecated, message: "For Test Only")
        func withConfiguration(_ configuration: () -> UIButton.Configuration) -> Self {
            self.configuration = configuration()
            self.setNeedsUpdateConfiguration()
            return self
        }
        
        @discardableResult func with(text: String, forState: UIControl.State = .normal) -> Self {
            self.setTitle(text, for: forState)
            return self
        }
        
        @discardableResult func with(textColor: UIColor, forState: UIControl.State = .normal) -> Self {
            self.setTitleColor(textColor, for: forState)
            return self
        }
        
        func with(font: UIFont) -> Self {
            self.font = font
            return self
        }
        
        @discardableResult func with(image: UIImage?) -> Self {
            self.setImage(image, for: .normal)
            return self
        }
        
        func withSymbolAnimationEnabled(_ isEnabled: Bool = true) -> Self {
            if #available(iOS 17.0, *) {
                self.isSymbolAnimationEnabled = isEnabled
            }
            return self
        }
        
        @discardableResult
        func with(backgroundImage: UIImage?, forState: UIControl.State = .normal) -> Self {
            self.setBackgroundImage(backgroundImage, for: forState)
            return self
        }
        
        @discardableResult func with(tintColor: UIColor) -> Self {
            self.tintColor = tintColor
            return self
        }

        @discardableResult func with(estimatedWidth: CGFloat) -> Self {
            self.estimatedWidth = estimatedWidth
            return self
        }
        
        required convenience init() {
            self.init(type: .custom)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        func setup() {
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        @objc func buttonTapped() {
            tappedSignal.sendNext(self)
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size).inset(by: padding.flipped)
            result.height = estimatedHeight ?? result.height
            result.width = estimatedWidth ?? result.width
            return result
        }
        

        static func titleButton(title: String? = nil, color: UIColor? = nil) -> Self {
            let result = Self()
            result.setTitle(title, for: .normal)
            result.setTitleColor(color, for: .normal)
            return result
        }
        
        static func infoButton(title: String? = nil, image: UIImage? = nil, textColor: UIColor? = nil) -> Self {
            let result = Self()
            result.setTitle(title, for: .normal)
            result.setImage(image, for: .normal)
            result.tintColor = .black
            result.setTitleColor(textColor, for: .normal)
            return result
        }
        
        static func imageButton(image: UIImage?, size: CGSize, cornered: Bool = false, backgroundColor: UIColor? = nil) -> Self {
            let result = Self()
            result.setImage(image, for: .normal)
            result.backgroundColor = backgroundColor
            result.with(estimatedSize: size)
            if cornered {
                result.layer.cornerRadius = min(size.width, size.height)/2
                result.clipsToBounds = true
            }
            return result
        }
        
        static func anotherInfoButton(title: String?, image: UIImage?, textColor: UIColor?, tintColor: UIColor?) -> Self {
            let result = Self()
            result.setTitle(title, for: .normal)
            result.setImage(image, for: .normal)
            result.tintColor = tintColor
            result.setTitleColor(textColor, for: .normal)
            return result
        }
        
        static func submitButton(
            title: String? = nil,
            titleColor: UIColor = .black,
            backgroundColor: UIColor = UIColor(hexValue: 0xFFDC7C),
            height: CGFloat? = nil,
            width: CGFloat? = nil,
            font: UIFont? = nil
        ) -> Self {
            let result = Self()
            result.setTitle( title ?? "SUBMIT", for: .normal)
            result.setTitleColor(titleColor, for: .normal)
            result.setBackgroundImage(.aui.submitButtonImage(color: backgroundColor), for: .normal)
            result.setBackgroundImage(.aui.submitButtonImage(color: .lightGray), for: .disabled)
            result.estimatedHeight = height
            result.estimatedWidth = width
            result.titleLabel?.font = font
            result.horizontalAligment = .fill
            result.tintColor = .black
            return result
        }
        
        static func anotherSubmitButton( title: String? = nil, titleColor: UIColor? = nil, height: CGFloat? = nil, width: CGFloat? = nil, font: UIFont? = nil, backgroundColor: UIColor? = nil) -> Self {
            let result = Self()
            result.setTitle( title ?? "SUBMIT", for: .normal)
            result.setTitleColor(titleColor, for: .normal)
            result.backgroundColor = backgroundColor
            result.estimatedHeight = height
            result.estimatedWidth = width
            result.titleLabel?.font = font
            return result
        }
        
        static func imageSubmitButton( title: String? = nil, titleColor: UIColor? = nil, height: CGFloat? = nil, width: CGFloat? = nil, font: UIFont? = nil, backgroundColor: UIColor? = nil, image: UIImage? = nil) -> Self {
            let result = Self()
            result.setTitle( title ?? "SUBMIT", for: .normal)
            result.setTitleColor(titleColor, for: .normal)
            result.backgroundColor = backgroundColor
            result.estimatedHeight = height
            result.estimatedWidth = width
            result.titleLabel?.font = font
            result.setImage(image, for: .normal)
            return result
        }
    }
}

extension AUI.Button {
    func with(isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }
    
    @discardableResult func with(image: UIImage?, for state: UIControl.State) -> Self {
        self.setImage(image, for: state)
        return self
    }
}

extension AUI.Button {
    class EnlargedTapButton: AUI.Button {
        var hitTestEdgeInsets = UIEdgeInsets.zero
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let relativeFrame = self.bounds
            let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets.inverted())
            return hitFrame.contains(point)
        }
    }
}

extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -self.top, left: -self.left, bottom: -self.bottom, right: -self.right)
    }
}

