import SwiftUI

struct NewTransactionView: View {
    enum Screens: String, Identifiable, CaseIterable {
        case cash = "Cash", order = "Order"
        var id: Screens { self }
    }
    
    @EnvironmentObject private var stateController: StateController
    @Environment(\.presentationMode) private var presentationMode

    @State private var cashTransactionData = CashTransaction.Data()
    @State private var orderTransactionData = OrderTransaction.Data()
    @State private var selectedScreen = Screens.cash

    let depot: Depot
    let screens = ["Cash", "Order"]

    
    var body: some View {
        VStack {
            Picker(selection: $selectedScreen, label: Text("")) {
                ForEach(Screens.allCases) { screen in
                    Text(screen.rawValue).tag(screen)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
            switch selectedScreen {
            case .cash:
                CashContent(data: $cashTransactionData)
            case .order:
                OrderContent(orderData: $orderTransactionData)
            }
        }
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
        switch selectedScreen {
        case .cash:
            let transaction = CashTransaction(from: self.cashTransactionData)
            stateController.addCashTransaction(transaction, toDepot: depot)
        case .order:
            let security = Security(symbol: self.orderTransactionData.security.symbol, name: self.orderTransactionData.security.name)
            let transaction = OrderTransaction(from: self.orderTransactionData, security: security)
            stateController.addOrderTransaction(transaction, toDepot: depot)
        }
        dismiss()
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

extension NewTransactionView {
    struct CashContent: View {
        @Binding var data: CashTransaction.Data
        
        var body: some View {
            Form {
                DatePicker("Date", selection: $data.date, displayedComponents: [.date])
                TextField("Amount", text: $data.amount)
                    .keyboardType(.decimalPad)
                TextField("Beneficiary", text: $data.beneficiary)
                Picker(selection: $data.transactionType, label: Text("Type")) {
                    ForEach(CashTransaction.Kind.allCases) { kind in
                        Text(kind.rawValue).tag(kind)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

extension NewTransactionView {
    struct OrderContent: View {
        @Binding var orderData: OrderTransaction.Data
        
        var body: some View {
            Form {
                Section(header: Text("Security")) {
                    TextField("Symbol", text: $orderData.security.symbol)
                    TextField("Name", text: $orderData.security.name)
                }
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                Section(header: Text("Order details")) {
                    DatePicker("Date", selection: $orderData.date, displayedComponents: [.date])
                    TextField("Amount", text: $orderData.amount)
                        .keyboardType(.decimalPad)
                    TextField("Price", text: $orderData.price)
                        .keyboardType(.decimalPad)
                    TextField("Fees", text: $orderData.fees)
                        .keyboardType(.decimalPad)
                    TextField("Tax", text: $orderData.tax)
                        .keyboardType(.decimalPad)
                }
                Section {
                    Picker(selection: $orderData.transactionType, label: Text("Type")) {
                        ForEach(OrderTransaction.Kind.allCases) { kind in
                            Text(kind.rawValue).tag(kind)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                NewTransactionView.CashContent(data: .constant(CashTransaction.Data()))
                    .navigationBarTitle(Text("New Transaction"), displayMode: .inline)
            }
            NavigationView {
                NewTransactionView.OrderContent(orderData: .constant(OrderTransaction.Data()))
            }
        }
    }
}
