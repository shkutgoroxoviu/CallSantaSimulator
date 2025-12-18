// Created by AliveBe on 04.12.2023.

import UIKit

@resultBuilder struct AUIBuilder {
    static func buildBlock(_ views: UIView...) -> [UIView] { views }
}

extension AUI {
    class BaseView: UIView, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var aui_borderColor: UIColor?
        
        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size.inset(by: padding)).inset(by: padding.flipped)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
                
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        func setup() {
            
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
    
    class LeftRightView: AUI.BaseView {
        var spacing: CGFloat = 0
        
        var leftView: UIView? {
            didSet {
                if oldValue?.superview == self {
                    oldValue?.removeFromSuperview()
                }
                guard let leftView else { return }
                addSubview(leftView)
            }
        }
        
        var rightView: UIView? {
            didSet {
                if oldValue?.superview == self {
                    oldValue?.removeFromSuperview()
                }
                guard let rightView else { return }
                addSubview(rightView)
            }
        }
        
        func with(spacing: CGFloat) -> Self {
            self.spacing = spacing
            return self
        }
        
        @discardableResult
        func with(rightView: UIView?) -> Self {
            self.rightView = rightView
            return self
        }
        
        @discardableResult
        func with(leftView: UIView?) -> Self {
            self.leftView = leftView
            return self
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var safeSize = size.inset(by: padding)
            let rightSize = rightView?.aui_size(thatFitSize: safeSize) ?? .zero
            safeSize.width -= rightSize.width + spacing + (rightView?.aui_margin.horizontalValue ?? 0)
            let leftSize = leftView?.aui_size(thatFitSize: safeSize) ?? .zero
            return CGSize(
                width: leftSize.width + rightSize.width + padding.horizontalValue + spacing,
                height: max(leftSize.height, rightSize.height) + padding.verticalValue)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            var safeBounds = bounds.inset(by: padding)
            guard let rightView, !(rightView.isHidden || rightView.aui_packHidden) else {
                leftView?.frame = leftView?.aui_frame(inBounds: safeBounds) ?? .zero
                leftView?.layoutSubviews()
                rightView?.layoutSubviews()
                return
            }
            var rightFrame = rightView.aui_frame(inBounds: safeBounds)
            rightFrame.origin.x = safeBounds.maxX - rightFrame.width - rightView.aui_margin.right
            rightView.frame = rightFrame
            safeBounds.width -= rightFrame.width + spacing + rightView.aui_margin.horizontalValue
            leftView?.frame = leftView?.aui_frame(inBounds: safeBounds) ?? .zero
            leftView?.layoutSubviews()
            rightView.layoutSubviews()
        }
    }

    class PaddingView: BaseView {
        var containerView: UIView? = nil {
            willSet {
                containerView?.removeFromSuperview()
            }
            didSet {
                self.aui_addSubview(containerView)
            }
        }
        
        @discardableResult func container(view: UIView?) -> Self {
            self.containerView = view
            return self
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            containerView?.aui_size(thatFitSize: size.inset(by: padding)).inset(by: padding.flipped) ?? .zero
        }
        
        func with(view: UIView) -> Self {
            self.containerView = view
            return self
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            containerView?.frame = containerView?.aui_frame(inBounds: bounds.inset(by: padding)) ?? .zero
            containerView?.layoutSubviews()
        }
    }
    
    class VerticalView: AUI.BaseView, AUICollection {
        var views: [UIView] = [] {
            willSet {
                aui_configureVerticalNewViews(newValue, forView: self)
                views.forEach { $0.removeFromSuperview() }
                newValue.forEach { self.addSubview($0) }
            }
            didSet {
                setNeedsLayout()
            }
        }
        
        var spacing: CGFloat? = 0 { didSet { setNeedsLayout() } }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = aui_verticalSize(inSize: size)
            if let estimatedHeight {
                result.height = estimatedHeight
            }
            if let estimatedWidth {
                result.width = estimatedWidth
            }
            return result
        }
                
        override func layoutSubviews() {
            super.layoutSubviews()
            aui_verticalLayout(inBounds: bounds.inset(by: padding))
        }
    }
    
    class ActivityIndicatorView: UIActivityIndicatorView, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .center
        var estimatedHeight: CGFloat?
        var estimatedWidth: CGFloat?
        var aui_borderColor: UIColor?
        
        @discardableResult
        func aui_startAnimating() -> Self {
            startAnimating()
            return self
        }
        
        @discardableResult
        func with(style: UIActivityIndicatorView.Style) -> Self {
            self.style = style
            return self
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
    
    class Grid2ColumsView: AUI.BaseView, AUICollection {
        enum Flow {
            case flex, grid
        }
        
        var views: [UIView] = [] {
            willSet {
                views.forEach { $0.removeFromSuperview() }
                newValue.forEach { self.addSubview($0) }
            }
            didSet {
                setNeedsLayout()
            }
        }
        
        var flow: Flow = .flex { didSet { setNeedsLayout() } }
        
        @discardableResult func with(flow: Flow) -> Self {
            self.flow = flow
            return self
        }

        var spacing: CGFloat? = 0 { didSet { setNeedsLayout() } }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            if case .flex = flow {
                return aui_grid2ColumnFlexSize(inSize: size)
            }
            return aui_grid2ColumnGridSize(inSize: size)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            switch flow {
            case .flex:
                aui_twoColumnFlexLayout(inBounds: bounds.inset(by: padding))
            case .grid:
                aui_twoColumnGridLayout(inBounds: bounds)
            }
            
        }
    }

    class HorizontalFlowView: AUI.BaseView, AUICollection {
        var views: [UIView] = [] {
            willSet {
                views.forEach { $0.removeFromSuperview() }
                newValue.forEach { self.addSubview($0) }
                var lastPosition: CGPoint = .zero
                for newView in newValue {
                    if newView.frame.origin.x <= lastPosition.x, newView.frame.origin.y <= lastPosition.y {
                        newView.frame = newView.frame.with(x: lastPosition.x).with(y: lastPosition.y)
                    }
                    self.addSubview(newView)
                    lastPosition = CGPoint(x: newView.frame.maxX, y: newView.frame.origin.y)
                }
            }
            didSet {
                setNeedsLayout()
            }
        }

        var spacing: CGFloat? = 0 { didSet { setNeedsLayout() } }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let contentBounds = size.inset(by: padding)
            var rowHeight: CGFloat = 0
            var rowWidth: CGFloat = 0
            var rowViewsSizes: [CGSize] = []
            var maxRowWidth: CGFloat = 0
            let spacing = spacing ?? 0
            for view in views where !view.aui_hidden {
                let viewSize = view.aui_size(thatFitSize: contentBounds)
                if viewSize.width + rowWidth > contentBounds.width {
                    rowHeight += spacing + (rowViewsSizes.map(\.height).max() ?? 0)
                    maxRowWidth = max(maxRowWidth, rowWidth)
                    rowWidth = 0
                    rowViewsSizes = []
                }
                rowViewsSizes.append(viewSize)
                rowWidth += viewSize.width + spacing
            }
            if rowViewsSizes.count > 0 {
                rowHeight += spacing + (rowViewsSizes.map(\.height).max() ?? 0)
                maxRowWidth = max(maxRowWidth, rowWidth)
            }
            return CGSize(
                width: maxRowWidth + padding.left + padding.right,
                height: rowHeight + padding.top + padding.bottom)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let contentBounds = bounds.inset(by: padding)
            var rowHeight: CGFloat = contentBounds.minY
            var rowWidth: CGFloat = contentBounds.minX
            var rowViewBoxes: [CGRect] = []
            let spacing = spacing ?? 0
            for view in views where !view.aui_hidden {
                var viewFrame = view.aui_frame(inBounds: contentBounds.with(x: 0))
                let viewMargin = view.aui_margin
                if viewFrame.maxX + rowWidth > contentBounds.maxX {
                    rowHeight = spacing + (rowViewBoxes.map(\.maxY).max() ?? 0)
                    rowWidth = contentBounds.minX
                    rowViewBoxes = []
                }
                viewFrame = viewFrame
                    .with(x: rowWidth + viewMargin.left)
                    .with(y: rowHeight + viewMargin.top)
                view.frame = viewFrame
                let viewFrameBox = viewFrame.inset(by: viewMargin.flipped)
                rowViewBoxes.append(viewFrameBox)
                rowWidth = viewFrameBox.maxX + spacing
            }
        }
    }
    
    class HorizontalView: BaseView, AUICollection {
        var views: [UIView] = [] {
            didSet {
                for oldView in oldValue where oldView.superview != self{
                    oldView.removeFromSuperview()
                }
                aui_configureHorizontallNewViews(views, forView: self)
                for view in views {
                    addSubview(view)
                }
            }
        }
        var spacing: CGFloat?
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = aui_horizontalSize(inSize: size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            aui_horizontalLayout(inBounds: bounds.inset(by: padding))
        }
        
//        override func sizeThatFits(_ size: CGSize) -> CGSize {
//            let spacing = spacing ?? 0
//            var safeBounds = size.inset(by: padding)
//            var resultHeight: CGFloat = 0
//            var resultWidth: CGFloat = 0
//            for view in views {
//                if view.isHidden || view.aui_packHidden { continue }
//                let viewMargin = view.aui_margin
//                let viewSize = view.sizeThatFits(safeBounds.inset(by: viewMargin))
//                
//                let viewWidth = viewSize.width + spacing + viewMargin.horizontalValue
//                let viewHeght = viewSize.height + viewMargin.verticalValue
//                
//                safeBounds.width -= viewWidth
//                resultWidth += viewWidth
//                resultHeight = max(resultHeight, viewHeght)
//            }
//            return CGSize(
//                width: resultWidth,
//                height: resultHeight).inset(by: padding.flipped)
//        }
//        
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            var safeBounds = bounds.inset(by: padding)
//            
//            let elementSpacing: CGFloat
//            if let spacing = spacing {
//                elementSpacing = spacing
//            } else {
//                let estimatedSize = sizeThatFits(safeBounds.size)
//                elementSpacing = safeBounds.width / estimatedSize.width
//            }
//            
//            for view in views {
//                let viewMargin = view.aui_margin
//                let viewFrame = view.aui_frame(inBounds: safeBounds)
//                    .with(x: safeBounds.origin.x + viewMargin.left)
//                if view.isHidden || view.aui_packHidden {
//                    continue
//                }
//                view.frame = viewFrame
//                safeBounds = safeBounds.inset(by: .left(viewFrame.width + viewMargin.horizontalValue + elementSpacing))
//            }
//        }
    }
    
    class EqualHorizontalView: BaseView, AUICollection {
        var views: [UIView] = [] {
            didSet {
                oldValue.removeFromSuperView()
                for view in views {
                    let locationFrame = view.convert(view.bounds, to: self)
                    self.addSubview(view)
                    view.frame = locationFrame
                }
            }
        }
        var spacing: CGFloat?
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var resultSize = super.sizeThatFits(size)
            let spacing = spacing ?? 0
            let safeViews = views.filter { !$0.isHidden }
            let count = safeViews.count.toFloat
            
            var fittingSize = size.inset(by: padding)
            fittingSize.width -= max(spacing * (count - 1), 0)
            fittingSize.width = fittingSize.width / count
            var elementSize = CGSize.zero
            for view in safeViews {
                let viewSize = view.aui_size(thatFitSize: fittingSize)
                elementSize.width = max(elementSize.width, viewSize.width)
                elementSize.height = max(elementSize.height, viewSize.height)
            }
            resultSize.width = elementSize.width * count + max(spacing * (count - 1), 0)
            resultSize.height = elementSize.height
            resultSize.width  = estimatedWidth  ?? resultSize.width
            resultSize.height = estimatedHeight ?? resultSize.height
            return resultSize.inset(by: padding.flipped)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let spacing = self.spacing ?? 0
            let safeViews = views.filter { !$0.isHidden }
            let count = max(safeViews.count, 1).toFloat
            let safeBounds = bounds.inset(by: padding)
            var elementSize = safeBounds.size
            elementSize.width -= max(spacing * (count - 1), 0)
            elementSize.width = elementSize.width / count
            for (idx, view) in safeViews.enumerated() {
                let space = elementSize.width + spacing
                view.frame = CGRect(
                    x: safeBounds.origin.x + (idx.toFloat * space),
                    y: safeBounds.origin.y,
                    size: elementSize)
            }
        }
    }
    
    class ZStackView: BaseView, AUICollection {
        var isLayout: Bool = true
        var views: [UIView] = [] {
            willSet {
                views.forEach { $0.removeFromSuperview() }
                newValue.forEach { self.addSubview($0) }
            }
            didSet {
                layoutSubviews()
            }
        }
        
        var spacing: CGFloat? = 0 {
            didSet {
                setNeedsLayout()
            }
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let inSize = size.inset(by: padding)
            var result: CGSize = views
                .filter { !($0.isHidden || $0.aui_packHidden) }
                .map { $0.aui_size(thatFitSize: inSize) }
                .reduce(.zero) { partialResult, size in
                    CGSize(
                        width: max(partialResult.width, size.width),
                        height: max(partialResult.height, size.height))
                }
            result = result.inset(by: padding.flipped)
            result = CGSize(
                width: estimatedWidth ?? result.width,
                height: estimatedHeight ?? result.height)
            return result
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            guard isLayout else { return }
            let safeBounds = bounds.inset(by: padding)
            for componentView in views {
                let transform = componentView.layer.transform
                componentView.layer.transform = CATransform3DIdentity
                componentView.frame = componentView.aui_frame(inBounds: safeBounds)
                componentView.layer.transform = transform
                componentView.layoutSubviews()
            }
        }
    }
    
    class DashedLineView: AUI.BaseView {
        let shapeLayer = CAShapeLayer()
        
        var color: UIColor = .gray {
            didSet { shapeLayer.strokeColor = color.cgColor }
        }
        
        var lineWidth: CGFloat = 0 {
            didSet { shapeLayer.lineWidth = lineWidth }
        }
        
        func with(color: UIColor) -> Self {
            self.color = color
            return self
        }
        
        func with(lineWidth: CGFloat) -> Self {
            self.lineWidth = lineWidth
            return self
        }
        
        override func setup() {
            super.setup()
            shapeLayer.strokeColor = self.color.cgColor
            shapeLayer.lineWidth = 3
            shapeLayer.lineDashPattern = [2, 4]
            layer.addSublayer(shapeLayer)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let path = CGMutablePath()
            path.addLines(between: [
                bounds.origin,
                CGPoint(x: bounds.maxX, y: bounds.maxY)
            ])
            shapeLayer.path = path
        }
    }
    
    class SeparatorLine: AUI.BaseView {
        override func setup() {
            super.setup()
            horizontalAligment = .fill
            estimatedHeight = 1
            backgroundColor = .lightGray
        }
    }
}

