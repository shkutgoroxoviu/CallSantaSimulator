// Created by AliveBe on 08.12.2023.

import UIKit

protocol AUIView: AnyObject {
    var margin: UIEdgeInsets { get set }
    var padding: UIEdgeInsets { get set }
    var verticalAligment: AUI.VerticalAligment { get set }
    var horizontalAligment: AUI.HorizontalAligment { get set }
    var estimatedHeight: CGFloat? { get set }
    var estimatedWidth: CGFloat? { get set }
    var packHidden: Bool { get set }
    var aui_borderColor: UIColor? { get set }
}

typealias AnyAUIView = AUIView & UIView

extension AUIView {
    @discardableResult func using(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
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
    
    func with(packHidden: Bool) -> Self {
        self.packHidden = packHidden
        return self
    }
    
    var aui_packTransform: CATransform3D {
        packHidden ? CATransform3DMakeScale(1, 0, 0) : CATransform3DIdentity
    }
}

extension AUIView where Self: UIView {
    func with(aui_borderColor: UIColor?) -> Self {
        self.aui_borderColor = aui_borderColor
        self.aui_updateBorder()
        return self
    }
    
    func aui_updateBorder() {
        self.layer.borderColor = aui_borderColor?.cgColor ?? UIColor.clear.cgColor
        self.layer.borderWidth = aui_borderColor != nil ? 1 : 0
    }
}

extension AUI {
    enum VerticalAligment {
        case top
        case bottom
        case center
        case fill
    }
    
    enum HorizontalAligment {
        case left
        case right
        case center
        case fill
    }
}

extension AUIView {
    @discardableResult func with(margin: UIEdgeInsets) -> Self {
        self.margin = margin
        return self
    }
    
    @discardableResult func with(padding: UIEdgeInsets) -> Self {
        self.padding = padding
        return self
    }
    
    @discardableResult func with(verticalAligment: AUI.VerticalAligment) -> Self {
        self.verticalAligment = verticalAligment
        return self
    }

    @discardableResult func with(horizontalAligment: AUI.HorizontalAligment) -> Self {
        self.horizontalAligment = horizontalAligment
        return self
    }    
}

extension UIView {
    var aui_verticalAligment: AUI.VerticalAligment {
        guard let view = self as? AUIView else { return .top }
        return view.verticalAligment
    }
    
    var aui_horizontalAligment: AUI.HorizontalAligment {
        guard let view = self as? AUIView else { return .left }
        return view.horizontalAligment
    }
    
    var aui_margin: UIEdgeInsets {
        guard let view = self as? AUIView else { return .zero }
        return view.margin
    }
    
    var aui_padding: UIEdgeInsets {
        guard let view = self as? AUIView else { return self.safeAreaInsets }
        return view.padding
    }
    
    @objc func aui_addSubview(_ view: UIView?) {
        guard let view = view else { return }
        addSubview(view)
    }
    
    @objc func aui_size(thatFitSize: CGSize) -> CGSize {
        self.sizeThatFits(thatFitSize.inset(by: aui_margin)).inset(by: aui_margin.flipped)
    }
    
    @objc func aui_frame(inBounds: CGRect) -> CGRect {
        let safeBounds = inBounds.inset(by: self.aui_margin)
        let viewSize = self.sizeThatFits(safeBounds.size).bounded(by: inBounds.size)
        var result = safeBounds.with(size: viewSize)
        switch aui_verticalAligment {
        case .top:
            result.origin.y = safeBounds.origin.y
        case .bottom:
            result.origin.y = safeBounds.maxY - viewSize.height
        case .center:
            result.origin.y = safeBounds.origin.y + (safeBounds.height - viewSize.height) / 2.0
        case .fill:
            result.size.height = safeBounds.height
        }
        
        switch aui_horizontalAligment {
        case .left:
            result.origin.x = safeBounds.origin.x
        case .right:
            result.origin.x = safeBounds.maxX - viewSize.width
        case .center:
            result.origin.x = safeBounds.origin.x + (safeBounds.width - viewSize.width) / 2.0
        case .fill:
            result.size.width = safeBounds.width
        }
        return result
    }
    
    func aui_animatedUpdateLayout() {
        self.invalidateIntrinsicContentSize()
        if let superview = self.superview as? AnyAUIView {
            superview.aui_animatedUpdateLayout()
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutSubviews()
        }
    }
    
    var aui_packHidden: Bool {
        get {
            if let aui_view = self as? AnyAUIView {
                return aui_view.packHidden
            }
            return false
        }
        set {
            guard let aui_view = self as? AnyAUIView else { return }
            aui_view.packHidden = newValue
        }
    }
    
    var aui_hidden: Bool {
        aui_packHidden || isHidden
    }
    
    func with(overrideUserInterfaceStyle: UIUserInterfaceStyle) -> Self {
        self.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        return self
    }
    
    @discardableResult func with(contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    @discardableResult func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult func with(alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult func with(cornerRadius: CGFloat?) -> Self {
        guard let cornerRadius = cornerRadius else { return self }
        self.layer.cornerRadius = cornerRadius
        return self
    }
    
    @discardableResult func with(clipsToBounds: Bool?) -> Self {
        guard let clipsToBounds = clipsToBounds else { return self }
        self.clipsToBounds = clipsToBounds
        return self
    }
    
    func bringSubviewsToFront(views: [UIView]?) {
        guard let stViews = views else { return }
        for view in stViews {
            self.bringSubviewToFront(view)
        }
    }
}

extension Array where Element: UIView {
    func removeFromSuperView(superView: UIView? = nil) {
        for view in self {
            if view == superView || superView == nil {
                view.removeFromSuperview()
            }
        }
    }
}

