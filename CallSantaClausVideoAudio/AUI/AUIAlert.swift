// Created by AliveBe on 01.04.2024.

import UIKit

extension AUI {
    class Alert: UIAlertController {
    }
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    for action in actions {
//        alert.addAction(action)
//    }
//    present(alert, animated: true, completion: nil)

}

extension UIAlertController {
    func with(title: String) -> Self {
        self.title = title
        return self
    }
    
    func with(message: String) -> Self {
        self.message = message
        return self
    }
    
    func with(action: UIAlertAction) -> Self {
        self.addAction(action)
        return self
    }
}

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
    
    
}
