// Created by AliveBe on 15.02.2024.

import UIKit


extension UIImage.aui {
    static func submitButtonImage(
        size: CGSize = CGSize(width: 190, height: 52),
        color: UIColor = UIColor(hexValue: 0xFFDC7C),
        cornerRadius:CGFloat? = nil
    ) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let corner = cornerRadius ?? size.height / 2.0
        let gradientColor = color
        let gradientColor2 = gradientColor
        let gradient = CGGradient(
            colorsSpace: nil,
            colors: [gradientColor.cgColor, gradientColor2.cgColor] as CFArray,
            locations: [0, 1])!
        
        let rectanglePath = UIBezierPath(
            roundedRect: CGRect( origin: .zero, size: size).insetBy(dx: 2, dy: 2),
            cornerRadius: corner)
        context.saveGState()
        rectanglePath.addClip()
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: size.height),
            end: CGPoint(x: size.width, y: 0),
            options: [])
        context.restoreGState()
        
        let resultImage =  UIGraphicsGetImageFromCurrentImageContext()!
        return resultImage.resizableImage(
            withCapInsets: UIEdgeInsets(
                top: corner, left: corner,
                bottom: corner, right: corner
            ), resizingMode: .stretch
        )
    }
    
    static func borderImage(
        size: CGSize,
        backgroundColor: UIColor,
        cornerRadius: CGFloat,
        borderColor: UIColor,
        borderWidth: CGFloat = 1
    ) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//        let context = UIGraphicsGetCurrentContext()!
        
        let rectanglePath = UIBezierPath(
            roundedRect: .zero.with(size: size).inset(by: .all(borderWidth)),
            cornerRadius: cornerRadius)
        
        backgroundColor.setFill()
        rectanglePath.fill()
        
        borderColor.setStroke()
        rectanglePath.lineWidth = borderWidth
        rectanglePath.stroke()
        
        let resultImage =  UIGraphicsGetImageFromCurrentImageContext()!
        let cornderInset = cornerRadius + borderWidth
        return resultImage.resizableImage(
            withCapInsets: UIEdgeInsets(
                top: cornderInset, left: cornderInset,
                bottom: cornderInset, right: cornderInset
            ), resizingMode: .stretch
        )
    }
    
    static func infoButtonImage(size: CGSize = CGSize(width: 16, height: 16)) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        makeContextResizeable(
            context: context,
            size: CGSize(width: 16, height: 16),
            intoSize: size)
        let fillColor = #colorLiteral(red: 0.953, green: 0.953, blue: 0.953, alpha: 1.000)
        let fillColor2 = #colorLiteral(red: 0.478, green: 0.478, blue: 0.478, alpha: 1.000)

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 16, height: 16))
        fillColor.setFill()
        ovalPath.fill()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 8, y: 5))
        bezierPath.addCurve(
            to: CGPoint(x: 9, y: 4),
            controlPoint1: CGPoint(x: 8.55, y: 5),
            controlPoint2: CGPoint(x: 9, y: 4.55))
        bezierPath.addCurve(
            to: CGPoint(x: 8, y: 3),
            controlPoint1: CGPoint(x: 9, y: 3.45),
            controlPoint2: CGPoint(x: 8.55, y: 3))
        bezierPath.addCurve(
            to: CGPoint(x: 7, y: 4),
            controlPoint1: CGPoint(x: 7.45, y: 3),
            controlPoint2: CGPoint(x: 7, y: 3.45))
        bezierPath.addCurve(
            to: CGPoint(x: 8, y: 5),
            controlPoint1: CGPoint(x: 7, y: 4.55),
            controlPoint2: CGPoint(x: 7.45, y: 5))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 8, y: 6))
        bezierPath.addCurve(
            to: CGPoint(x: 7, y: 7),
            controlPoint1: CGPoint(x: 7.45, y: 6),
            controlPoint2: CGPoint(x: 7, y: 6.45))
        bezierPath.addLine(to: CGPoint(x: 7, y: 12))
        bezierPath.addCurve(
            to: CGPoint(x: 8, y: 13),
            controlPoint1: CGPoint(x: 7, y: 12.55),
            controlPoint2: CGPoint(x: 7.45, y: 13))
        bezierPath.addCurve(
            to: CGPoint(x: 9, y: 12),
            controlPoint1: CGPoint(x: 8.55, y: 13),
            controlPoint2: CGPoint(x: 9, y: 12.55))
        bezierPath.addLine(to: CGPoint(x: 9, y: 7))
        bezierPath.addCurve(
            to: CGPoint(x: 8, y: 6),
            controlPoint1: CGPoint(x: 9, y: 6.45),
            controlPoint2: CGPoint(x: 8.55, y: 6))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor2.setFill()
        bezierPath.fill()

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func popupCloseSmallButtonImage(size: CGSize = CGSize(width: 10, height: 10)) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        makeContextResizeable(
            context: context,
            size: CGSize(width: 10, height: 10),
            intoSize: size)
        let fillColor3 = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1.000)
        context.saveGState()
        context.setAlpha(0.3)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 8.56, y: 1.44))
        bezierPath.addCurve(
            to: CGPoint(x: 6.98, y: 1.44),
            controlPoint1: CGPoint(x: 8.12, y: 1),
            controlPoint2: CGPoint(x: 7.42, y: 1))
        bezierPath.addLine(to: CGPoint(x: 5, y: 3.42))
        bezierPath.addLine(to: CGPoint(x: 3.02, y: 1.44))
        bezierPath.addCurve(
            to: CGPoint(x: 1.44, y: 1.44),
            controlPoint1: CGPoint(x: 2.58, y: 1),
            controlPoint2: CGPoint(x: 1.88, y: 1))
        bezierPath.addCurve(
            to: CGPoint(x: 1.44, y: 3.02),
            controlPoint1: CGPoint(x: 1, y: 1.88),
            controlPoint2: CGPoint(x: 1, y: 2.59))
        bezierPath.addLine(to: CGPoint(x: 3.42, y: 5))
        bezierPath.addLine(to: CGPoint(x: 1.44, y: 6.98))
        bezierPath.addCurve(
            to: CGPoint(x: 1.44, y: 8.56),
            controlPoint1: CGPoint(x: 1, y: 7.42),
            controlPoint2: CGPoint(x: 1, y: 8.12))
        bezierPath.addCurve(
            to: CGPoint(x: 3.02, y: 8.56),
            controlPoint1: CGPoint(x: 1.88, y: 9),
            controlPoint2: CGPoint(x: 2.58, y: 9))
        bezierPath.addLine(to: CGPoint(x: 5, y: 6.58))
        bezierPath.addLine(to: CGPoint(x: 6.98, y: 8.56))
        bezierPath.addCurve(
            to: CGPoint(x: 8.56, y: 8.56),
            controlPoint1: CGPoint(x: 7.41, y: 9),
            controlPoint2: CGPoint(x: 8.12, y: 9))
        bezierPath.addCurve(
            to: CGPoint(x: 8.56, y: 6.98),
            controlPoint1: CGPoint(x: 9, y: 8.12),
            controlPoint2: CGPoint(x: 9, y: 7.42))
        bezierPath.addLine(to: CGPoint(x: 6.58, y: 5))
        bezierPath.addLine(to: CGPoint(x: 8.56, y: 3.02))
        bezierPath.addCurve(
            to: CGPoint(x: 8.56, y: 1.44),
            controlPoint1: CGPoint(x: 9, y: 2.58),
            controlPoint2: CGPoint(x: 9, y: 1.88))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor3.setFill()
        bezierPath.fill()

        context.restoreGState()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func downArrowImage(size: CGSize = CGSize(width: 14, height: 7), color: UIColor = .white) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        makeContextResizeable(
            context: context,
            size: CGSize(width: 14, height: 7),
            intoSize: size)
        
        context.saveGState()

        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 0, y: 0))
        polygonPath.addLine(to: CGPoint(x: 14, y: 0))
        polygonPath.addLine(to: CGPoint(x: 7, y: 7))
        polygonPath.close()
        color.setFill()
        polygonPath.fill()
        context.restoreGState()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func leftArrowButtonImage(size: CGSize = CGSize(width: 24, height: 24)) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        makeContextResizeable(
            context: context,
            size: CGSize(width: 24, height: 24),
            intoSize: size)

        //// Color Declarations
        let fillColor3 = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1.000)

        //// Group
        context.saveGState()
        context.setAlpha(0.6)
        context.beginTransparencyLayer(auxiliaryInfo: nil)


        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 19, y: 11))
        bezierPath.addLine(to: CGPoint(x: 7.13, y: 11))
        bezierPath.addLine(to: CGPoint(x: 10.77, y: 6.64))
        bezierPath.addCurve(
            to: CGPoint(x: 10.64, y: 5.23),
            controlPoint1: CGPoint(x: 11.12, y: 6.22),
            controlPoint2: CGPoint(x: 11.06, y: 5.58))
        bezierPath.addCurve(
            to: CGPoint(x: 9.23, y: 5.36),
            controlPoint1: CGPoint(x: 10.21, y: 4.88),
            controlPoint2: CGPoint(x: 9.59, y: 4.94))
        bezierPath.addLine(to: CGPoint(x: 4.23, y: 11.36))
        bezierPath.addCurve(
            to: CGPoint(x: 4.14, y: 11.51),
            controlPoint1: CGPoint(x: 4.19, y: 11.41),
            controlPoint2: CGPoint(x: 4.17, y: 11.46))
        bezierPath.addCurve(
            to: CGPoint(x: 4.07, y: 11.64),
            controlPoint1: CGPoint(x: 4.12, y: 11.56),
            controlPoint2: CGPoint(x: 4.09, y: 11.59))
        bezierPath.addCurve(
            to: CGPoint(x: 4, y: 12),
            controlPoint1: CGPoint(x: 4.03, y: 11.75),
            controlPoint2: CGPoint(x: 4, y: 11.87))
        bezierPath.addLine(to: CGPoint(x: 4, y: 12))
        bezierPath.addLine(to: CGPoint(x: 4, y: 12))
        bezierPath.addCurve(
            to: CGPoint(x: 4.07, y: 12.36),
            controlPoint1: CGPoint(x: 4, y: 12.13),
            controlPoint2: CGPoint(x: 4.03, y: 12.25))
        bezierPath.addCurve(
            to: CGPoint(x: 4.14, y: 12.49),
            controlPoint1: CGPoint(x: 4.09, y: 12.41),
            controlPoint2: CGPoint(x: 4.12, y: 12.44))
        bezierPath.addCurve(
            to: CGPoint(x: 4.23, y: 12.64),
            controlPoint1: CGPoint(x: 4.17, y: 12.54),
            controlPoint2: CGPoint(x: 4.19, y: 12.59))
        bezierPath.addLine(to: CGPoint(x: 9.23, y: 18.64))
        bezierPath.addCurve(
            to: CGPoint(x: 10, y: 19),
            controlPoint1: CGPoint(x: 9.43, y: 18.88),
            controlPoint2: CGPoint(x: 9.71, y: 19))
        bezierPath.addCurve(
            to: CGPoint(x: 10.64, y: 18.77),
            controlPoint1: CGPoint(x: 10.23, y: 19),
            controlPoint2: CGPoint(x: 10.45, y: 18.92))
        bezierPath.addCurve(
            to: CGPoint(x: 10.77, y: 17.36),
            controlPoint1: CGPoint(x: 11.06, y: 18.41),
            controlPoint2: CGPoint(x: 11.12, y: 17.78))
        bezierPath.addLine(to: CGPoint(x: 7.13, y: 13))
        bezierPath.addLine(to: CGPoint(x: 19, y: 13))
        bezierPath.addCurve(
            to: CGPoint(x: 20, y: 12),
            controlPoint1: CGPoint(x: 19.55, y: 13),
            controlPoint2: CGPoint(x: 20, y: 12.55))
        bezierPath.addCurve(
            to: CGPoint(x: 19, y: 11),
            controlPoint1: CGPoint(x: 20, y: 11.45),
            controlPoint2: CGPoint(x: 19.55, y: 11))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor3.setFill()
        bezierPath.fill()


        context.endTransparencyLayer()
        context.restoreGState()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    static func rightArrowButtonImage(size: CGSize = CGSize(width: 24, height: 24)) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        makeContextResizeable(
            context: context,
            size: CGSize(width: 24, height: 24),
            intoSize: size)
        let fillColor3 = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1.000)
        context.saveGState()
        context.setAlpha(0.6)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 5, y: 13))
        bezierPath.addLine(to: CGPoint(x: 16.86, y: 13))
        bezierPath.addLine(to: CGPoint(x: 13.23, y: 17.36))
        bezierPath.addCurve(
            to: CGPoint(x: 13.36, y: 18.77),
            controlPoint1: CGPoint(x: 12.88, y: 17.78),
            controlPoint2: CGPoint(x: 12.94, y: 18.41))
        bezierPath.addCurve(
            to: CGPoint(x: 14.77, y: 18.64),
            controlPoint1: CGPoint(x: 13.79, y: 19.12),
            controlPoint2: CGPoint(x: 14.41, y: 19.06))
        bezierPath.addLine(to: CGPoint(x: 19.77, y: 12.64))
        bezierPath.addCurve(
            to: CGPoint(x: 19.86, y: 12.49),
            controlPoint1: CGPoint(x: 19.81, y: 12.59),
            controlPoint2: CGPoint(x: 19.83, y: 12.54))
        bezierPath.addCurve(
            to: CGPoint(x: 19.93, y: 12.36),
            controlPoint1: CGPoint(x: 19.88, y: 12.44),
            controlPoint2: CGPoint(x: 19.91, y: 12.41))
        bezierPath.addCurve(
            to: CGPoint(x: 20, y: 12),
            controlPoint1: CGPoint(x: 19.97, y: 12.25),
            controlPoint2: CGPoint(x: 20, y: 12.13))
        bezierPath.addLine(to: CGPoint(x: 20, y: 12))
        bezierPath.addLine(to: CGPoint(x: 20, y: 12))
        bezierPath.addCurve(
            to: CGPoint(x: 19.93, y: 11.64),
            controlPoint1: CGPoint(x: 20, y: 11.87),
            controlPoint2: CGPoint(x: 19.97, y: 11.75))
        bezierPath.addCurve(
            to: CGPoint(x: 19.86, y: 11.51),
            controlPoint1: CGPoint(x: 19.91, y: 11.59),
            controlPoint2: CGPoint(x: 19.88, y: 11.56))
        bezierPath.addCurve(
            to: CGPoint(x: 19.77, y: 11.36),
            controlPoint1: CGPoint(x: 19.83, y: 11.46),
            controlPoint2: CGPoint(x: 19.81, y: 11.41))
        bezierPath.addLine(to: CGPoint(x: 14.77, y: 5.36))
        bezierPath.addCurve(
            to: CGPoint(x: 14, y: 5),
            controlPoint1: CGPoint(x: 14.57, y: 5.12),
            controlPoint2: CGPoint(x: 14.29, y: 5))
        bezierPath.addCurve(
            to: CGPoint(x: 13.36, y: 5.23),
            controlPoint1: CGPoint(x: 13.77, y: 5),
            controlPoint2: CGPoint(x: 13.55, y: 5.08))
        bezierPath.addCurve(
            to: CGPoint(x: 13.23, y: 6.64),
            controlPoint1: CGPoint(x: 12.94, y: 5.58),
            controlPoint2: CGPoint(x: 12.88, y: 6.22))
        bezierPath.addLine(to: CGPoint(x: 16.86, y: 11))
        bezierPath.addLine(to: CGPoint(x: 5, y: 11))
        bezierPath.addCurve(
            to: CGPoint(x: 4, y: 12),
            controlPoint1: CGPoint(x: 4.45, y: 11),
            controlPoint2: CGPoint(x: 4, y: 11.45))
        bezierPath.addCurve(
            to: CGPoint(x: 5, y: 13),
            controlPoint1: CGPoint(x: 4, y: 12.55),
            controlPoint2: CGPoint(x: 4.45, y: 13))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor3.setFill()
        bezierPath.fill()
        context.endTransparencyLayer()
        context.restoreGState()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
