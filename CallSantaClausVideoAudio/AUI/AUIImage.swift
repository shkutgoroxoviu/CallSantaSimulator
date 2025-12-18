// Created by AliveBe on 06.12.2023.

import UIKit
import Kingfisher
import WebKit

extension UIImage {
    enum aui {
        @discardableResult
        static func makeContextResizeable(context: CGContext, size: CGSize, intoSize: CGSize) -> CGFloat {
            let resizedFrame: CGRect = resizeApply(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), target: CGRect(origin: .zero, size: intoSize))
            context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
            context.scaleBy(x: resizedFrame.width / size.width, y: resizedFrame.height / size.height)

            return  min(resizedFrame.width / size.width, resizedFrame.height / size.height)
        }

        //MARK: Resizing
        static func resizeApply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            scales.width = min(scales.width, scales.height)
            scales.height = scales.width
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}

extension AUI {
    class TraitImageView: UIImageView, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var estimatedHeight: CGFloat?
        var estimatedWidth: CGFloat?
        var aui_borderColor: UIColor?
        
        override var isHidden: Bool {
            get { super.isHidden || image == nil }
            set { super.isHidden = newValue}
        }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = image?.size ?? super.sizeThatFits(size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
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

extension AUI {
    class PopTraitImageView: TraitImageView {
        enum PopOption {
            case inset(_: UIEdgeInsets)
            case scale(_: CGFloat)
            case identity
            
            var flipped: PopOption {
                switch self {
                case .inset(let value):
                    return .inset(value.flipped)
                case .scale(let value):
                    return .scale(1 / value)
                case .identity:
                    return self
                }
            }
            
            func rect(fromRect: CGRect) -> CGRect {
                switch self {
                case .inset(let value):
                    return fromRect.inset(by: value)
                case .scale(let value):
                    let newWidth = fromRect.width * value
                    let newHeight = fromRect.height * value
                    let newX = fromRect.midX - newWidth / 2
                    let newY = fromRect.midY - newHeight / 2
                    return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
                case .identity:
                    return fromRect
                }
            }
        }
        
        var aui_scaleOption = PopOption.identity
        
        override var frame: CGRect {
            set { super.frame = aui_scaleOption.rect(fromRect: newValue) }
            get { aui_scaleOption.flipped.rect(fromRect: super.frame) }
        }
    }
}

extension AUI {
    class ImageView: AUI.BaseView {
        var image: UIImage? = nil {
            didSet {
                self.layer.contents = image?.cgImage
            }
        }
        
        override var isHidden: Bool {
            get { super.isHidden || image == nil }
            set { super.isHidden = newValue}
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = image?.size ?? super.sizeThatFits(size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
        
        @discardableResult
        func with(image: UIImage?) -> Self {
            self.image = image
            return self
        }
        
        @discardableResult func withAction(_ block: @escaping (Int, AUI.ImageView) async -> Void) -> Self {
            addTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                Task {
                    await block(0, self)
                }
            }
            return self
        }
    }
}

extension AUI {
    class SymbolImageView: UIImageView, AUIView {
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var estimatedHeight: CGFloat?
        var estimatedWidth: CGFloat?
        var packHidden: Bool = false
        var aui_borderColor: UIColor?
        
        func with(systemImageName: String) -> Self {
            self.image = UIImage(systemName: systemImageName)
            return self
        }
        
        func with(tintColor: UIColor) -> Self {
            self.tintColor = tintColor
            return self
        }
        
        @available(iOS 17.0, *)
        @discardableResult
        func with(symbolEffect: any DiscreteSymbolEffect & SymbolEffect) -> Self {
            self.addSymbolEffect(symbolEffect)
            return self
        }
        
        func aui_addSymbolEffect() -> Self {
            if #available(iOS 17.0, *) {
                self.addSymbolEffect(.appear)
            }
            return self
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
}

extension AUI {
    class PhotoView: UIImageView, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var aui_borderColor: UIColor?
        
        var estimatedHeight: CGFloat?
        var estimatedWidth: CGFloat?
        
        override var isHidden: Bool {
            get { super.isHidden || image == nil }
            set { super.isHidden = newValue}
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size.inset(by: padding)).inset(by: padding.flipped)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
        
        func setup() {
            self.isUserInteractionEnabled = true
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

extension AUI {
    class URLImageView: AUI.BaseView {
        private var _imageURLString: String? = nil
        var onImageLoaded: ((UIImage) -> Void)?
        var verticalProportion: CGFloat = 0
        var imageURLString: String? {
            get {
                _imageURLString
            }
            set {
                if newValue == _imageURLString, image != nil {
                    return
                }
                _imageURLString = newValue
                image = nil
                guard let imageURLString = imageURLString, let imageURL = URL(string: imageURLString) else {
                    return
                }
                if !imageURLString.hasPrefix("http") {
                    print("🎨❌ Weird Image URL: \(imageURLString)")
                }
                let loadingURLString = newValue
                KingfisherManager.shared.retrieveImage(with: Kingfisher.KF.ImageResource(downloadURL: imageURL)) { [weak self] result in
                    guard let self, loadingURLString == self._imageURLString else { return }
                    self.image = result.successOrNil?.image
                    self.onImageLoaded?(result.successOrNil?.image ?? UIImage())
                }
            }
        }
        
        var placeHolderImage: UIImage? {
            didSet {
                updateImage(fromImage: image, toImage: image)
            }
        }
        
        var image: UIImage? { didSet {
            updateImage(fromImage: oldValue, toImage: image)
        }}
        
        func updateImage(fromImage: UIImage?, toImage: UIImage?) {
            let newImage = toImage ?? placeHolderImage
            if fromImage == newImage { return }
            contentImageView.image = newImage
            aui_animatedUpdateLayout()
            UIView.animate(withDuration: 0.3) {
                self.contentImageView.alpha = newImage != nil ? 1 : 0
            }
        }
        
        private let contentImageView = UIImageView()
        
        @discardableResult func with(image: UIImage?) -> Self {
            self.image = image
            return self
        }
        
        @discardableResult func with(placeholderImage: UIImage?) -> Self {
            self.placeHolderImage = placeholderImage
            return self
        }
        
        @discardableResult func with(imageURLString: String?) -> Self {
            self.imageURLString = imageURLString
            return self
        }
        
        @discardableResult func with(verticalProportion: CGFloat) -> Self {
            self.verticalProportion = verticalProportion
            return self
        }
        
        override func setup() {
            super.setup()
            backgroundColor = .gray.withAlphaComponent(0.2)
            addSubview(contentImageView)
            clipsToBounds = true
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let prevResult = super.sizeThatFits(size)
            guard let image else { return prevResult }
            let imageSize: CGSize = image.size
            let result: CGSize
            if let estimatedWidth, let estimatedHeight {
                result = CGSize(width: estimatedWidth, height: estimatedHeight)
            }
            else if let estimatedWidth, imageSize.width > 0 {
                result = CGSize(width: estimatedWidth, height: imageSize.height * estimatedWidth / imageSize.width)
            }
            else if let estimatedHeight, imageSize.height > 0 {
                result = CGSize(width: imageSize.width * estimatedHeight / imageSize.height, height: estimatedHeight)
            }
            else {
                result = imageSize
            }
            return result.maxSize(with: prevResult)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            contentImageView.frame = bounds
            guard let image = image else {
                return
            }
            if case .scaleAspectFill = self.contentMode {
                contentImageView.frame = bounds
                contentImageView.contentMode = .scaleAspectFill
                return
            }
            var imageSize = image.size
            imageSize = CGSize(
                width: bounds.width,
                height: imageSize.height * bounds.width / imageSize.width)
            contentImageView.frame = bounds.with(size: imageSize)
                .with(y: verticalProportion * (bounds.height - imageSize.height))
        }
    }
}

extension AUI {
    class URLImageButtonView: AUI.URLImageView {
        let button = AUI.Button()
        var index = 0
        
        override func setup() {
            super.setup()
            addSubview(button)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            button.frame = bounds
        }
        
        @discardableResult func with(index: Int) -> Self {
            self.index = index
            return self
        }
        
        @discardableResult func withAction(_ block: @escaping (Int, AUI.URLImageButtonView) async -> Void) -> Self {
            self.button.withAction { [weak self] button in
                guard let self = self else { return }
                await block(index, self)
            }
            return self
        }
    }
    
    class ZoomURLImageButtonView: AUI.URLImageView, UIScrollViewDelegate {
        let scrollView = UIScrollView()
        let imageView = AUI.ImageView()
        var index = 0
        
        override func setup() {
            super.setup()
            scrollView.backgroundColor = .clear
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 4.0
            scrollView.delegate = self
            
            addSubview(scrollView)
            scrollView.addSubview(imageView)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            scrollView.frame = bounds
            
            imageView.frame = scrollView.bounds
        }
        
        func setImage(_ image: UIImage?) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            layoutSubviews()
        }
    }
}

extension AUI.ZoomURLImageButtonView {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView 
    }
}

extension AUI {
    class LayerView<T: CALayer>: AUI.BaseView {
        var aui_layer: T? {
            return self.layer as? T
        }
        override public class var layerClass: AnyClass { T.self }
    }
}

extension UIImage.aui {
    static func with(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let rectanglePath = UIBezierPath(rect: .zero.with(size: size))
        color.setFill()
        rectanglePath.fill()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func dashImage(
        dashColor: UIColor,
        dashLength: CGFloat,
        dashGap: CGFloat,
        borderWidth: CGFloat,
        cornderRadius: CGFloat,
        size: CGSize,
        backgroundColor: UIColor = .clear
    ) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let rectanglePath = UIBezierPath(
            roundedRect: CGRect(origin: .zero, size: size).inset(by: .all(borderWidth)),
            cornerRadius: cornderRadius)
        backgroundColor.setFill()
        rectanglePath.fill()
        dashColor.setStroke()
        rectanglePath.lineWidth = borderWidth
        context.saveGState()
        context.setLineDash(phase: 0, lengths: [dashLength, dashGap])
        rectanglePath.stroke()
        context.restoreGState()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func navigationCloseImage(
        color: UIColor = UIColor(hexValue: 0x212121).withAlphaComponent(60),
        backgroundColor: UIColor = UIColor(hexValue: 0xF6F6F6),
        size: CGSize = .square(44)
    ) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        _ = makeContextResizeable(
            context: context,
            size: CGSize(width: 44, height: 44),
            intoSize: size)

        //// Color Declarations
        let fillColor15 = backgroundColor //UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.000)
        let fillColor16 = color//UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 0.600)

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 44, height: 44))
        fillColor15.setFill()
        ovalPath.fill()


        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 15.72, y: 15.74))
        bezierPath.addCurve(to: CGPoint(x: 16.5, y: 15.41), controlPoint1: CGPoint(x: 15.93, y: 15.53), controlPoint2: CGPoint(x: 16.21, y: 15.41))
        bezierPath.addCurve(to: CGPoint(x: 17.28, y: 15.74), controlPoint1: CGPoint(x: 16.79, y: 15.41), controlPoint2: CGPoint(x: 17.07, y: 15.53))
        bezierPath.addLine(to: CGPoint(x: 21.45, y: 19.91))
        bezierPath.addLine(to: CGPoint(x: 25.62, y: 15.74))
        bezierPath.addCurve(to: CGPoint(x: 25.98, y: 15.49), controlPoint1: CGPoint(x: 25.72, y: 15.63), controlPoint2: CGPoint(x: 25.84, y: 15.55))
        bezierPath.addCurve(to: CGPoint(x: 26.4, y: 15.4), controlPoint1: CGPoint(x: 26.11, y: 15.43), controlPoint2: CGPoint(x: 26.26, y: 15.4))
        bezierPath.addCurve(to: CGPoint(x: 26.83, y: 15.48), controlPoint1: CGPoint(x: 26.55, y: 15.4), controlPoint2: CGPoint(x: 26.69, y: 15.43))
        bezierPath.addCurve(to: CGPoint(x: 27.19, y: 15.72), controlPoint1: CGPoint(x: 26.96, y: 15.54), controlPoint2: CGPoint(x: 27.09, y: 15.62))
        bezierPath.addCurve(to: CGPoint(x: 27.43, y: 16.08), controlPoint1: CGPoint(x: 27.29, y: 15.83), controlPoint2: CGPoint(x: 27.38, y: 15.95))
        bezierPath.addCurve(to: CGPoint(x: 27.51, y: 16.51), controlPoint1: CGPoint(x: 27.49, y: 16.22), controlPoint2: CGPoint(x: 27.51, y: 16.36))
        bezierPath.addCurve(to: CGPoint(x: 27.42, y: 16.93), controlPoint1: CGPoint(x: 27.51, y: 16.66), controlPoint2: CGPoint(x: 27.48, y: 16.8))
        bezierPath.addCurve(to: CGPoint(x: 27.18, y: 17.29), controlPoint1: CGPoint(x: 27.37, y: 17.07), controlPoint2: CGPoint(x: 27.28, y: 17.19))
        bezierPath.addLine(to: CGPoint(x: 23.01, y: 21.46))
        bezierPath.addLine(to: CGPoint(x: 27.18, y: 25.64))
        bezierPath.addCurve(to: CGPoint(x: 27.49, y: 26.41), controlPoint1: CGPoint(x: 27.38, y: 25.84), controlPoint2: CGPoint(x: 27.49, y: 26.12))
        bezierPath.addCurve(to: CGPoint(x: 27.16, y: 27.18), controlPoint1: CGPoint(x: 27.48, y: 26.7), controlPoint2: CGPoint(x: 27.37, y: 26.97))
        bezierPath.addCurve(to: CGPoint(x: 26.4, y: 27.5), controlPoint1: CGPoint(x: 26.96, y: 27.38), controlPoint2: CGPoint(x: 26.68, y: 27.5))
        bezierPath.addCurve(to: CGPoint(x: 25.62, y: 27.19), controlPoint1: CGPoint(x: 26.11, y: 27.5), controlPoint2: CGPoint(x: 25.83, y: 27.39))
        bezierPath.addLine(to: CGPoint(x: 21.45, y: 23.02))
        bezierPath.addLine(to: CGPoint(x: 17.28, y: 27.19))
        bezierPath.addCurve(to: CGPoint(x: 16.5, y: 27.5), controlPoint1: CGPoint(x: 17.07, y: 27.39), controlPoint2: CGPoint(x: 16.79, y: 27.5))
        bezierPath.addCurve(to: CGPoint(x: 15.74, y: 27.18), controlPoint1: CGPoint(x: 16.22, y: 27.5), controlPoint2: CGPoint(x: 15.94, y: 27.38))
        bezierPath.addCurve(to: CGPoint(x: 15.41, y: 26.41), controlPoint1: CGPoint(x: 15.53, y: 26.97), controlPoint2: CGPoint(x: 15.42, y: 26.7))
        bezierPath.addCurve(to: CGPoint(x: 15.72, y: 25.64), controlPoint1: CGPoint(x: 15.41, y: 26.12), controlPoint2: CGPoint(x: 15.52, y: 25.84))
        bezierPath.addLine(to: CGPoint(x: 19.89, y: 21.46))
        bezierPath.addLine(to: CGPoint(x: 15.72, y: 17.29))
        bezierPath.addCurve(to: CGPoint(x: 15.4, y: 16.51), controlPoint1: CGPoint(x: 15.52, y: 17.08), controlPoint2: CGPoint(x: 15.4, y: 16.81))
        bezierPath.addCurve(to: CGPoint(x: 15.72, y: 15.74), controlPoint1: CGPoint(x: 15.4, y: 16.22), controlPoint2: CGPoint(x: 15.52, y: 15.94))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor16.setFill()
        bezierPath.fill()

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func navigationBackImage(
        color: UIColor = UIColor(hexValue: 0x212121).withAlphaComponent(60),
        backgroundColor: UIColor = UIColor(hexValue: 0xF6F6F6),
        size: CGSize = .square(44)
    ) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        _ = makeContextResizeable(
            context: context,
            size: CGSize(width: 44, height: 44),
            intoSize: size)
        
        //// Color Declarations
        let fillColor15 = backgroundColor
        let fillColor16 = color

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 44, height: 44))
        fillColor15.setFill()
        ovalPath.fill()


        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 29.7, y: 20.74))
        bezierPath.addLine(to: CGPoint(x: 16.65, y: 20.74))
        bezierPath.addLine(to: CGPoint(x: 20.64, y: 15.26))
        bezierPath.addCurve(to: CGPoint(x: 20.5, y: 13.49), controlPoint1: CGPoint(x: 21.03, y: 14.73), controlPoint2: CGPoint(x: 20.97, y: 13.94))
        bezierPath.addCurve(to: CGPoint(x: 18.96, y: 13.65), controlPoint1: CGPoint(x: 20.04, y: 13.05), controlPoint2: CGPoint(x: 19.34, y: 13.12))
        bezierPath.addLine(to: CGPoint(x: 13.46, y: 21.2))
        bezierPath.addCurve(to: CGPoint(x: 13.36, y: 21.39), controlPoint1: CGPoint(x: 13.41, y: 21.25), controlPoint2: CGPoint(x: 13.39, y: 21.32))
        bezierPath.addCurve(to: CGPoint(x: 13.28, y: 21.54), controlPoint1: CGPoint(x: 13.33, y: 21.44), controlPoint2: CGPoint(x: 13.3, y: 21.49))
        bezierPath.addCurve(to: CGPoint(x: 13.2, y: 21.99), controlPoint1: CGPoint(x: 13.23, y: 21.69), controlPoint2: CGPoint(x: 13.2, y: 21.84))
        bezierPath.addCurve(to: CGPoint(x: 13.2, y: 22), controlPoint1: CGPoint(x: 13.2, y: 22), controlPoint2: CGPoint(x: 13.2, y: 22))
        bezierPath.addCurve(to: CGPoint(x: 13.2, y: 22), controlPoint1: CGPoint(x: 13.2, y: 22), controlPoint2: CGPoint(x: 13.2, y: 22))
        bezierPath.addCurve(to: CGPoint(x: 13.28, y: 22.45), controlPoint1: CGPoint(x: 13.2, y: 22.16), controlPoint2: CGPoint(x: 13.23, y: 22.31))
        bezierPath.addCurve(to: CGPoint(x: 13.36, y: 22.61), controlPoint1: CGPoint(x: 13.3, y: 22.51), controlPoint2: CGPoint(x: 13.33, y: 22.56))
        bezierPath.addCurve(to: CGPoint(x: 13.46, y: 22.8), controlPoint1: CGPoint(x: 13.39, y: 22.68), controlPoint2: CGPoint(x: 13.41, y: 22.75))
        bezierPath.addLine(to: CGPoint(x: 18.96, y: 30.35))
        bezierPath.addCurve(to: CGPoint(x: 19.8, y: 30.8), controlPoint1: CGPoint(x: 19.17, y: 30.65), controlPoint2: CGPoint(x: 19.49, y: 30.8))
        bezierPath.addCurve(to: CGPoint(x: 20.5, y: 30.51), controlPoint1: CGPoint(x: 20.05, y: 30.8), controlPoint2: CGPoint(x: 20.3, y: 30.7))
        bezierPath.addCurve(to: CGPoint(x: 20.64, y: 28.74), controlPoint1: CGPoint(x: 20.97, y: 30.06), controlPoint2: CGPoint(x: 21.03, y: 29.27))
        bezierPath.addLine(to: CGPoint(x: 16.65, y: 23.26))
        bezierPath.addLine(to: CGPoint(x: 29.7, y: 23.26))
        bezierPath.addCurve(to: CGPoint(x: 30.8, y: 22), controlPoint1: CGPoint(x: 30.31, y: 23.26), controlPoint2: CGPoint(x: 30.8, y: 22.69))
        bezierPath.addCurve(to: CGPoint(x: 29.7, y: 20.74), controlPoint1: CGPoint(x: 30.8, y: 21.31), controlPoint2: CGPoint(x: 30.31, y: 20.74))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor16.setFill()
        bezierPath.fill()

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension UIImage {
    func resized(to size: CGSize)  {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        UIGraphicsEndImageContext()
    }
    
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return nil }
        
        let rect = CGRect(origin: .zero, size: self.size)
        
        // Нарисуем оригинальное изображение в контексте
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        context.draw(cgImage, in: rect)
        
        // Теперь наложим цвет
        context.setBlendMode(.sourceIn)
        color.setFill()
        context.fill(rect)
        
        // Получаем новое изображение
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        return coloredImage
    }
    
    ///https://stackoverflow.com/questions/62343990/uiimage-pngdata-losing-camera-photo-orientation
    var rotateImage: UIImage  {
        if (self.imageOrientation == UIImage.Orientation.up ) {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy ?? self
    }
}

extension URL {
    func deletingQuery() -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.query = nil
        return components?.url
    }
}

extension AUI.URLImageView {
    func loadImage(urlString: String) async -> UIImage? {
        await withCheckedContinuation { continuation in
            self.imageURLString = urlString
            KingfisherManager.shared.retrieveImage(
                with: Kingfisher.KF.ImageResource(downloadURL: URL(string: urlString)!)) { result in
                    switch result {
                    case .success(let value):
                        continuation.resume(returning: value.image)
                    case .failure:
                        continuation.resume(returning: nil)
                    }
                }
        }
    }
}
