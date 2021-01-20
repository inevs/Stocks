import SwiftUI

struct DepotView: View {
    @EnvironmentObject var stateController: StateController
    let depot: Depot
    
    var depotIndex: Int {
        guard let index = stateController.depots.firstIndex(where: { $0.name == depot.name}) else  {
            fatalError()
        }
        return index
    }
    
    var body: some View {
        Content(depot: stateController.depots[depotIndex])
    }
}

extension DepotView {
    struct Content: View {
        let depot: Depot
        
        var body: some View {
            List {
                ChangesView()
                Spacer()
                ForEach(depot.securityAllocations) { securityAllocation in
                    NavigationLink(destination: SecurityView(securityDetails: SecurityDetails(from: securityAllocation), depot: depot)) {
                        SecurityRow(securityAllocation: securityAllocation)
                    }
                }
                Spacer()
                NavigationLink(destination: SearchSecurityView(depot: depot)) {
                    Label("Search Securities", systemImage: "magnifyingglass")
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text(depot.name), displayMode: .inline)
        }
    }
}

struct DepotView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepotView.Content(depot: comdirect)
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
