// Created by AliveBe on 28.06.2024.

import UIKit
extension AUI {
    class ProgressCircleView: AUI.BaseView {
        
        private var progressLayer = CAShapeLayer()
        private var trackLayer = CAShapeLayer()
        
        var progress: CGFloat = 0
        
        var progressColor = UIColor(hexValue: 0x4CBE57) {
            didSet {
                progressLayer.strokeColor = progressColor.cgColor
            }
        }
        
        var trackColor = UIColor.white {
            didSet {
                trackLayer.strokeColor = trackColor.cgColor
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupLayers()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupLayers()
        }
    
        private func setupLayers() {
            layer.addSublayer(trackLayer)
            layer.addSublayer(progressLayer)
            updatePath()
        }
        
        private func updatePath() {
            let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
            let radius = bounds.width / 2
            let circlePath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
            
            trackLayer.path = circlePath.cgPath
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.strokeColor = trackColor.cgColor
            trackLayer.lineWidth = 5.0
            trackLayer.strokeEnd = 1.0
            
            progressLayer.path = circlePath.cgPath
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeColor = progressColor.cgColor
            progressLayer.lineWidth = 5.0
            progressLayer.strokeEnd = progress
        }
        
        func setProgress(to progressConstant: CGFloat) {
            progress = progressConstant
            updatePath()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            updatePath()
        }
    }
    
    class CircularProgressView: UIView, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var aui_borderColor: UIColor?
        
        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        
        private var progressLayer = CAShapeLayer()
        private var trackLayer = CAShapeLayer()
        private var innerBorderLayer = CAShapeLayer()
        private var outerBorderLayer = CAShapeLayer()
        private var progressLabel = AUI.Label()
            .with(font: .systemFont(ofSize: 18))
            .with(textAlignment: .center)
        
        var progressColor: UIColor = .orange
        var trackColor: UIColor = .white
        var borderColor: UIColor = .lightGray
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            updateLayerPaths()
            layer.transform = aui_packTransform
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
                
        @discardableResult func with(estimatedSize: CGSize) -> Self {
            self.estimatedWidth = estimatedSize.width
            self.estimatedHeight = estimatedSize.height
            return self
        }
        
        private func setupView() {
            createTrackLayer()
            createProgressLayer()
            setupLabel()
            createInnerBorderLayer()
            createOuterBorderLayer()
        }
        
        private func updateLayerPaths() {
            let circularPath = UIBezierPath(
                arcCenter: CGPoint(
                    x: frame.size.width / 2,
                    y: frame.size.height / 2),
                radius: (frame.size.width - 35) / 2,
                startAngle: CGFloat.pi * 0.5,
                endAngle: CGFloat.pi * 2.5,
                clockwise: true
            )
            trackLayer.path = circularPath.cgPath
            progressLayer.path = circularPath.cgPath
            let innerPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                         radius: (frame.size.width - 45) / 2,
                                         startAngle: CGFloat.pi * 0.5,
                                                 endAngle: CGFloat.pi * 2.5,
                                         clockwise: true)
            innerBorderLayer.path = innerPath.cgPath
            
            let outerPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                         radius: (frame.size.width - 25) / 2,
                                         startAngle: CGFloat.pi * 0.5,
                                                 endAngle: CGFloat.pi * 2.5,
                                         clockwise: true)
            outerBorderLayer.path = outerPath.cgPath
            progressLabel.frame = bounds
        }


        
        private func createTrackLayer() {
            let circularPath = UIBezierPath(
                arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                radius: (frame.size.width - 30) / 2,
                startAngle: CGFloat.pi * 0.5,
                        endAngle: CGFloat.pi * 2.5,
                clockwise: true
            )
            
            trackLayer.path = circularPath.cgPath
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.strokeColor = trackColor.cgColor
            trackLayer.lineWidth = 11
            trackLayer.lineCap = .butt
            layer.addSublayer(trackLayer)
        }

        private func createProgressLayer() {
            let circularPath = UIBezierPath(
                arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                radius: (frame.size.width - 30) / 2,
                startAngle: CGFloat.pi * 0.5,
                        endAngle: CGFloat.pi * 2.5,
                clockwise: true
            )
            
            progressLayer.path = circularPath.cgPath
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeColor = progressColor.cgColor
            progressLayer.lineWidth = 11
            progressLayer.lineCap = .butt
            progressLayer.strokeEnd = 0
            layer.addSublayer(progressLayer)
        }

        private func createInnerBorderLayer() {
            let innerPath = UIBezierPath(
                arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                radius: (frame.size.width - 35) / 2,
                startAngle: CGFloat.pi * 0.5,
                        endAngle: CGFloat.pi * 2.5,
                clockwise: true
            )
            
            innerBorderLayer.path = innerPath.cgPath
            innerBorderLayer.fillColor = UIColor.clear.cgColor
            innerBorderLayer.strokeColor = borderColor.cgColor
            innerBorderLayer.lineWidth = 2
            layer.addSublayer(innerBorderLayer)
        }

        private func createOuterBorderLayer() {
            let outerPath = UIBezierPath(
                arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                radius: (frame.size.width - 25) / 2,
                startAngle: CGFloat.pi * 0.5,
                        endAngle: CGFloat.pi * 2.5,
                clockwise: true
            )
            
            outerBorderLayer.path = outerPath.cgPath
            outerBorderLayer.fillColor = UIColor.clear.cgColor
            outerBorderLayer.strokeColor = borderColor.cgColor
            outerBorderLayer.lineWidth = 2
            layer.addSublayer(outerBorderLayer)
        }

        
        private func setupLabel() {
            progressLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            addSubview(progressLabel)
        }
        
        func setProgress(with value: CGFloat) {
            if value < 35 {
                progressLayer.strokeColor = UIColor(hexValue: 0xFD7442).cgColor
                progressLabel.textColor = UIColor(hexValue: 0xFD7442)
            } else if value > 34 && value < 100 {
                progressLayer.strokeColor = UIColor(hexValue: 0xFFBF13).cgColor
                progressLabel.textColor = UIColor(hexValue: 0xFFBF13)
            } else if value >= 100 {
                progressLayer.strokeColor = UIColor(hexValue: 0x16A75E).cgColor
                progressLabel.textColor = UIColor(hexValue: 0x16A75E)
            }
            progressLayer.strokeEnd = value / 100
            if Int(value) > 100 {
                progressLabel.text = "100%"
            } else {
                progressLabel.text = "\(Int(value))%"
            }
            animateProgress(to: value / 100)
        }
        
        private func animateProgress(to value: CGFloat) {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = value
            animation.duration = 1.0
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            progressLayer.add(animation, forKey: "progressAnim")
        }
    }
}
