// Created by AliveBe on 23.10.2024.

import Foundation
import UIKit
import UIScrollView_InfiniteScroll
protocol ReusableView {
    func prepareForReuse()
}

extension AUI {
    class ScrollStackView: UIScrollView, AUIView, AUICollection {
        // MARK: - Public Properties
        var views: [UIView] = [] {
            didSet {
                oldValue.forEach { $0.removeFromSuperview() }
                views.forEach { self.addSubview($0) }
                
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
        
        var spacing: CGFloat? = 0 {
            didSet {
                setNeedsLayout()
            }
        }
        
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero {
            didSet {
                setNeedsLayout()
            }
        }
        
        var padding: UIEdgeInsets = .zero {
            didSet {
                setNeedsLayout()
            }
        }
        
        var verticalAligment: AUI.VerticalAligment = .top {
            didSet {
                setNeedsLayout()
            }
        }
        
        var horizontalAligment: AUI.HorizontalAligment = .left {
            didSet {
                setNeedsLayout()
            }
        }
        var aui_borderColor: UIColor?
        
        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        
        // MARK: - Initializers
        
        init(views: [UIView] = [], spacing: CGFloat = 0) {
            self.views = views
            self.spacing = spacing
            super.init(frame: .zero)
            
            self.views.forEach { self.addSubview($0) }
            self.showsHorizontalScrollIndicator = true
            self.showsVerticalScrollIndicator = false
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup() {
            
        }
        // MARK: - Layout
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // Раскладываем элементы по горизонтали с отступом 32 слева
            layoutHorizontalStack()
            
            // Устанавливаем contentSize, чтобы корректно работал скроллинг
            updateContentSize()
            
            layer.transform = aui_packTransform
        }
        
        private func layoutHorizontalStack() {
            // Начинаем с отступом в 32 пикселя слева
            var xPosition: CGFloat = 32  // Начинаем с 32 пикселей, без учета padding.left
            let spacing = spacing ?? 0
            for view in views {
                let viewSize = view.sizeThatFits(CGSize(width: estimatedWidth ?? bounds.width, height: bounds.height))
                
                // Определяем вертикальное выравнивание
                var yPosition: CGFloat = padding.top
                switch verticalAligment {
                case .top:
                    yPosition = padding.top
                case .center:
                    yPosition = (bounds.height - viewSize.height) / 2
                case .bottom:
                    yPosition = bounds.height - viewSize.height - padding.bottom
                case .fill:
                    yPosition = bounds.height
                }
                
                // Устанавливаем фрейм для подвидов
                view.frame = CGRect(x: xPosition, y: yPosition, width: viewSize.width, height: viewSize.height)
                
                // Обновляем xPosition для следующего элемента
                xPosition += viewSize.width + spacing
            }
            
            // После размещения всех элементов добавляем отступ справа
            // 32 пикселя — дополнительный отступ справа
            xPosition += 32
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }

        private func updateContentSize() {
            let spacing = spacing ?? 0
            // Суммируем ширины всех view
            let totalViewsWidth = views.map { $0.frame.width }.reduce(0, +)
            
            // Считаем общее расстояние между view
            let totalSpacing = spacing * CGFloat(views.count - 1)
            
            // Общая ширина с учетом отступов и дополнительного отступа в 32 справа
            let totalWidth = totalViewsWidth + totalSpacing + 32 + padding.right  // Начальный отступ слева — 32
            
            // Высота содержимого (можно динамически вычислять, если требуется)
            let contentHeight = bounds.height
            
            // Устанавливаем размер содержимого с минимальным дополнительным размером для скроллинга
            let additionalWidthForScroll: CGFloat = 1 // Минимальный дополнительный размер
            contentSize = CGSize(
                width: max(totalWidth, bounds.width + additionalWidthForScroll),
                height: contentHeight
            )
        }


        // MARK: - Size Calculation

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let spacing = spacing ?? 0
            // Пересчитываем общую ширину, учитывая отступы
            // Начальный отступ — 32 пикселя
            let totalWidth = views.reduce(32) { $0 + $1.sizeThatFits(size).width + spacing } - spacing + padding.right
            let maxHeight = views.map { $0.sizeThatFits(size).height }.max() ?? 0
            
            return CGSize(width: totalWidth, height: maxHeight + padding.top + padding.bottom)
        }
    }
}

extension AUI {
    class ScrollView: UIScrollView, AUIView {
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero {
            didSet {
                setNeedsLayout()
            }
        }
        
        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        var aui_borderColor: UIColor?
        