protocol AUICollection: AnyObject {
    var views: [UIView] { get set }
    var spacing: CGFloat? { get set }
}

extension AUICollection {
    @discardableResult func with(views: [UIView]) -> Self {
        self.views = views
        return self
    }
    
    @discardableResult func withViews(@AUIBuilder _ content: () -> [UIView]) -> Self {
        self.views = content()
        return self
    }
    
    @discardableResult func with(spacing: CGFloat?) -> Self {
        self.spacing = spacing
        return self
    }
}

extension AUICollection where Self: UIView {
    func aui_grid2ColumnGridSize(inSize: CGSize) -> CGSize {
        let spacing = spacing ?? 0
        let contentSize = inSize.inset(by: aui_padding)
        let columnWidth = (contentSize.width - spacing) / 2

        let viewSizes = views.compactMap { view -> CGSize? in
            if view.isHidden { return nil }
            return view.aui_size(thatFitSize: contentSize.with(width: columnWidth))
        }
        
        var firstColumnElementSize: CGSize? = nil
        var totalHeight: CGFloat = 0
        for viewSize in viewSizes {
            guard let strongFirstColumnElementSize = firstColumnElementSize else {
                firstColumnElementSize = viewSize
                continue
            }
            totalHeight += max(viewSize.height, strongFirstColumnElementSize.height)
            firstColumnElementSize = nil
        }
        if let firstColumnElementSize {
            totalHeight += firstColumnElementSize.height
        }
        totalHeight += spacing * CGFloat(viewSizes.count / 2)
        return inSize.with(height: totalHeight).inset(by: aui_padding.flipped.horizontal(0))
    }
    
