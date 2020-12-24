//
//  Window Coordinator.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/1.
//
#if os(macOS)
import SwiftUI

final class FRWindowEventPublisher {
    private var observers: [FrWeakEventObserver]
    
    init(from observer: FrEventObserver) {
        observers = [.init(observer)]
        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .keyUp]) { [weak self] event in
            self?.handleEvent(event: event)
            
            return event
        }
    }
    
    private func handleEvent(event: NSEvent) {
        var anyInvalidate = false
        observers.forEach {
            if let obj = $0.object {
                obj.frEventDidReceived(event: event)
            }
            else {
                anyInvalidate = true
            }
        }
        
        if anyInvalidate {
            observers.removeAll { $0.object == nil }
        }
    }
    
    func add(observer: FrEventObserver) {
        guard observers.contains(where: { $0.object === observer } ) == false else { return }
        self.observers.append(.init(observer))
    }
    
    func remove(observer: FrEventObserver) {
        observers.removeAll {
            $0.object === observer
        }
    }
}

struct FrWeakEventObserver {
    weak var object: FrEventObserver?

    init(_ element: FrEventObserver) {
        self.object = element
    }
}

protocol FrEventObserver: AnyObject {
    func frEventDidReceived(event: NSEvent)
}

#endif
