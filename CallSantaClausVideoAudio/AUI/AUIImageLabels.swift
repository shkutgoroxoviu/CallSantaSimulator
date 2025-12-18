// Created by AliveBe on 15.02.2024.

import UIKit

extension UIImage.aui {
    static func infoImageLabel(size: CGSize = CGSize(width: 24, height: 24)) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        makeContextResizeable(
            context: context,
            size: CGSize(width: 24, height: 24),
            intoSize: size)

        let fillColor4 = UIColor(red: 0.204, green: 0.824, blue: 0.451, alpha: 1.000)

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 11, y: 8))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 7),
            controlPoint1: CGPoint(x: 11, y: 7.45),
            controlPoint2: CGPoint(x: 11.45, y: 7))
        bezierPath.addCurve(
            to: CGPoint(x: 13, y: 8),
            controlPoint1: CGPoint(x: 12.55, y: 7),
            controlPoint2: CGPoint(x: 13, y: 7.45))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 9),
            controlPoint1: CGPoint(x: 13, y: 8.55),
            controlPoint2: CGPoint(x: 12.55, y: 9))
        bezierPath.addCurve(
            to: CGPoint(x: 11, y: 8),
            controlPoint1: CGPoint(x: 11.45, y: 9),
            controlPoint2: CGPoint(x: 11, y: 8.55))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 11, y: 11))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 10),
            controlPoint1: CGPoint(x: 11, y: 10.45),
            controlPoint2: CGPoint(x: 11.45, y: 10))
        bezierPath.addCurve(
            to: CGPoint(x: 13, y: 11),
            controlPoint1: CGPoint(x: 12.55, y: 10),
            controlPoint2: CGPoint(x: 13, y: 10.45))
        bezierPath.addLine(to: CGPoint(x: 13, y: 16))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 17),
            controlPoint1: CGPoint(x: 13, y: 16.55),
            controlPoint2: CGPoint(x: 12.55, y: 17))
        bezierPath.addCurve(
            to: CGPoint(x: 11, y: 16),
            controlPoint1: CGPoint(x: 11.45, y: 17),
            controlPoint2: CGPoint(x: 11, y: 16.55))
        bezierPath.addLine(to: CGPoint(x: 11, y: 11))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 12, y: 20))
        bezierPath.addCurve(
            to: CGPoint(x: 4, y: 12),
            controlPoint1: CGPoint(x: 7.59, y: 20),
            controlPoint2: CGPoint(x: 4, y: 16.41))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 4),
            controlPoint1: CGPoint(x: 4, y: 7.59),
            controlPoint2: CGPoint(x: 7.59, y: 4))
        bezierPath.addCurve(
            to: CGPoint(x: 20, y: 12),
            controlPoint1: CGPoint(x: 16.41, y: 4),
            controlPoint2: CGPoint(x: 20, y: 7.59))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 20),
            controlPoint1: CGPoint(x: 20, y: 16.41),
            controlPoint2: CGPoint(x: 16.41, y: 20))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 12, y: 2))
        bezierPath.addCurve(
            to: CGPoint(x: 2, y: 12),
            controlPoint1: CGPoint(x: 6.48, y: 2),
            controlPoint2: CGPoint(x: 2, y: 6.48))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 22),
            controlPoint1: CGPoint(x: 2, y: 17.52),
            controlPoint2: CGPoint(x: 6.48, y: 22))
        bezierPath.addCurve(
            to: CGPoint(x: 22, y: 12),
            controlPoint1: CGPoint(x: 17.52, y: 22),
            controlPoint2: CGPoint(x: 22, y: 17.52))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: 2),
            controlPoint1: CGPoint(x: 22, y: 6.48),
            controlPoint2: CGPoint(x: 17.52, y: 2))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor4.setFill()
        bezierPath.fill()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