    func aui_twoColumnGridLayout(inBounds: CGRect) {
        let spacing = spacing ?? 0
        let contentBounds = inBounds.inset(by: aui_padding)
        var verticalOffset: CGFloat = contentBounds.origin.y
        let columnWidth = (inBounds.size.width - spacing) / 2
        
        var firstColumnElement: UIView? = nil
        
        for view in views {
            if view.isHidden { continue }
            guard let strongFirstColumnElement = firstColumnElement else {
                firstColumnElement = view
                continue
            }
            let firstColumnSize = strongFirstColumnElement.aui_size(thatFitSize: contentBounds.size.with(width: columnWidth))
            let secondColumnSize = view.aui_size(thatFitSize: contentBounds.size.with(width: columnWidth))
            let rowHeight = max(firstColumnSize.height, secondColumnSize.height)
            strongFirstColumnElement.frame = CGRect(
                x: contentBounds.origin.x + strongFirstColumnElement.aui_margin.left,
                y: verticalOffset + strongFirstColumnElement.aui_margin.top,
                width: columnWidth,
                height: rowHeight - strongFirstColumnElement.aui_margin.top - strongFirstColumnElement.aui_margin.bottom)
            view.frame = CGRect(
                x: contentBounds.maxX - columnWidth - view.aui_margin.right,
                y: verticalOffset + view.aui_margin.top,
                width: columnWidth,
                height: rowHeight - view.aui_margin.top - view.aui_margin.bottom)
            verticalOffset += rowHeight + spacing
            view.layoutSubviews()
            strongFirstColumnElement.layoutSubviews()
            firstColumnElement = nil
        }
        if let firstColumnElement {
            firstColumnElement.frame = firstColumnElement
                .aui_frame(inBounds: contentBounds.with(width: columnWidth))
                .with(x: contentBounds.origin.x + firstColumnElement.aui_margin.left)
                .with(y: verticalOffset + firstColumnElement.aui_margin.top)
                .with(width: columnWidth)
        }
    }
    
