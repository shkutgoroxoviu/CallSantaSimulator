// Created by AliveBe on 01.07.2024.

import UIKit

extension AUI {
    class Switcher: UISwitch, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var aui_borderColor: UIColor?

        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        
        var valueChanged: ((Bool) -> Void)?
        
        @discardableResult func with(setOn: Bool) -> Self {
            self.setOn(setOn, animated: true)
            return self
        }
        
        @discardableResult func with(onTintColor: UIColor) -> Self {
            self.onTintColor = onTintColor
            return self
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
            addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        }
        
        @objc func switchStateChanged(_ sender: UISwitch) {
            if sender.isOn {
                valueChanged?(true)
            } else {
                valueChanged?(false)
            }
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size).inset(by: padding.flipped)
            result.height = estimatedHeight ?? result.height
            result.width = estimatedWidth ?? result.width
            return result
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.transform = aui_packTransform
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
}
