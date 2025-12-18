// Created by AliveBe on 24.09.2025.

import UIKit

extension AUI {
    class SeparatedEqualHorizontalView<SeparatorView: UIView>: AUI.EqualHorizontalView {
        private var _separators: [SeparatorView] = []
        
        private func _set(separatorsCount: Int) {
            guard _separators.count != separatorsCount else { return }
            guard separatorsCount > 0 else {
                for separator in _separators {
                    separator.removeFromSuperview()
                }
                _separators.removeAll()
                return
            }
            let currentSeparatorCount = _separators.count
            guard currentSeparatorCount != separatorsCount else { return }
            if currentSeparatorCount > separatorsCount {
                let removingCount = currentSeparatorCount - separatorsCount
                let removingViews = _separators.suffix(removingCount)
                for removingView in removingViews {
                    removingView.removeFromSuperview()
                }
                _separators.removeLast(removingCount)
                return
            }
            let addingCount = separatorsCount - currentSeparatorCount
            (0..<addingCount).forEach { _ in
                let separatorView = SeparatorView()
                addSubview(separatorView)
                _separators.append(separatorView)
            }
        }
        
        override func setup() {
            super.setup()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let newViewsCount = views.filter({ !$0.isHidden }).count
            _set(separatorsCount: newViewsCount - 1)

            let safeBounds = bounds.inset(by: padding)
            let separatorCount = _separators.count
            for (idx, separator) in _separators.enumerated() {
                separator.frame = separator
                    .aui_frame(inBounds: safeBounds)
                    .with(x: safeBounds.origin.x + (safeBounds.size.width * CGFloat(idx+1)) / CGFloat(separatorCount + 1))
            }
        }
    }
}

extension AUI {
    class VerticalSeparator: AUI.BaseView {
        override func setup() {
            super.setup()
            estimatedWidth = 1
            backgroundColor = UIColor(hexValue: 0xF3F3F3)
            verticalAligment = .fill
            margin = .vertical(8)
        }
    }
}

