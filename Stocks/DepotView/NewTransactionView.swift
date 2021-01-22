import SwiftUI

struct NewTransactionView: View {
    @EnvironmentObject private var stateController: StateController
    @Environment(\.presentationMode) private var presentationMode

    @State private var date = ""
    @State private var amount = ""
    @State private var transactionType = CashTransaction.Kind.income
    
    let depot: Depot
    
    var body: some View {
        Content(date: $date, amount: $amount, transactionType: $transactionType)
            .navigationBarTitle(Text("New Transaction"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: addButton)
    }
    
    var cancelButton: some View {
        Button(action: dismiss) {
            Text("Cancel")
        }
    }
    
    var addButton: some View {
        Button(action: addTransaction) {
            Text("Add")
        }
    }
    
    func addTransaction() {
        let amount = Money(from: self.amount)
        let date = Date.from(self.date)
        let transaction = CashTransaction(date: date, amount: amount, kind: transactionType)
        stateController.addCashTransaction(transaction, toDepot: depot)
        dismiss()
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
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
                .navigationBarTitle(Text("New Transaction"), displayMode: .inline)
        }
    }
}

extension Date {
    static func from(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        return dateFormatter.date(from: string) ?? Date()
    }
}
