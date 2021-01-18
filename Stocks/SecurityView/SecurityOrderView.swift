import SwiftUI

struct SecurityOrderData {
    let name: String
}

struct SecurityOrderView: View {
    @Binding var securityAllocationData: SecurityAllocation.Data
    let orderAction: ()->()
    
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
                Button(action: orderAction) {
                    Text("Order")
                }
            }
        }
        .navigationBarTitle(Text(securityAllocationData.name), displayMode: .inline)
    }
}

struct SecurityOrderView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityOrderView(securityAllocationData: .constant(SecurityAllocation.Data()), orderAction: {})
    }
}
