// Created by AliveBe on 04.12.2023.

import Foundation

class Promise<Value> {
    typealias SubscribeBlock = (Value)->Void

    var onlyForLastSubscriber = false

    init() {
    }
    
    init(withValue:Value) {
        compleatedValue = withValue
    }
    
    func sendNext(_ value:Value) {
        compleatedValue = value
        for item in subscribers {
            item(value)
        }
    }
    
    @discardableResult
    func then<T>(_ block:@escaping (Value)->Promise<T>?)->Promise<T> where T : Any {
        let result = Promise<T>()
        on { item in
            let otherPromise = block(item)
            otherPromise?.on(value: { tValue in
                result.sendNext(tValue)
            })
        }
        return result
    }
    
    func then(_ block:@escaping SubscribeBlock) {
        self.on(value: block)
    }

    //MARK: - Private
    private var subscribers : [SubscribeBlock] = []
    private var compleatedValue : Value? = nil
    
    private func on( value:@escaping SubscribeBlock) {
        if onlyForLastSubscriber {
            subscribers.removeAll()
            subscribers.append(value)
            return
        }
        subscribers.append(value)
        if let strongCompleatedValue = compleatedValue {
            value(strongCompleatedValue)
        }
    }
}

class PromiseTimer {
    private var timer:Timer? = nil
    private var num: Int = 0
    private var count: Int = 0
    let promise = Promise<Int>()
    init(interval:TimeInterval, count:Int) {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        self.count = count
    }
    @objc func timerAction() {
        num += 1
        if num >= count - 1 {
            timer?.invalidate()
        }
        promise.sendNext(num)
    }
}
