// Created by AliveBe on 16.01.2025.

import UIKit

protocol AUIStateViewLoadingScreen: AUIView {
    var isSpinning: Bool { get set }
}

extension AUI {
    class StateView<T: UIView>: AUI.BaseView {
        var mainView = T() { didSet {
            oldValue.removeFromSuperview()
            addSubview(mainView)
        }}
        
        var state: State = .main {
            didSet {
                if state == oldValue { return }
                switch state {
                case .loading: transiction(toView: loadingView)
                case .main:    transiction(toView: mainView)
                }
                loadingView.isSpinning = state == .loading
            }
        }
        
        override func setup() {
            super.setup()
            addSubview(mainView)
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            switch state {
            case .loading: return loadingView.sizeThatFits(size)
            case .main:    return mainView.sizeThatFits(size)
            }
        }
        
        func transiction(toView: UIView) {
//            let currentView: UIView
//            switch state {
//            case .loading: currentView = loadingView
//            case .main:    currentView = mainView
//            }
            UIView.animate(withDuration: 0.3) {
                self._loadingView?.alpha = 0
                self.mainView.alpha = 0
                toView.alpha = 1
                toView.layoutSubviews()
            }
        }
        
        private var _loadingView: (AUIStateViewLoadingScreen&UIView)?
        var loadingView: AUIStateViewLoadingScreen&UIView {
            get {
                if let _loadingView {
                    return _loadingView
                }
                let result = configureLoadingView()
                _loadingView = result
                addSubview(result)
                self.sendSubviewToBack(result)
                return result
            }
            set {
                _loadingView = newValue
            }
        }
        
        func configureLoadingView() -> (AUIStateViewLoadingScreen&UIView) {
            AUI.StateView.DefaultLoadingScreen()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            mainView.frame = bounds
            mainView.layoutSubviews()
            _loadingView?.frame = bounds
            _loadingView?.layoutSubviews()
        }
    }
}

extension AUI.StateView {
    class DefaultLoadingScreen: AUI.ZStackView, AUIStateViewLoadingScreen {
        var isSpinning: Bool = true {
            didSet {
                if isSpinning {
                    spinner.startAnimating()
                } else {
                    spinner.stopAnimating()
                }
            }
        }
        
        let spinner = AUI.ActivityIndicatorView()
        
        override func setup() {
            super.setup()
            views = [
                spinner
                    .with(style: .large)
                    .with(horizontalAligment: .center)
                    .with(verticalAligment: .center)
                    .with(margin: .all(8))
                    .aui_startAnimating()
            ]
        }
    }
}

extension AUI.StateView {
    enum State {
        case loading
        case main
    }
}
