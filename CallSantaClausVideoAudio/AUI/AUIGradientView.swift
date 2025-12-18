// Created by AliveBe on 10.08.2025.

import UIKit

extension AUI {
    class GradientView: AUI.BaseView {
        override class var layerClass: AnyClass {
            CAGradientLayer.self
        }
        
        @discardableResult func with(
            topColor: UIColor, bottomColor: UIColor
        ) -> Self {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return self }
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
            gradientLayer.startPoint = .init(x: 0, y: 0)
            gradientLayer.endPoint = .init(x: 0, y: 1)
            return self
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
    }
}

