//
//  Interoperability.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/2.
//
#if os(iOS)
import SwiftUI

// NARK: - implementation
// MARK: textfield
struct MbFRHackView<ID: Hashable, Field: FirstResponderableField>: UIViewRepresentable {
    private let id: ID
    @Binding private var firstResponder: ID?
//    {
//        didSet {
//            print("First Responder changed to \(String(describing: firstResponder))")
//        }
//    }
    
    private let resignableUserOperations: Field.ResignableUserOperations
    
    init(id: ID, firstResponder: Binding<ID?>, resignableUserOperations: Field.ResignableUserOperations) {
//        print("init")
        self.id = id
        self._firstResponder = firstResponder
        self.resignableUserOperations = resignableUserOperations
    }
    
    func makeUIView(context: Context) -> MbFRHackNSView<Field> {
//        print("makeNSView")
        return MbFRHackNSView(
            isFirstResponder: id == firstResponder,
            eventsAllowedToResignFirstResponder: resignableUserOperations) { focused in
            // change the binding value after the first responder status changed by windows event (NOT changed programmaly)
            if focused {
                if firstResponder != id {
                    firstResponder = id
                }
            }
            else {
                if firstResponder == id {
                    firstResponder = nil
                }
            }
        }
    }
    
    func updateUIView(_ uiView: MbFRHackNSView<Field>, context: Context) {
//        print("updateNSView")
        DispatchQueue.main.async {
            uiView.update(firstResponder: id == firstResponder, resignableUserOperations: resignableUserOperations)
        }
    }
}

final class MbFRHackNSView<Field: FirstResponderableField>: UIView, FrEventObserver {
    private weak var field: Field? = nil
    private let initialFirstResponderStatus: Bool
    private var resignableUserOperations: Field.ResignableUserOperations
    
    // use the monitor if the first responder changed by the window event (NOT changed programmaly)
    // for example, click outside the field, the text field will resign the first responder
    // if the first responder status changed, the binding value should be changed
    private let firstResponderDidChangedByEvent: (Bool) -> Void
    
    init(
        isFirstResponder: Bool,
        eventsAllowedToResignFirstResponder: Field.ResignableUserOperations,
        firstResponderDidChangedByEvent: @escaping (Bool) -> Void) {
        self.initialFirstResponderStatus = isFirstResponder
        self.resignableUserOperations = eventsAllowedToResignFirstResponder
        self.firstResponderDidChangedByEvent = firstResponderDidChangedByEvent
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
//        Swift.print("didMoveToWindow")
        
        guard self.field == nil else { return }
        
        // On the iOS device, the other user interfaces may NOT be added after didMoveToWindow called
        // So here to call it in the main queue
        DispatchQueue.main.async { [weak self] in
            self?._analyzeAndInitializeTextFieldStatus()
            
            self?._initializeToTrackWindowTapGesture()
        }
    }
    func _analyzeAndInitializeTextFieldStatus() {
        guard field == nil else { return }
        // this hack view will be as the background of the SwiftUI field (TextField, TextEditor), so here to find the linked SwiftUI field
        field = self.frFindLinkedField()
        
        guard let field = self.field else { return }
        _update(isFirstResponder: initialFirstResponderStatus, newResignableUserOperations: self.resignableUserOperations, of: field)
    }
    func _initializeToTrackWindowTapGesture() {
        guard field != nil else { return } // make sure that the text field exists
        guard let window = self.window else { return }
        
        if let windowTapGesture = window.gestureRecognizers?.first(where: { $0 is FirstResponderTapGesture }) as? FirstResponderTapGesture {
            windowTapGesture.add(observer: self)
        }
        else {
            let windowTapGesture = FirstResponderTapGesture(from: self)
            window.addGestureRecognizer(windowTapGesture)
        }
    }
    
    func frDidTapInWindow(at pointInWindow: CGPoint) {
        guard let field = self.field else { return }
        
        let pointInField = field.convert(pointInWindow, from: nil)
        let tapInside = field.bounds.contains(pointInField)
        
        field.frDidTap(inside: tapInside, resignableUserOperations: resignableUserOperations) { result in
            switch result {
            case .resigned:
                self.firstResponderDidChangedByEvent(false)
            case .focused:
                self.firstResponderDidChangedByEvent(true)
            }
        }
    }
    
    // Update the first responder status programmaly
    func update(firstResponder: Bool, resignableUserOperations newResignableUserOperations: Field.ResignableUserOperations) {
        guard let fld = self.field else {
            return
        }
        _update(isFirstResponder: firstResponder, newResignableUserOperations: newResignableUserOperations, of: fld)
    }
    
    func _update(isFirstResponder: Bool, newResignableUserOperations: Field.ResignableUserOperations, of field: Field) {
        if self.resignableUserOperations != newResignableUserOperations {
            self.resignableUserOperations = newResignableUserOperations
        }
        
        let alreadyFirstResponder = field.isFirstResponder
        if alreadyFirstResponder != isFirstResponder {
            if isFirstResponder {
                field.becomeFirstResponder()
            }
            else {
                field.resignFirstResponder()
            }
        }
    }
}

#endif
