//
//  Text Field.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/2.
//
#if os(iOS)
import SwiftUI

// MARK: - namespace
extension MbFirstResponder {
    public enum TextField { }
}

// MARK: - Operations can resign the first responder
extension MbFirstResponder.TextField {
    public struct ResignableUserOperations: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let tapOutside = ResignableUserOperations(rawValue: 1 << 0)
        public static let all: ResignableUserOperations = [.tapOutside]
        public static let none: ResignableUserOperations = []
    }
}

// MARK: - implementation for NSTextField
extension UITextField: FirstResponderable {
    func frIsFirstResponder() -> Bool {
        self.isFirstResponder
    }
    
    func frDidTap(inside: Bool, resignableUserOperations: MbFirstResponder.TextField.ResignableUserOperations, completed: @escaping (FRTapChangeResult) -> Void) {
        if inside {
            // here to dispatch to main queue
            // as the field may be changed to be the first responder by the system a little later
            DispatchQueue.main.async {
                completed(self.frIsFirstResponder() ? .focused : .resigned)
            }
        }
        else {
            if resignableUserOperations.contains(.tapOutside) && self.frIsFirstResponder() {
                self.resignFirstResponder()
                completed(.resigned)
            }
        }
    }
}
#endif 