    func aui_grid2ColumnFlexSize(inSize: CGSize) -> CGSize {
        let spacing = spacing ?? 0
        let contentSize = inSize.inset(by: aui_padding)
        let columnWidth = (contentSize.width - spacing) / 2

        let viewSizes = views.compactMap { view -> CGSize? in
            if view.isHidden { return nil }
            return view.sizeThatFits(CGSize(width: columnWidth, height: contentSize.height)
                .inset(by: view.aui_margin)).inset(by: view.aui_margin.flipped)
        }

        let numberOfRows = (viewSizes.count + 1) / 2
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        for row in 0..<numberOfRows {
            let firstIndex = row * 2
            let secondIndex = firstIndex + 1
            let firstViewSize = viewSizes[firstIndex]
            let secondViewSize = viewSizes[secondIndex]
            
            let rowHeight = max(firstViewSize.height, secondViewSize.height)
            maxWidth = max(maxWidth, (firstViewSize.width) * 2, (secondViewSize.width) * 2)
            totalHeight += rowHeight + (row > 0 ? spacing : 0)
        }

        return CGSize(
            width: maxWidth,
            height: totalHeight
        ).inset(by: aui_padding.flipped)
    }
    
    func aui_twoColumnFlexLayout(inBounds: CGRect) {
        let spacing = spacing ?? 0
        let columnWidth = (inBounds.size.width - spacing) / 2
        var leftColumnOffsetY: CGFloat = inBounds.origin.y
        var rightColumnOffsetY: CGFloat = inBounds.origin.y
        var isLeftColumn: Bool = true
        
        if inBounds.size.height <= 0 || inBounds.size.width <= 0 {
            return
        }
        
        for view in views {
            // Определяем для какого столбца это view
            let currentOffsetY = isLeftColumn ? leftColumnOffsetY : rightColumnOffsetY
            let originX = isLeftColumn ? inBounds.origin.x : inBounds.origin.x + columnWidth + spacing
            
            view.frame = CGRect(
                x: originX + view.aui_margin.left,
                y: currentOffsetY + view.aui_margin.top,
                width: columnWidth - (view.aui_margin.left + view.aui_margin.right),
                height: view.aui_frame(inBounds: inBounds).height
            )
            
            view.layoutSubviews()
            if view.isHidden { continue }

            // Обновляем позицию для следующего элемента
            if isLeftColumn {
                leftColumnOffsetY = view.frame.maxY + spacing + view.aui_margin.bottom
            } else {
                rightColumnOffsetY = view.frame.maxY + spacing + view.aui_margin.bottom
            }

            // Чередуем между колонками
            isLeftColumn.toggle()
        }
    }
    
