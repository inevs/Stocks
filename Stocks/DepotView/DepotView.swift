import SwiftUI

struct DepotView: View {
    let depot: Depot
    
    var body: some View {
        VStack {
            List {
                ChangesView()
                Spacer()
                ForEach(depot.securityAllocations) { securityAllocation in
                    NavigationLink(destination: SecurityView(securityDetails: SecurityDetails(symbol: securityAllocation.security.symbol, name: securityAllocation.security.name))) {
                        SecurityRow(securityAllocation: securityAllocation)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle(Text(depot.name), displayMode: .inline)
    }
}

struct DepotView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepotView(depot: comdirect)
        }
    }
}

struct ChangesView: View {
    var body: some View {
        HStack {
            HStack {
                PeriodView(period: .day)
                Divider()
                PeriodView(period: .month)
                Divider()
                PeriodView(period: .year)
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
            HStack {
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
