// Created by AliveBe on 24.07.2025.

import UIKit
import ObjectiveC

extension UIView {
    private static var shimmerKey: UInt8 = 0
    
    var shimmerIsActive: Bool {
        return shimmerOverlayView != nil
    }
    
    private var shimmerOverlayView: UIView? {
        get { objc_getAssociatedObject(self, &UIView.shimmerKey) as? UIView }
        set { objc_setAssociatedObject(self, &UIView.shimmerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func startShimmering() {
        // Уже активен shimmer
        if shimmerOverlayView != nil { return }
        
        // Проверка на корректный размер
        guard bounds.width > 0 && bounds.height > 0 else {
            print("⚠️ Skip shimmer: frame is .zero")
            return
        }
        
        let overlay = UIView(frame: bounds)
        overlay.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        overlay.layer.cornerRadius = layer.cornerRadius
        overlay.clipsToBounds = true
        overlay.isUserInteractionEnabled = false
        
        let gradient = CAGradientLayer()
        gradient.frame = overlay.bounds
        gradient.cornerRadius = overlay.layer.cornerRadius
        
        let light = UIColor(white: 1.0, alpha: 0.9).cgColor
        let dark = UIColor(white: 0.85, alpha: 1.0).cgColor
        
        gradient.colors = [dark, light, dark]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.0, 0.5, 1.0]
        
        overlay.layer.addSublayer(gradient)
        addSubview(overlay)
        bringSubviewToFront(overlay)
        shimmerOverlayView = overlay
        
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = [-1.0, -0.5, 0.0]
        anim.toValue = [1.0, 1.5, 2.0]
        anim.duration = 1.2
        anim.repeatCount = .infinity
        
        gradient.add(anim, forKey: "shimmerAnimation")
    }
    
    func stopShimmering() {
        print("❗️Trying to stop shimmer on \(self)")
        shimmerOverlayView?.removeFromSuperview()
        shimmerOverlayView = nil
    }
}
