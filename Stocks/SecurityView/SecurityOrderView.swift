import SwiftUI

struct SecurityOrderData {
    let name: String
}

struct SecurityOrderView: View {
    @EnvironmentObject var depotData: DepotData
    @Environment(\.presentationMode) var presentationMode
    @State private var securityAllocationData = SecurityAllocation.Data()
    
    var body: some View {
        Form {
            Section {
//                Picker(selection: $selectedDepot, label: Text("Depot")) {
//                    ForEach(0 ..< portfolio.depots.count) {
//                        Text(portfolio.depots[$0].name)
//                    }
//                }
            }
            Section(header: Text("Security")) {
//                TextField("Date", text: $date)
                TextField("Amount", text: $securityAllocationData.amount)
//                TextField("Price", text: $securityAllocationData)
            }
            HStack {
                Spacer()
                Button("Order", action: {
                    depotData.depots.append(Depot(name: "Foo", cash: Money(amount: 0.0)))
                    presentationMode.wrappedValue.dismiss()
                })
                Spacer()
            }
        }
        .navigationBarTitle(Text(securityAllocationData.name), displayMode: .inline)
    }
}

struct SecurityOrderView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityOrderView()
            .environmentObject(DepotData(depots: testDepots))
    }
}
