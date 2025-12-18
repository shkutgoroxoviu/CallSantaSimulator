// Created by AliveBe on 22.04.2024.

import UIKit

extension AUI {
    final class LongPressView: AUI.BaseView {
        
        var view: UIView? {
            didSet {
                aui_animatedUpdateLayout()
                self.aui_addSubview(view)
            }
        }
        
        var handler: (() -> Void)?
        
        override func setup() {
            super.setup()
            addLongTapGesture()
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return view?.aui_size(thatFitSize: size.inset(by: padding)).inset(by: padding.flipped) ?? .zero
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            view?.frame = view?.aui_frame(inBounds: bounds.inset(by: padding)) ?? .zero
        }
        
        func with(view: UIView) -> Self {
            self.view = view
            return self
        }
        
        func withHandler(_ newHandler: @escaping () -> Void) -> Self {
            self.handler = newHandler
            return self
        }
        
        private func addLongTapGesture() {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            self.addGestureRecognizer(longPress)
        }
        
        @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                handler?()
            }
        }
    }
}
