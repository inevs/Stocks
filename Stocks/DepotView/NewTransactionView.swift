import SwiftUI

struct NewTransactionView: View {
    @EnvironmentObject private var stateController: StateController

    @State private var date = ""
    @State private var amount = ""
    @State private var transactionType = CashTransaction.Kind.income
    
    let add: () -> Void
    let cancel: () -> Void

    var body: some View {
        Content(date: $date, amount: $amount, transactionType: $transactionType)
            .navigationBarTitle(Text("New Transaction"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: addButton)
    }
    
    var cancelButton: some View {
        Button(action: cancel) {
            Text("Cancel")
        }
    }
    
    var addButton: some View {
        Button(action: add) {
            Text("Add")
        }
    }
}

extension NewTransactionView {
    struct Content: View {
        @Binding var date: String
        @Binding var amount: String
        @Binding var transactionType: CashTransaction.Kind
        
        var body: some View {
            Form {
                TextField("Date", text: $date)
                    .keyboardType(.numbersAndPunctuation)
                TextField("Amount", text: $amount)
                Picker(selection: $transactionType, label: Text("Type")) {
                    ForEach(CashTransaction.Kind.allCases) { kind in
                        Text(kind.rawValue).tag(kind)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewTransactionView.Content(date: .constant(""), amount: .constant(""), transactionType: .constant(.income))
        }
    }
}