    func aui_verticalSize(inSize: CGSize) -> CGSize {
        let spacing = spacing ?? 0
        let viewSizes = views.compactMap { item -> CGSize? in
            if item.isHidden || item.aui_packHidden { return nil }
            return item.sizeThatFits(inSize.inset(by: aui_padding).inset(by: item.aui_margin))
                .inset(by: item.aui_margin.flipped)
        }
        return CGSize(
            width: viewSizes.map { $0.width }.max() ?? 0,
            height: viewSizes.map { $0.height }.sum + spacing * CGFloat(max(viewSizes.count, 1) - 1))
            .inset(by: aui_padding.flipped)
    }
    
    func aui_horizontalSize(inSize: CGSize) -> CGSize {
        let spacing = spacing ?? 0
        var currentSize = inSize.inset(by: aui_padding)
        var viewSizes: [CGSize] = []
        for item in views {
            if item.isHidden || item.aui_packHidden { continue }
            let result = item.sizeThatFits(currentSize.inset(by: item.aui_margin))
                .inset(by: item.aui_margin.flipped)
            viewSizes.append(result)
            currentSize.width -= result.width
        }
        return CGSize(
            width: viewSizes.map { $0.width }.sum + spacing * CGFloat(max(viewSizes.count, 1) - 1),
            height: viewSizes.map { $0.height }.max() ?? 0)
            .inset(by: aui_padding.flipped)
    }
    
