//
//  TimeService.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//
import Foundation

final class TimeService {
    
    enum Mode {
        case countdown(from: Int)
        case timer                    
    }
    
    private(set) var currentValue: Int = 0
    private var targetValue: Int = 0
    private var timer: Timer?
    private var mode: Mode = .timer
    
    var onTick: ((Int) -> Void)?
    var onFinished: (() -> Void)?
    
    // MARK: - Start
    
    func start(mode: Mode) {
        stop()
        self.mode = mode
        
        switch mode {
        case .countdown(let from):
            currentValue = from
            targetValue = 0
            
        case .timer:
            currentValue = 0
        }
        
        onTick?(currentValue)
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(handleTick),
            userInfo: nil,
            repeats: true
        )
    }
    
    // MARK: - Tick
    
    @objc private func handleTick() {
        switch mode {
        case .countdown:
            currentValue -= 1
            onTick?(currentValue)
            
            if currentValue <= targetValue {
                stop()
                onFinished?()
            }
            
        case .timer:
            currentValue += 1
            onTick?(currentValue)
        }
    }
    
    // MARK: - Stop
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}

