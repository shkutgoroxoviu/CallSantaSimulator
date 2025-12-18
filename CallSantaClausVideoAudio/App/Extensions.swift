//
//  Extensions.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit
import ObjectiveC
import SwiftUI

extension UIView: AssociatedStore {}

extension UIView {

    private struct AssociatedKeys {
        static var onTapAction = "onTapAction"
    }

    private typealias Action = (() -> Void)?

    private var onTapAction: Action? {
        get {
            var result: Action?
            withUnsafePointer(to: &AssociatedKeys.onTapAction) { pointer in
                result = associatedObject(forKey: pointer)
            }
            return result
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onTapAction) { pointer in
                setAssociatedObject(newValue, forKey: pointer)
            }
        }
    }

    @discardableResult
    func addTapGestureRecognizer(_ action: (() -> Void)?) -> Self {
        gestureRecognizers?.filter { $0 is UITapGestureRecognizer }.forEach { removeGestureRecognizer($0) }
        isUserInteractionEnabled = true
        onTapAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        addGestureRecognizer(tapGestureRecognizer)
        return self
    }
    
    @discardableResult
    func addTapGestureRecognizer(_ action: (() -> Void)?) async -> Self {
        gestureRecognizers?.filter { $0 is UITapGestureRecognizer }.forEach { removeGestureRecognizer($0) }
        isUserInteractionEnabled = true
        onTapAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        addGestureRecognizer(tapGestureRecognizer)
        return self
    }

    @objc fileprivate func tapGestureAction() {
        guard let action = onTapAction else { return }
        action?()
    }
}

public protocol AssociatedStore {}

public extension AssociatedStore {
    func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }

    func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T {
        if let object: T = self.associatedObject(forKey: key) {
            return object
        }
        let object = `default`()
        self.setAssociatedObject(object, forKey: key)
        return object
    }

    func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension CGRect {
    init(origin: CGPoint) {
        self.init()
        self.origin = origin
        self.size = CGSize()
    }
    init(size: CGSize) {
        self.init()
        self.origin = CGPoint()
        self.size = size
    }
    init(x: CGFloat, y: CGFloat) {
        self.init()
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize()
    }
    init(x: CGFloat, y: CGFloat, size: CGSize) {
        self.init()
        self.origin = CGPoint(x: x, y: y)
        self.size = size
    }
    init(width: CGFloat, height: CGFloat) {
        self.init()
        self.origin = CGPoint()
        self.size = CGSize(width: width, height: height)
    }
    init(origin: CGPoint, width: CGFloat, height: CGFloat) {
        self.init()
        self.origin = origin
        self.size = CGSize(width: width, height: height)
    }
    
    func with(x: CGFloat) -> CGRect { return CGRect(x: x, y: y, width: width, height: height) }
    func with(y: CGFloat) -> CGRect { return CGRect(x: x, y: y, width: width, height: height) }
    func with(origin newOrigin: CGPoint) -> CGRect { return CGRect(x: newOrigin.x, y: newOrigin.y, width: self.width, height: self.height) }
    func with(width: CGFloat) -> CGRect { return CGRect(x: x, y: y, width: width, height: height) }
    func with(height: CGFloat) -> CGRect { return CGRect(x: x, y: y, width: width, height: height) }
    func with(size: CGSize) -> CGRect { return CGRect(x: x, y: y, width: size.width, height: size.height)}
    
    func with(minY: CGFloat) -> CGRect {
        CGRect(
            x: self.x,
            y: min(self.y, minY),
            width: self.size.width,
            height: self.size.height)
    }
    
    func with(maxY: CGFloat) -> CGRect {
        CGRect(
            x: self.x,
            y: max(self.y, maxY),
            width: self.size.width,
            height: self.size.height)
    }
    
    var fixNan: CGRect {
        return CGRect(
            x: x.isFinite && x.isNormal ? x : 0,
            y: y.isFinite && y.isNormal ? y : 0,
            width: width.isFinite && width.isNormal ? width : 0,
            height: height.isFinite && height.isNormal ? height : 0)
    }
    
    func with(maxHeight: CGFloat) -> CGRect { CGRect(x: x, y: y, width: width, height: max(height, maxHeight))}
    
    func with(maxWidth: CGFloat) -> CGRect { CGRect(x: x, y: y, width: max(width, maxWidth), height: height)}
    
    func with(centerX: CGFloat) -> CGRect {
        return CGRect(
            x: centerX - (size.width / 2),
            y: origin.y,
            width: size.width,
            height: size.height)
    }
    
    func with(centerY: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x,
            y: centerY - (size.height / 2),
            width: size.width,
            height: size.height)
    }
    
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    var width: CGFloat {
        get { return size.width }
        set { size.width = newValue }
    }
    var height: CGFloat {
        get { return size.height }
        set { size.height = newValue }
    }
    
    var centerX: CGFloat {
        get { return x + width / 2 }
        set { x = newValue - width / 2 }
    }
    
    var centerY: CGFloat {
        get { return y + height / 2 }
        set { y = newValue - height / 2 }
    }
    
    var center: CGPoint {
        get { return CGPoint(x: centerX, y: centerY) }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }
    var left: CGFloat {
        get { return x }
        set { x = newValue }
    }
    var top: CGFloat {
        get { return y }
        set { y = newValue }
    }
    var right: CGFloat {
        get { return x + width }
        set { x = newValue - width }
    }
    var bottom: CGFloat {
        get { return y + height }
        set { y = newValue - height }
    }
    
    var aui_normalized: CGRect {
        CGRect(
            x: self.x.rounded(.down),
            y: self.y.rounded(.down),
            width: self.width.rounded(.up),
            height: self.height.rounded(.up))
    }
    
    var aui_removingNegativeSize: CGRect {
        self.with(size: size.aui_removingNegativeSize)
    }
    
    func aui_moving(toRect: CGRect, withProgress: CGFloat) -> CGRect {
        CGRect(
            x: self.x + (toRect.x - self.x) * withProgress,
            y: self.y + (toRect.y - self.y) * withProgress,
            width: self.width + (toRect.width - self.width) * withProgress,
            height: self.height + (toRect.height - self.height) * withProgress
        )
    }
}

