//
//  Def.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/2.
//
#if os(iOS)
import SwiftUI

extension TextField {
    public func firstResponder<V: Hashable>(id: V, firstResponder: Binding<V?>, resignableUserOperations: MbFirstResponder.TextField.ResignableUserOperations = .all) -> some View {
        self
            .background(MbFRHackView<V, UITextField>(id: id, firstResponder: firstResponder, resignableUserOperations: resignableUserOperations))
    }
}

extension TextEditor {
    public func firstResponder<V: Hashable>(id: V, firstResponder: Binding<V?>, resignableUserOperations: MbFirstResponder.TextEditor.ResignableUserOperations = .all) -> some View {
        self
            .background(MbFRHackView<V, UITextView>(id: id, firstResponder: firstResponder, resignableUserOperations: resignableUserOperations))
    }
}
#endif
