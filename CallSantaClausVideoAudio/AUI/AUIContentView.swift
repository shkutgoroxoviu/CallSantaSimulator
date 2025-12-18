// Created by AliveBe on 11.12.2023.

import UIKit
import ObjectiveC

extension AUI {
    class BaseContentView: UIScrollView, UIScrollViewDelegate, AUIView {
        private var lastContentOffset: CGFloat = 0
        private var lastContentOffsetFor: CGFloat = 0
        private var beginDirectionContentOffset: CGFloat = 0
        var threshold: CGFloat = 10
        
        var hasReachedEnd = false
        
        var sendAccept: (() async -> Void)?
        var changeHeights: ((Bool) -> Void)?
        var upDownMotionVelocity: ((CGFloat) -> Void)?
        var upDownMotionDirection: ((Bool) -> Void)?
        
        var packHidden: Bool = false
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .fill
        var horizontalAligment: AUI.HorizontalAligment = .fill
        var aui_borderColor: UIColor?
        
        var estimatedHeight: CGFloat? = nil
        var estimatedWidth: CGFloat? = nil
        
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
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.transform = aui_packTransform
            scrollViewDidScroll(self)
        }
        
        func setup() {
            self.keyboardDismissMode = .onDrag
            self.delegate = self
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.endEditing(false)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.height
            
            if offsetY < 0 {
                changeHeights?(false)
            } else if offsetY > 0 {
                changeHeights?(true)
            }
            
            // Не позволяет прокрутке выйти за пределы снизу
            if offsetY >= contentHeight - scrollViewHeight {
                return // Остановить обработку, если достигнут конец
            }
            
            if offsetY > lastContentOffset {
                if beginDirectionContentOffset > offsetY {
                    beginDirectionContentOffset = offsetY
                }
                let velocity = offsetY - beginDirectionContentOffset
                
                if offsetY > 1 {
                    if velocity > threshold {
                        upDownMotionDirection?(true)
                    }
                    upDownMotionVelocity?(offsetY - beginDirectionContentOffset)
                }
            } else if offsetY < lastContentOffset {
                if beginDirectionContentOffset < offsetY {
                    beginDirectionContentOffset = offsetY
                }
                let velocity = abs(offsetY - beginDirectionContentOffset)
                
                if velocity > threshold {
                    upDownMotionDirection?(false)
                }
                
                upDownMotionVelocity?(0)
            }
            
            lastContentOffset = offsetY
            checkIfScrolledToBottom(scrollView: scrollView)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            detectScrollDirection(scrollView)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                detectScrollDirection(scrollView)
            }
        }

        private func detectScrollDirection(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y

            if offsetY > lastContentOffsetFor {
                upDownMotionVelocity?(bounds.maxY)
            } else if offsetY < lastContentOffsetFor {
                upDownMotionVelocity?(0)
            }

            lastContentOffsetFor = offsetY
        }
        
        private func checkIfScrolledToBottom(scrollView: UIScrollView) {
            let contentHeight = scrollView.contentSize.height
            let visibleHeight = scrollView.bounds.height
            let offsetY = scrollView.contentOffset.y
            let threshold: CGFloat = 150.0
            
            if !hasReachedEnd && offsetY >= contentHeight - visibleHeight - threshold {
                hasReachedEnd = true
                print("Scrolled to the bottom for the first time!")
                onReachedEnd()
            }
        }
        
        private func onReachedEnd() {
            Task {
                await sendAccept?()
            }
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
    
    class ListContentView: BaseContentView, AUICollection {
        var topPanel: UIView? = nil {
            willSet {
                topPanel?.removeFromSuperview()
                aui_addSubview(newValue)
            }
            didSet {
                layoutSubviews()
            }
        }
        var topPanelMinimumHeight: CGFloat? = nil
        var views: [UIView] = [] {
            willSet {
                aui_configureVerticalNewViews(newValue, forView: self)
                views.forEach { $0.removeFromSuperview() }
                newValue.forEach { self.addSubview($0) }
                if let topPanel = topPanel {
                    bringSubviewToFront(topPanel)
                }
                if let bottomPanel = bottomPanel {
                    self.bringSubviewToFront(bottomPanel)
                }
            }
            didSet {
                layoutSubviews()
            }
        }
        
        override func setup() {
            super.setup()
            backgroundColor = .white
        }
        
        var bottomPanel: UIView? = nil {
            willSet {
                bottomPanel?.removeFromSuperview()
                aui_addSubview(newValue)
            }
        }
        
        var spacing: CGFloat? = 0 {
            didSet {
                setNeedsLayout()
            }
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            guard let topPanel = topPanel else {
                return aui_verticalSize(inSize: size)
            }
            let topPanelSize = topPanel
                .sizeThatFits(size.inset(by: padding.vertical(0)).inset(by: margin))
                .inset(by: margin.flipped).inset(by: padding.vertical(0).flipped)
            let collectionSize = aui_verticalSize(inSize: size)
            var result = CGSize(
                width: max(topPanelSize.width, collectionSize.width),
                height: topPanelSize.height + collectionSize.height)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            var topPanelHeight: CGFloat = 0
            var safeBounds = bounds.with(height: .infinity)
            if let topPanel = topPanel {
                let topPanelFrame = topPanel.aui_frame(inBounds: safeBounds)
                    .with(y: bounds.origin.y + padding.top + topPanel.aui_margin.top)
                topPanelHeight = topPanel.frame.height + topPanel.aui_margin.top + topPanel.aui_margin.bottom
//                if let topPanelMinimumHeight = topPanelMinimumHeight, bounds.y >= 0 {
//                    topPanelFrame.height = max(topPanelFrame.height - bounds.y, topPanelMinimumHeight)
//                }
                topPanel.frame = topPanelFrame
                topPanel.layoutSubviews()
            }
            safeBounds.origin.y = topPanelHeight
            aui_verticalLayout(inBounds: safeBounds.inset(by: padding))
            var bottomPanelHeight: CGFloat = 0
            if let bottomPanel = bottomPanel {
                bottomPanel.frame = bottomPanel
                    .aui_frame(inBounds: safeBounds)
                    .with(y: frame.height + contentOffset.y - bottomPanel.aui_margin.bottom - bottomPanel.frame.height)
                bottomPanelHeight = bottomPanel.frame.height + bottomPanel.aui_margin.bottom
            }
            
            if let horizontalPageContentView = self.superview as? HorizontalPageContentView {
                if let toppPanel = horizontalPageContentView.topPanel {
                    toppPanel.frame = toppPanel.frame
                        .with(y: min(-contentOffset.y, 0))
                        .with(y: 0)
                }
            }
            
            let newContentSize = CGSize(
                width: bounds.width,
                height: (views.filter { !$0.isHidden }.map { $0.frame.maxY + $0.aui_margin.bottom }.max() ?? 0) + bottomPanelHeight + aui_padding.bottom)
            if !contentSize.equalTo(newContentSize) {
                contentSize = newContentSize
                if contentSize.inset(by: contentInset.flipped).height <= bounds.height {
                    contentOffset.y = -contentInset.top
                }
            }
        }
    }
    
    class BaseListContentView: UIScrollView, AUIView, AUICollection {
        var margin: UIEdgeInsets = .zero
        var padding: UIEdgeInsets = .zero
        var verticalAligment: AUI.VerticalAligment = .top
        var horizontalAligment: AUI.HorizontalAligment = .left
        var estimatedHeight: CGFloat?
        var estimatedWidth: CGFloat?
        var packHidden: Bool = false
        var aui_borderColor: UIColor?
        
        var views: [UIView] = [] {
            didSet {
                aui_configureVerticalNewViews(views, forView: self)
                oldValue.forEach { $0.removeFromSuperview() }
                views.forEach { self.addSubview($0) }
                if let bottomPanel = bottomPanel {
                    bringSubviewToFront(bottomPanel)
                }
                layoutSubviews()
            }
        }
        var bottomPanel: UIView? = nil {
            willSet {
                bottomPanel?.removeFromSuperview()
                if let new = newValue { addSubview(new) }
            }
            didSet { setNeedsLayout() }
        }
        override var contentInset: UIEdgeInsets {
            didSet {
                guard contentInset != oldValue else { return }                        
                contentOffset = .init(x: 0, y: -contentInset.top)
            }
        }
        var spacing: CGFloat? = 0
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        func setup() {
            contentInsetAdjustmentBehavior = .never
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var result = aui_verticalSize(inSize: size)
            result.width = estimatedWidth ?? result.width
            result.height = estimatedHeight ?? result.height
            return result
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let safeBounds = bounds
                .with(y: 0)
                .inset(by: padding)
                .with(height: .infinity)
            
            // -------------------------
            // MAIN CONTENT
            // -------------------------
            aui_verticalLayout(inBounds: safeBounds)
            
            // -------------------------
            // BOTTOM PANEL
            // -------------------------
            var bottomPanelHeight: CGFloat = 0
            
            if let bottomPanel = bottomPanel {
                
                let h = bottomPanel.sizeThatFits(bounds.size).height
                
                bottomPanel.frame = CGRect(
                    x: bottomPanel.aui_margin.left,
                    y: bounds.maxY + contentOffset.y - bottomPanel.aui_margin.bottom - h,
                    width: bounds.width - bottomPanel.aui_margin.left - bottomPanel.aui_margin.right,
                    height: h
                )
                
                bringSubviewToFront(bottomPanel)
                
                bottomPanelHeight = h + bottomPanel.aui_margin.bottom
            }
            
            // -------------------------
            // CONTENT SIZE
            // -------------------------
            let contentBottom = views
                .filter { !$0.isHidden }
                .map { $0.frame.maxY + $0.aui_margin.bottom }
                .max() ?? 0
            
            let newContentSize = CGSize(
                width: bounds.width,
                height: contentBottom + bottomPanelHeight + aui_padding.bottom
            )
            
            if !contentSize.equalTo(newContentSize) {
                contentSize = newContentSize
                
                if contentSize.inset(by: contentInset.flipped).height <= bounds.height {
                    contentOffset.y = -contentInset.top
                }
            }
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            aui_updateBorder()
        }
    }
    
    class HorizontalPageContentView: UIScrollView, UIScrollViewDelegate {
        var views: [UIView] = [] {
            didSet {
                for oldView in oldValue where oldView.superview == self {
                    oldView.removeFromSuperview()
                }
                for view in views {
                    insertSubview(view, at: 0)
                }
            }
        }
        
        var topPanel: UIView? {
            didSet {
                oldValue?.removeFromSuperview()
                guard let topPanel else { return }
                addSubview(topPanel)
            }
        }
        
        var bottomPanel: UIView? {
            didSet {
                oldValue?.removeFromSuperview()
                guard let bottomPanel else { return }
                addSubview(bottomPanel)
            }
        }
        
        private var _currentPageIndex: Int?
        var currentPageIndex: Int {
            get {
                guard bounds.width > 0 else { return 0 }
                if let _currentPageIndex { return _currentPageIndex }
                return Int((contentOffset.x / bounds.width) + 0.4)
            }
            set {
                _currentPageIndex = newValue
                self.scrollToPage(max(0, newValue))
            }
        }
        
        var currentPageProgress: CGFloat {
            get { contentOffset.x / bounds.width }
            set { contentOffset.x = min(newValue * bounds.width, contentSize.width - bounds.width) }
        }

        func setup() {
            self.keyboardDismissMode = .onDrag
            self.isPagingEnabled = true
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        func pageChanged(newPageIndex: Int) {
        }
        
        override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
            super.setContentOffset(contentOffset, animated: animated)
            self.layoutSubviews()
            print("newContentOffset: \(contentOffset)")
        }
        
        func scrollToPage(_ index: Int) {
            pageChanged(newPageIndex: index)
            UIView.animate(withDuration: 0.3) {
                self.bounds.origin.x = CGFloat(index) * self.bounds.width
                self.layoutSubviews()
            } completion: { falue in
                self._currentPageIndex = nil
            }

        }
        
        private var _oldXOffset: CGFloat = 0
        override func layoutSubviews() {
            super.layoutSubviews()

            let safeBounds = bounds
                .with(height: frame.height)
                .inset(by: contentInset)

            var topOffset: CGFloat = safeBounds.y
            var bottomOffset: CGFloat = 0

            if let topPanel {
                topPanel.frame = topPanel.aui_frame(inBounds: bounds).with(y: safeBounds.y)
                topPanel.layoutSubviews()
                topOffset = topPanel.frame.maxY + topPanel.aui_margin.bottom
            }

            if let bottomPanel {
                var bottomPanelFrame = bottomPanel.aui_frame(inBounds: bounds)
                bottomPanelFrame.origin.y = safeBounds.maxY - bottomPanelFrame.height - bottomPanel.aui_margin.bottom
                bottomPanel.frame = bottomPanelFrame
                bottomPanel.layoutSubviews()
                bottomOffset = bottomPanelFrame.height + bottomPanel.aui_margin.top + bottomPanel.aui_margin.bottom
            }

            var contentOffset: CGFloat = 0

            for view in views {
                let ignoreBottom = view.ignoresBottomOffset
                let height = safeBounds.height - topOffset - (ignoreBottom ? 0 : bottomOffset)

                view.frame = CGRect(
                    x: contentOffset,
                    y: topOffset,
                    width: self.frame.width,
                    height: height
                )
                view.layoutSubviews()
                contentOffset = view.frame.maxX
            }

            self.contentSize = CGSize(width: contentOffset, height: self.frame.inset(by: contentInset).height)

            if _oldXOffset != self.contentOffset.x {
                _oldXOffset = self.contentOffset.x
                pageChanged(newPageIndex: currentPageIndex)
            }
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.endEditing(false)
        }
    }
}


extension UIView {
    private struct AssociatedKeys {
        static var ignoresBottomOffset: UInt8 = 0
    }

    var ignoresBottomOffset: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ignoresBottomOffset) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ignoresBottomOffset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIScrollView {
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
    }
}
