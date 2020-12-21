//
//  MbFirstResponder Utility.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/1.
//
#if os(macOS)
import SwiftUI

private var frWindowCoordinatorKey: Void?
extension NSWindow {
    var frCoordinator: FRWindowEventPublisher? {
        get {
            return objc_getAssociatedObject(self, &frWindowCoordinatorKey) as? FRWindowEventPublisher
        }
        set {
            objc_setAssociatedObject(
                self,
                &frWindowCoordinatorKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

extension NSView {
    func frFindLinkedField<Field: FirstResponderableField>() -> Field? {
        // for a interoperability view (nsview), SwiftUI may enclose it in multiple levels of other host view, here is to find the root host view
        guard let rootSwiftUIHostView = self.frFindHostSwiftUIView() else { return nil }
        // and the actual linked field is about at the same tree hierarchy
        // here to find the linked field from the parent of the root host view
        guard let containerView = rootSwiftUIHostView.superview else { return nil }
        let location = rootSwiftUIHostView.frame.origin
        for nsView in containerView.subviews {
            if nsView !== rootSwiftUIHostView && nsView.frame.origin == location {
                if let field: Field = nsView.frEnclosedFirstResponderField() {
                    return field
                }
            }
        }
        return nil
    }
    
    // navigate down the children tree to find the enclosed text field
    private func frEnclosedFirstResponderField<Field: FirstResponderableField>() -> Field? {
        if let field = self as? Field {
            return field
        }
        else if self.subviews.isEmpty == false {
            for subView in self.subviews {
                if let field: Field = subView.frEnclosedFirstResponderField() {
                    return field
                }
            }
            return nil
        }
        else {
            return nil
        }
    }
    
    /// Explore up to the parent hierarchy, to check the view with multiple subviews
    private func frFindHostSwiftUIView() -> NSView? {
        if let parent = self.superview {
            if parent.subviews.count > 1 {
                return self
            }
            else {
                return parent.frFindHostSwiftUIView()
            }
        }
        else {
            return nil
        }
    }
}
#endif
