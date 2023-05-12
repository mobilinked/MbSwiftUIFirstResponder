//
//  ContentView.swift
//  Demo
//
//  Created by Dev on 2023/5/12.
//
//
//  DemoView.swift
//  MbSwiftFirstResponder
//
//  Created by QuickPlan.app on 2020/12/3.
//
#if os(iOS)
import SwiftUI
import MbSwiftUIFirstResponder

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
        NavigationView {
            List {
                TextField("Name", text: $name)
                        .firstResponder(id: FirstResponders.name, firstResponder: $firstResponder, resignableUserOperations: .all)
                
                TextField("Email", text: $email)
                    .firstResponder(id: FirstResponders.email, firstResponder: $firstResponder, resignableUserOperations: .all)
                
                SecureField("Password", text: $password)
                    .firstResponder(id: FirstResponders.password, firstResponder: $firstResponder, resignableUserOperations: .all)

                TextEditor(text: $notes)
                    .firstResponder(id: FirstResponders.notes, firstResponder: $firstResponder, resignableUserOperations: .all)
                    .frame(height: 100)
                    .padding(.leading, -3)
                    .placeholder(notes.isEmpty ? "Notes" : "")
            }
            .listStyle(InsetGroupedListStyle())
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            
            .toolbar {
                ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button("Name") {
                        firstResponder = .name
                    }
                    Button("Email") {
                        firstResponder = .email
                    }
                    Button("Password") {
                        firstResponder = .password
                    }
                    Button("Notes") {
                        firstResponder = .notes
                    }
                }
                
                ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button("Reset") {
                        firstResponder = nil
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension View {
    func placeholder(_ text: String) -> some View {
        self.background(
            VStack {
                Text(text).foregroundColor(.primary).opacity(0.25)
                    .padding(.top, 8)
            }
                .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
#endif