    func aui_verticalLayout(inBounds: CGRect) {
        let spacing = aui_verticalSpacing(inBounds: inBounds)
        var offset = inBounds.origin.y
        if inBounds.size.height <= 0 || inBounds.width <= 0 {
            return
        }
        for view in views {
            view.frame = view.aui_frame(inBounds: inBounds).with(y: offset + view.aui_margin.top)
            view.layoutSubviews()
            if view.isHidden || view.aui_packHidden { continue }
            offset = view.frame.maxY + spacing + view.aui_margin.bottom
        }
    }
    
    func aui_configureVerticalNewViews(_ views: [UIView], forView: UIView) {
        let spacing = spacing ?? 0
        var verticallOffset = forView.bounds.origin.y + forView.aui_padding.top
        for view in views {
            var newFrame = view.frame
            if view.superview != self {
                newFrame = view.convert(view.bounds, to: self)
            }
            if newFrame.width <= 0 {
                newFrame = view
                    .aui_frame(inBounds: self.bounds.inset(by: aui_padding))
                    .with(height: 0)
                    .with(y: verticallOffset)
                view.frame = newFrame
            }
            verticallOffset = newFrame.maxY + spacing + view.aui_margin.bottom
        }
    }

    func aui_configureHorizontallNewViews(_ views: [UIView], forView: UIView) {
        let spacing = spacing ?? 0
        var horizontalOffset = forView.bounds.origin.x + forView.aui_padding.left
        for view in views {
            var newFrame = view.frame
            if view.superview != self {
                newFrame = view.convert(view.bounds, to: self)
            }
            if newFrame.width <= 0 {
                newFrame = view
                    .aui_frame(inBounds: self.bounds.inset(by: aui_padding))
                    .with(width: 0)
                    .with(x: horizontalOffset)
            }
            view.frame = newFrame
            horizontalOffset = newFrame.maxX + spacing + view.aui_margin.right
        }
    }

    func aui_verticalSpacing(inBounds: CGRect) -> CGFloat {
        if let _spacing = spacing {
            return _spacing
        }
        var viewsHeight: CGFloat = 0
        var calcBounds = inBounds
        for view in views {
            viewsHeight += view.aui_frame(inBounds: calcBounds).height + view.aui_margin.verticalValue
            calcBounds = inBounds.inset(by: .top(viewsHeight))
        }

        return (inBounds.height - viewsHeight) / CGFloat(views.count - 1)
    }
    
