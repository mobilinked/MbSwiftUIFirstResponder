//
//  Window Coordinator.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/1.
//
#if os(iOS)
import SwiftUI

final class FirstResponderTapGesture: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    private var observers: [WeakFrEventObserver]
    
    init(from observer: FrEventObserver) {
        self.observers = [.init(observer)]
        super.init(target: nil, action: nil)
        self.cancelsTouchesInView = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        if self.state == .recognized, let firstTouch = touches.first {
            let locationInWindow = firstTouch.location(in: nil)
  
            for observer in observers {
                observer.object?.frDidTapInWindow(at: locationInWindow)
            }
        }
    }
    
    func add(observer: FrEventObserver) {
        guard observers.contains(where: { $0.object === observer } ) == false else { return }
        self.observers.append(.init(observer))
    }
}

struct WeakFrEventObserver {
    weak var object: FrEventObserver?

    init(_ element: FrEventObserver) {
        self.object = element
    }
}

protocol FrEventObserver: AnyObject {
    func frDidTapInWindow(at: CGPoint)
}

#endif
