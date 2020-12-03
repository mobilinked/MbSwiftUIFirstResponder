//
//  Def.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/2.
//
#if os(macOS)
import SwiftUI

// MARK: - namespace
extension MbFirstResponder {
    public enum TextEditor { }
}

// MARK: - Operations can resign the first responder
extension MbFirstResponder.TextEditor {
    public struct ResignableUserOperations: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let leftClickOutside = ResignableUserOperations(rawValue: 1 << 0)
        public static let escKey = ResignableUserOperations(rawValue: 1 << 3)
        
        public static let all: ResignableUserOperations = [.leftClickOutside, .escKey]
    }
}

// MARK: - implementation for NSTextField
extension NSTextView: FirstResponderable {
    func frIsFirstResponder(in window: NSWindow) -> Bool {
        window.firstResponder === self
    }
    
    func frHandleEvent(event: NSEvent, in window: NSWindow, resignableUserOperations: MbFirstResponder.TextEditor.ResignableUserOperations, completed: @escaping (FREventChangeResult) -> Void) {
        if event.type == .leftMouseDown {
            let locationInWindow = event.locationInWindow
            
            // if the click inner the content rect
            if let contentLayoutRect = self.window?.contentLayoutRect, contentLayoutRect.contains(locationInWindow) {
                let textFieldFrame = self.convert(self.bounds, to: nil)
                let outsideTextField = !textFieldFrame.contains(locationInWindow)
                
                if resignableUserOperations.contains(.leftClickOutside) && outsideTextField { // if click outside the text field
                    _asyncResignFirstResponder(completed: completed)
                }
                else {
                    // user click may change the first responder, so here to update the binding
                    DispatchQueue.main.async {
                        guard let window = self.window else { return }
                        completed(self.frIsFirstResponder(in: window) ? .focused : .resigned)
                    }
                }
            }
        }
        else if event.type == .keyUp {
            switch event.keyCode {
            case Keycode.escape:
                if resignableUserOperations.contains(.escKey) {
                    _asyncResignFirstResponder(completed: completed)
                }
            case Keycode.tab:
                // Tapping tab key may change the first responder, so here to update the binding if needed
                DispatchQueue.main.async {
                    guard let window = self.window else { return }
                    completed(self.frIsFirstResponder(in: window) ? .focused : .resigned)
                }
            default:
                break
            }
        }
    }
    private func _asyncResignFirstResponder(completed: @escaping (FREventChangeResult) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self, let window = self.window else { return }
            guard self.frIsFirstResponder(in: window) else { return }
            window.makeFirstResponder(nil)
            completed(.resigned)
        }
    }
}

// MARK: - helpers
fileprivate struct Keycode {
    static let tab                       : UInt16 = 0x30
    static let escape                    : UInt16 = 0x35
}
#endif