    func aui_horizontalSpacing(inBounds: CGRect) -> CGFloat {
        if let _spacing = spacing {
            return _spacing
        }
        var viewsWidth: CGFloat = 0
        var calcBounds = inBounds
        for view in views {
            viewsWidth += view.aui_frame(inBounds: calcBounds).width + view.aui_margin.horizontalValue
            calcBounds = inBounds.inset(by: .left(viewsWidth))
        }
        return (inBounds.width - viewsWidth) / CGFloat(views.count - 1)
    }
    
    func aui_horizontalLayout(inBounds: CGRect) {
        var offset = inBounds.origin.x
        
        let _spacing: CGFloat = aui_horizontalSpacing(inBounds: inBounds)
        
        for view in views {
            let viewFrame = view
                .aui_frame(inBounds: inBounds
                    .inset(by: .left(offset - inBounds.origin.x))
                )
                .with(x: offset + view.aui_margin.left)
            view.frame = viewFrame
            view.layoutSubviews()
            if view.isHidden || view.aui_packHidden { continue }
            offset = viewFrame.maxX + _spacing + view.aui_margin.right
        }
    }
}

import ObjectiveC.runtime

private struct SwipeDismissKeys {
    static var threshold = 0
    static var velocityThreshold = 1
    static var direction = 2
    static var originalCenter = 3
}

extension UIView {

    func enableSwipeToDismiss(
        threshold: CGFloat = 0.4,
        velocityThreshold: CGFloat = 500,
        direction: NSLayoutConstraint.Axis = .horizontal
    ) {
        isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeDismissPan(_:)))
        addGestureRecognizer(panGesture)

        objc_setAssociatedObject(self, &SwipeDismissKeys.threshold, threshold, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &SwipeDismissKeys.velocityThreshold, velocityThreshold, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &SwipeDismissKeys.direction, direction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc private func handleSwipeDismissPan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view, let superview = view.superview else { return }

        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)

        let threshold = objc_getAssociatedObject(view, &SwipeDismissKeys.threshold) as? CGFloat ?? 0.4
        let velocityThreshold = objc_getAssociatedObject(view, &SwipeDismissKeys.velocityThreshold) as? CGFloat ?? 500
        let axis = (objc_getAssociatedObject(view, &SwipeDismissKeys.direction) as? NSLayoutConstraint.Axis) ?? .horizontal

        let travel = axis == .horizontal ? translation.x : translation.y
        let velocityValue = axis == .horizontal ? velocity.x : velocity.y
        let dimension = axis == .horizontal ? view.bounds.width : view.bounds.height

        switch gesture.state {
        case .began:
            // Сохраняем начальную позицию центра
            objc_setAssociatedObject(view, &SwipeDismissKeys.originalCenter, view.center, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        case .changed:
            if let originalCenter = objc_getAssociatedObject(view, &SwipeDismissKeys.originalCenter) as? CGPoint {
                // Сдвигаем вместе с пальцем
                let newCenter = CGPoint(
                    x: axis == .horizontal ? originalCenter.x + translation.x : originalCenter.x,
                    y: axis == .horizontal ? originalCenter.y : originalCenter.y + translation.y
                )
                view.center = newCenter
            }

        case .ended, .cancelled:
            let shouldDismiss = abs(travel) > dimension * threshold || abs(velocityValue) > velocityThreshold

            if shouldDismiss {
                let dir: CGFloat = travel > 0 ? 1 : -1
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn], animations: {
                    if axis == .horizontal {
                        view.center.x += dir * dimension * 1.5
                    } else {
                        view.center.y += dir * dimension * 1.5
                    }
                    view.alpha = 0
                }, completion: { _ in
                    view.isHidden = true
                    view.alpha = 1
                })
            } else {
                // Возврат к исходному положению
                if let originalCenter = objc_getAssociatedObject(view, &SwipeDismissKeys.originalCenter) as? CGPoint {
                    UIView.animate(withDuration: 0.25) {
                        view.center = originalCenter
                    }
                }
            }

        default:
            break
        }
    }
}


