import SwiftUI

struct DepotView: View {
    @EnvironmentObject var depotData: DepotData
    let depot: Depot
    
    var body: some View {
        VStack {
            List {
                ChangesView()
                Spacer()
                ForEach(depot.securityAllocations) { securityAllocation in
                    NavigationLink(destination: SecurityView(securityDetails: SecurityDetails(symbol: securityAllocation.security.symbol, name: securityAllocation.security.name))
                                    .environmentObject(depotData)
                    ) {
                        SecurityRow(securityAllocation: securityAllocation)
                    }
                }
                Spacer()
                NavigationLink(destination: SearchSecurityView()) {
                    Label("Search Securities", systemImage: "magnifyingglass")
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle(Text(depot.name), displayMode: .inline)
    }
}

struct DepotView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepotView(depot: comdirect)
                .environmentObject(DepotData(depots: testDepots))
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

struct SecurityRow: View {
    let securityAllocation: SecurityAllocation
    
    var body: some View {
        HStack {
            Text("\(securityAllocation.amount.string()) \(securityAllocation.security.name)")
            Spacer()
            Text("\((securityAllocation.amount * securityAllocation.security.price).string())")
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
