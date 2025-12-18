// Created by AliveBe on 01.12.2023.

import UIKit

enum AUI {
}

extension Array where Element == CGFloat {
    var sum: CGFloat {
        self.reduce(CGFloat(0)) { partialResult, element in
            partialResult + element
        }
    }
}

extension Array {
    func uniqued(by key: (Element) -> AnyHashable) -> [Element] {
        var seen = Set<AnyHashable>()
        return self.filter { seen.insert(key($0)).inserted }
    }
}

extension Array where Element == Double {
    var sum: Double {
        self.reduce(Double(0)) { partialResult, element in
            partialResult + element
        }
    }
}

extension Array where Element == Int {
    var sum: Int {
        self.reduce(Int(0)) { partialResult, element in
            partialResult + element
        }
    }
}

