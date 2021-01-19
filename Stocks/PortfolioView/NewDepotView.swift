import SwiftUI

struct NewDepotView: View {
    @EnvironmentObject private var stateController: StateController
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name: String = ""
    @State private var cash: String = ""
    
    var body: some View {
        Content(name: $name, cash: $cash, cancel: dismiss, save: save)
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func save() {
        stateController.addDepot(named: name, withCash: cash)
        dismiss()
    }
}

extension NewDepotView {
    struct Content: View {
        @Binding var name: String
        @Binding var cash: String
       
        let cancel: () -> Void
        let save: () -> Void

        var body: some View {
            List {
                Section(header: Text("Depot Data")) {
                    TextField("Name", text: $name)
                    TextField("Cash", text: $cash)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("New Depot")
            .navigationBarItems(leading: cancelButton, trailing: addButton)
        }
        
        var cancelButton: some View {
            Button(action: cancel, label: {
                Text("Cancel")
            })
        }
        
        var addButton: some View {
            Button(action: save, label: {
                Text("Add")
            })
        }
    }
}

struct DepotEditView_Previews: PreviewProvider {
    static var previews: some View {
        NewDepotView.Content(name: .constant(""), cash: .constant(""), cancel: {}, save: {})
    }
}
