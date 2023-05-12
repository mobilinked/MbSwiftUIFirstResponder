//
//  DemoView.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/3.
//
#if os(macOS)
import SwiftUI
import MbSwiftUIFirstResponder

// MARK: - demo
struct DemoView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var notes: String = ""
    
    @State var firstResponder: FirstResponders? = nil
    
    var body: some View {
        VStack {
            HStack {
                TextField("Name", text: $name)
                    .firstResponder(id: FirstResponders.name, firstResponder: $firstResponder)
            
                Button("Edit") {
                    firstResponder = .name
                }
            }
            
            HStack {
                TextField("Email", text: $email)
                    .firstResponder(id: FirstResponders.email, firstResponder: $firstResponder, resignableUserOperations: .all)

                Button("Edit") {
                    firstResponder = .email
                }
            }

            HStack {
                TextEditor(text: $notes)
                    .firstResponder(id: FirstResponders.notes, firstResponder: $firstResponder, resignableUserOperations: .all)
                    .frame(height: 100)


                Button("Edit") {
                    firstResponder = .notes
                }
            }
            
            Button("Reset first responder") {
                firstResponder = nil
            }
        }
        .padding()
        .frame(width: 480)
    }
    
    enum FirstResponders: Int {
        case name
        case email
        case notes
    }
}

// MARK: - preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
#endif
