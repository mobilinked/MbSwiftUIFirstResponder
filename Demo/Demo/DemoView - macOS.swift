//
//  ContentView.swift
//  Demo
//
//  Created by Dev on 2023/5/12.
//
#if os(macOS)

import SwiftUI
import MbSwiftUIFirstResponder

// MARK: - demo
struct DemoView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var notes: String = ""
    
    enum FirstResponders: Int {
        case name
        case email
        case password
        case notes
    }
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
                SecureField("Password", text: $password)
                    .firstResponder(id: FirstResponders.password, firstResponder: $firstResponder, resignableUserOperations: .all)

                Button("Edit") {
                    firstResponder = .password
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}

#endif