extension CGPoint {
    func moved(horizontal: CGFloat) -> CGPoint {
        return CGPoint(
            x: self.x + horizontal,
            y: self.y)
    }
    
    func moved(vertical: CGFloat) -> CGPoint {
        return CGPoint(
            x: self.x,
            y: self.y + vertical)
    }
}

extension CGSize {
    static func square(_ value: CGFloat) -> Self {
        CGSize(width: value, height: value)
    }
    
    func inset(by: UIEdgeInsets) -> Self {
        CGSize(
            width: self.width - by.left - by.right,
            height: self.height - by.top - by.bottom)
    }
    
    var integral: CGSize {
        CGRect(origin: .zero, size: self).integral.size
    }
    
    func maxWidth(with: CGFloat) -> Self {
        CGSize(width: max(self.width, with), height: self.height)
    }
    
    func maxHeight(with: CGFloat) -> Self {
        CGSize(width: self.width, height: max(self.height, with))
    }
    
    func with(height: CGFloat) -> Self {
        CGSize(width: self.width, height: height)
    }
    
    func with(width: CGFloat) -> Self {
        CGSize(width: width, height: self.height)
    }
    
    func bounded(by: CGSize) -> Self {
        CGSize(width: min(self.width, by.width), height: min(self.height, by.height))
    }
    
    func minSize(with: CGSize) -> Self {
        CGSize(
            width: min(self.width, with.width),
            height: min(self.height, with.height))
    }
    
    func maxSize(with: CGSize) -> Self {
        CGSize(
            width: max(self.width, with.width),
            height: max(self.height, with.height))
    }
    
    var aui_normalized: CGSize {
        CGSize(
            width: self.width.rounded(.up),
            height: self.height.rounded(.up))
    }
    
    var aui_removingNegativeSize: CGSize {
        CGSize(
            width: max(width, 0),
            height: max(height, 0)
        )
    }
}

extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> Self {
        UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }

    static func horizontal(_ horizontal: CGFloat) -> Self {
        .zero.horizontal(horizontal)
    }
    
    func horizontal(_ horizontal: CGFloat) -> Self {
        UIEdgeInsets(top: self.top, left: horizontal, bottom: self.bottom, right: horizontal)
    }
    
    static func vertical(_ vartical: CGFloat) -> Self {
        .zero.vertical(vartical)
    }

    func vertical(_ vartical: CGFloat) -> Self {
        UIEdgeInsets(top: vartical, left: self.left, bottom: vartical, right: self.right)
    }

    func with(top: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil) -> Self {
        UIEdgeInsets(
            top: top ?? self.top,
            left: left ?? self.left,
            bottom: bottom ?? self.bottom,
            right: right ?? self.right
        )
    }
    
    static func left(_ left: CGFloat) -> Self {
        .zero.left(left)
    }
    
    static func right(_ right: CGFloat) -> Self {
        .zero.right(right)
    }
    
    static func top(_ top: CGFloat) -> Self {
        .zero.top(top)
    }
    
    static func bottom(_ bottom: CGFloat) -> Self {
        .zero.bottom(bottom)
    }
    
    func left(_ left: CGFloat) -> Self {
        UIEdgeInsets(top: self.top, left: left, bottom: self.bottom, right: self.right)
    }
    
    func right(_ right: CGFloat) -> Self {
        UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: right)
    }
    
    func top(_ top: CGFloat) -> Self {
        UIEdgeInsets(top: top, left: self.left, bottom: self.bottom, right: self.right)
    }
    
    func bottom(_ bottom: CGFloat) -> Self {
        UIEdgeInsets(top: self.top, left: self.left, bottom: bottom, right: self.right)
    }
    
    var flipped: Self {
        UIEdgeInsets(top: -self.top, left: -self.left, bottom: -self.bottom, right: -self.right)
    }
    
    var verticalValue: CGFloat { self.top + self.bottom }
    
    var horizontalValue: CGFloat { self.left + self.right }
    
    func inset(by: UIEdgeInsets) -> Self {
        UIEdgeInsets(
            top: self.top + by.top,
            left: self.left + by.left,
            bottom: self.bottom + by.bottom,
            right: self.right + by.right)
    }
    
    var directionalEdgeInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(
            top: self.top,
            leading: self.left,
            bottom: self.bottom,
            trailing: self.right)
    }
}

extension UIColor {
    /// Цвет от hex значения, пример UIColor(hexValue: 0xFFFFFF)
    /// - Parameter hexValue: цвет в x16 формате 0xFFFFFF
    /// - Description: UIColor(hexValue: 0xFFFFFF)
    convenience init(hexValue: UInt32) {
        let red: CGFloat = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(hexValue & 0x000000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(light: UIColor, dark: UIColor){
        self.init { trait in
            if case .dark = trait.userInterfaceStyle {
                return dark
            }
            return light
        }
    }
}

public extension Int {
    var toString: String {
        String(self)
    }
    
    var align: CGFloat {
        CGFloat(self) * UIScreen.main.bounds.width / CGFloat(375.0)
    }
    
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var toDouble: Double { Double(self) }
    
    var toUIInt16: UInt16 { UInt16(self) }
    
    var toFloat: CGFloat { CGFloat(self) }
}

public extension Double {
    var toString: String {
        String(self)
    }
    var toFloat: Float {
        Float(self)
    }
    var align: CGFloat {
        CGFloat(self) * UIScreen.main.bounds.width / CGFloat(375.0)
    }
}

public extension CGFloat {
    var toFloat: Float {
        Float(self)
    }
    
    var toString: String {
        String(Double(self))
    }
}

public extension Float {
    var toString: String {
        String(self)
    }
    
    var toInt: Int {
        Int(self)
    }
}

public extension String {
    var toInt: Int {
        Int(self) ?? 0
    }
    
    var toDouble: Double {
        Double(self) ?? 0
    }
}

extension Result {
    var successOrNil: Success? {
        if case .success(let result) = self {
            return result
        }
        return nil
    }
    var errorOrNil: Failure? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
    var isSuccess: Bool {
        if case .success(_) = self {
            return true
        }
        return false
    }
}

extension UIView {
    func applySantaGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor(hexValue: 0xFF767C).cgColor,
            UIColor(hexValue: 0xAB1219).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1.0) 
        
        layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    convenience init(color: UIColor = .clear, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.init()
        self.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
        size(width: width, height: height)
    }

    convenience init(color: UIColor = .clear, size: CGSize) {
        self.init()
        self.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
        self.size(size)
    }

    func addSubview(_ subview: UIView, insets: UIEdgeInsets) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func wrappedInContainer(insets: UIEdgeInsets = .zero) -> UIView {
        let container = UIView()
        container.addSubview(self, insets: insets)
        return container
    }

    @discardableResult
    func size(_ size: CGSize) -> Self {
        self.size(width: size.width, height: size.height)
        return self
    }

    @discardableResult
    func size(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints(false)
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return self
    }

    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ translates: Bool) -> Self {
        translatesAutoresizingMaskIntoConstraints = translates
        return self
    }
    
    @discardableResult
    func with(userInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = userInteractionEnabled
        return self
    }

    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func alpha(_ opacity: CGFloat) -> Self {
        alpha = opacity
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }

    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        return self
    }

    @discardableResult
    func isHidden(_ value: Bool) -> Self {
        isHidden = value
        return self
    }
    
    @discardableResult
    func clipsToBounds(_ clips: Bool = true) -> Self {
        clipsToBounds = clips
        return self
    }

    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
}
