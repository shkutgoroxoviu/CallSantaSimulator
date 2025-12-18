// Created by AliveBe on 13.08.2024.

import UIKit

extension AUI {
    class Slider: AUI.ZStackView {
        let downSlider = AUI.URLImageView()
        let upperSlider = AUI.URLImageView()
        let changeLine = AUI.BaseView()
        let backgroundLine = AUI.BaseView()
        let downSliderHitArea = AUI.ZStackView()
        let upperSliderHitArea = AUI.ZStackView()
        var minValue = 0
        var maxValue = 100
        var sendValues: ((Int, Int) -> Void)?
        
        var valueChanged: ((Bool) -> Void)?
        
        override func setup() {
            super.setup()
            self.estimatedHeight = 24
            
            withViews {
                backgroundLine
                    .with(backgroundColor: .gray)
                    .with(estimatedHeight: 2)
                    .with(margin: .right(24))
                    .with(horizontalAligment: .fill)
                    .with(verticalAligment: .center)
                changeLine
                    .with(backgroundColor: .yellow)
                    .with(estimatedHeight: 2)
                    .with(margin: .right(24))
                    .with(horizontalAligment: .fill)
                    .with(verticalAligment: .center)
                downSliderHitArea
                    .with(margin: .left(-24))
                    .with(estimatedSize: .square(48))
                    .with(horizontalAligment: .left)
                    .withViews {
                        downSlider
                            .with(verticalAligment: .center)
                            .with(estimatedSize: .square(24))
                            .with(horizontalAligment: .center)
                            .with(backgroundColor: .clear)
                            .with(image: .actions)
                        
                    }
                upperSliderHitArea
                    .with(estimatedSize: .square(48))
                    .with(horizontalAligment: .right)
                    .withViews {
                        upperSlider
                            .with(verticalAligment: .center)
                            .with(estimatedSize: .square(24))
                            .with(horizontalAligment: .center)
                            .with(backgroundColor: .clear)
                            .with(image: .actions)
                    }
            }
            
            let panGestureDown = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            let panGestureUp = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            
            downSliderHitArea.addGestureRecognizer(panGestureDown)
            upperSliderHitArea.addGestureRecognizer(panGestureUp)
            
            downSliderHitArea.isUserInteractionEnabled = true
            upperSliderHitArea.isUserInteractionEnabled = true
        }
        
        private func valueForSlider(_ slider: AUI.ZStackView) -> Int {
            let normalizedX = slider.center.x / backgroundLine.bounds.width
            let valueRange = maxValue - minValue
            return Int(round(normalizedX * CGFloat(valueRange) + CGFloat(minValue)))
        }
        
        private func updateChangeLine() {
            let downSliderCenterX = downSliderHitArea.frame.midX
            let upperSliderCenterX = upperSliderHitArea.frame.midX
            let newWidth = upperSliderCenterX - downSliderCenterX
            changeLine.frame = CGRect(
                x: downSliderCenterX,
                y: changeLine.frame.origin.y,
                width: newWidth,
                height: changeLine.frame.height
            )
            isLayout = false
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: self)
            guard let slider = gesture.view as? AUI.ZStackView else { return }
            let newX = slider.center.x + translation.x
            
            let minimumDistance: CGFloat = 12
            let sliderWidth = self.backgroundLine.bounds.width
            
            if slider == downSliderHitArea {
                if newX >= 0 && newX <= upperSliderHitArea.center.x - minimumDistance {
                    slider.center = CGPoint(x: newX, y: slider.center.y)
                    updateChangeLine()
                    sendValues?(valueForSlider(downSliderHitArea), valueForSlider(upperSliderHitArea))
                }
            } else if slider == upperSliderHitArea {
                if newX >= downSliderHitArea.center.x + minimumDistance && newX <= sliderWidth {
                    slider.center = CGPoint(x: newX, y: slider.center.y)
                    updateChangeLine()
                    sendValues?(valueForSlider(downSliderHitArea), valueForSlider(upperSliderHitArea))
                }
            }
            
            gesture.setTranslation(.zero, in: self)
            
            valueChanged?(true)
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size).inset(by: padding.flipped)
            result.height = estimatedHeight ?? result.height
            result.width = estimatedWidth ?? result.width
            return result
        }
    }
}
