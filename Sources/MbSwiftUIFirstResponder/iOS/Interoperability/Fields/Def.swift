//
//  Def.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/2.
//
#if os(iOS)
import SwiftUI

/// Define the impact on changing the first responder status to a inputer after received a tracked event from the window
enum FRTapChangeResult {
    case resigned // the event causes the first responder resigned (for example, clicked outside)
    case focused // after the event, the first responder changed to be focused (by system). For example, after tapped on the text field, the text field becomes the first responder
}

/// Define the base behavior of the textfield and textview
protocol FirstResponderable: AnyObject {
    associatedtype ResignableUserOperations: Equatable
    
    func frIsFirstResponder() -> Bool
    func frDidTap(inside: Bool, resignableUserOperations: ResignableUserOperations, completed: @escaping (FRTapChangeResult) -> Void)
}
typealias FirstResponderableField = FirstResponderable & UIView

#endif