        // MARK: - Public Properties
        var content: UIView? {
            didSet {
                // Удаляем старую вью
                oldValue?.removeFromSuperview()
                // Добавляем новую в scroll view
                if let content = content {
                    addSubview(content)
                    setNeedsLayout()
                    layoutIfNeeded()
                }
            }
        }
        
        var padding: UIEdgeInsets = .zero {
            didSet {
                setNeedsLayout()
            }
        }
        
        var verticalAligment: VerticalAligment = .top {
            didSet { setNeedsLayout() }
        }
        
        var horizontalAligment: HorizontalAligment = .left {
            didSet { setNeedsLayout() }
        }
        
        // MARK: - Initializers
        init(content: UIView? = nil) {
            self.content = content
            super.init(frame: .zero)
            showsHorizontalScrollIndicator = true
            showsVerticalScrollIndicator = false
            if let content = content {
                addSubview(content)
            }
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup() {}
        
        // MARK: - Layout
        override func layoutSubviews() {
            super.layoutSubviews()
            guard let content = content else { return }
            
            // Размер контента
            let contentSize = content.sizeThatFits(CGSize(width: bounds.width, height: bounds.height))
            
            // Вычисляем x и y по выравниванию
            var x: CGFloat = padding.left
            var y: CGFloat = padding.top
            
            switch horizontalAligment {
            case .left:
                x = padding.left
            case .center:
                x = max((bounds.width - contentSize.width)/2, padding.left)
            case .right:
                x = max(bounds.width - contentSize.width - padding.right, padding.left)
            case .fill:
                x = padding.left
            }
            
            switch verticalAligment {
            case .top:
                y = padding.top
            case .center:
                y = max((bounds.height - contentSize.height)/2, padding.top)
            case .bottom:
                y = max(bounds.height - contentSize.height - padding.bottom, padding.top)
            case .fill:
                y = padding.top
            }
            
            // Устанавливаем фрейм для content
            if horizontalAligment == .fill {
                content.frame = CGRect(x: x, y: y, width: bounds.width - padding.left - padding.right, height: contentSize.height)
            } else {
                content.frame = CGRect(x: x, y: y, width: contentSize.width, height: contentSize.height)
            }
            
            // Устанавливаем contentSize scroll view
            self.contentSize = CGSize(
                width: max(bounds.width, content.frame.maxX + padding.right),
                height: max(bounds.height, content.frame.maxY + padding.bottom)
            )
        }
        
        // MARK: - Size Calculation
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            guard let content = content else { return size }
            let contentSize = content.sizeThatFits(size)
            return CGSize(width: contentSize.width + padding.left + padding.right,
                          height: contentSize.height + padding.top + padding.bottom)
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
}

extension UIScrollView {
    func with(scrollEnabled: Bool) -> Self {
        self.isScrollEnabled = scrollEnabled
        return self
    }
    
    func with(scrollIndicatorVisible: Bool) -> Self {
        self.showsHorizontalScrollIndicator = scrollIndicatorVisible
        return self
    }
}

extension AUI {
    class HorizontalScrollStack: UIScrollView, AUIView, AUICollection {
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var estimatedHeight: CGFloat?
        var estimatedWidth: CGFloat?
        var packHidden: Bool = false
        var aui_borderColor: UIColor?
        
        var spacing: CGFloat?
        var views: [UIView] = [] {
            didSet {
                for oldView in oldValue where oldView.superview == self {
                    oldView.removeFromSuperview()
                }
                for view in views {
                    addSubview(view)
                }
            }
        }
        
        func setup() {
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = super.sizeThatFits(size)
            result = aui_horizontalSize(inSize: size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let newContentSize = aui_horizontalSize(inSize: bounds
                .size
                .with(width: .infinity))
            let safeBounds = bounds
                .with(origin: .zero)
                .with(width: max(newContentSize.width, bounds.width))
                .inset(by: padding)
            self.aui_horizontalLayout(inBounds: safeBounds)
            if self.contentSize != newContentSize {
                self.contentSize = newContentSize
            }
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
    }
}


private extension UIEdgeInsets {
    var vertical: CGFloat {
        return top + bottom
    }
    
    var horizontal: CGFloat {
        return left + right
    }
}
