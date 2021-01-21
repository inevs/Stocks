import SwiftUI

struct SecurityOrderData {
    let name: String
}

struct SecurityOrderView: View {
    @Binding var securityAllocationData: SecurityAllocation.Data
    let orderAction: () -> Void
    let cancel: () -> Void
    
    var body: some View {
        Content(securityAllocationData: $securityAllocationData, orderAction: orderAction, cancel: cancel)
    }
}

extension SecurityOrderView {
    struct Content: View {
        @Binding var securityAllocationData: SecurityAllocation.Data
        let orderAction: () -> Void
        let cancel: () -> Void
        
        var body: some View {
            Form {
                Section {
    //                Picker(selection: $selectedDepot, label: Text("Depot")) {
    //                    ForEach(0 ..< portfolio.depots.count) {
    //                        Text(portfolio.depots[$0].name)
    //                    }
    //                }
                }
                Section(header: Text("Security Info")) {
                    VStack {
                        Text("Apple")
                        Text("AAPL")
                    }
                }
                Section(header: Text("Order Data")) {
    //                TextField("Date", text: $date)
                    TextField("Amount", text: $securityAllocationData.amount)
                        .keyboardType(.decimalPad)
    //                TextField("Price", text: $securityAllocationData)
                }
                Section {
                    HStack {
                        Button(action: cancel, label: {
                            Text("Cancel")
                                .foregroundColor(.red)
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: orderAction) {
                            Text("Order")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .navigationBarTitle(Text(securityAllocationData.name), displayMode: .inline)
        }
    }
    
}

struct SecurityOrderView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityOrderView.Content(securityAllocationData: .constant(SecurityAllocation.Data()), orderAction: {}, cancel: {})
    }
}
