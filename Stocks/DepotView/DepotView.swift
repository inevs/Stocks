import SwiftUI

struct DepotView: View {
    @EnvironmentObject var stateController: StateController
    let depot: Depot
    @State private var addingTransaction: Bool = false
    
    var body: some View {
        Content(depot: binding(for: depot)) {
            newTransaction()
        }
        .sheet(isPresented: $addingTransaction) {
            NavigationView {
                NewTransactionView(depot: depot)
            }
            .environmentObject(self.stateController)
        }
    }
    
    func newTransaction() {
        addingTransaction = true
    }
        
    private func binding(for depot: Depot) -> Binding<Depot> {
        guard let depotIndex = stateController.portfolio.depots.firstIndex(where: { $0.id == depot.id }) else {
            fatalError("Can't find depot in array")
        }
        return $stateController.portfolio.depots[depotIndex]
    }

}

extension DepotView {
    struct Content: View {
        @Binding var depot: Depot
        let addTransaction: () -> Void
        
        var body: some View {
            VStack {
                ChangesView()
                    .frame(height: 100.0)
                Spacer()
                Text("Balance: \(depot.balance.string())")
                Spacer()
                List {
                    ForEach(depot.securityAllocations) { allocation in
                        HStack {
                            Text("\(allocation.amount.string()) \(allocation.security.symbol)")
                            Spacer()
                            Text("\((allocation.amount * allocation.security.latestPrice).string())")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: TransactionHistoryView(depot: depot)) {
                        Text("Transaction History")
                    }
                }
                .listStyle(PlainListStyle())
                Spacer()
                AddButton(title: "Add Transaction", action: addTransaction)
            }
                
            .navigationBarTitle(Text(depot.name), displayMode: .inline)
        }        
    }
}

struct DepotView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepotView.Content(depot: .constant(TestData.comdirect), addTransaction: {})
        }
    }
}


struct ChangesView: View {
    var body: some View {
        HStack {
            HStack() {
                PeriodView(period: .day)
                    .frame(minWidth: 0, maxWidth: .infinity)
                Divider()
                PeriodView(period: .month)
                    .frame(minWidth: 0, maxWidth: .infinity)
                Divider()
                PeriodView(period: .year)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct PeriodView: View {
    let period: Period
    
    var body: some View {
        VStack {
            switch period {
            case .day:
                Text("Today")
            case .month:
                Text("This Month")
            case .year:
                Text("This Year")
            }
            VStack(alignment: .leading) {
                Text("+237,00 EUR")
                Text("+10 %")
            }
            .font(.caption)
        }
    }
}

enum Period {
    case day, month, year
}
