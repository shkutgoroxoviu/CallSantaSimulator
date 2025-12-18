// Created by AliveBe on 13.02.2025.

import UIKit

extension AUI {
    class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
        func setup() {
            interactivePopGestureRecognizer?.isEnabled = true
            interactivePopGestureRecognizer?.delegate = self
            modalPresentationStyle = .fullScreen
            isNavigationBarHidden = true
        }
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            setup()
        }
        
        override init(rootViewController: UIViewController) {
            super.init(rootViewController: rootViewController)
            setup()
        }
        
        override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
            super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            viewControllers.count > 1
        }
    }
}
