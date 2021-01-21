import SwiftUI

struct SecurityDetails {
    let symbol: String
    let name: String
    
    init(symbol: String, name: String) {
        self.symbol = symbol
        self.name = name
    }

    init(from securityAllocation: SecurityAllocation) {
        self.init(symbol: securityAllocation.security.symbol, name: securityAllocation.security.name)
    }
}

struct SecurityView: View {
    @EnvironmentObject var depotData: StateController
    let securityDetails: SecurityDetails
    let depot: Depot
    @State private var isShowingSheet = false
    @State private var securityAllocationData = SecurityAllocation.Data()
    @State private var transactionType: TransactionType = .buy
    
    var body: some View {
        Content(securityDetails: securityDetails, buy: buy, sell: sell)
        .sheet(isPresented: $isShowingSheet) {
            SecurityOrderView(securityAllocationData: $securityAllocationData, orderAction: order, cancel: dismiss)
        }
    }
    
    func order() {
        securityAllocationData.name = securityDetails.name
        securityAllocationData.symbol = securityDetails.symbol
        switch transactionType {
        case .buy:
            depotData.addSecurityAllocation(withData: securityAllocationData, toDepot: depot)
        case .sell:
            depotData.removeSecurityAllocation(withData: securityAllocationData, fromDepot: depot)
        }
        dismiss()
    }
    
    func dismiss() {
        isShowingSheet = false
    }
    
    func buy() {
        transactionType = .buy
        isShowingSheet = true
    }
    
    func sell() {
        transactionType = .sell
        isShowingSheet = true
    }
    
    enum TransactionType {
        case buy, sell
    }
}

extension SecurityView {
    struct Content: View {
        let securityDetails: SecurityDetails
        
        let buy: () -> Void
        let sell: () -> Void
        
        var body: some View {
            List {
                Section(header: Text("Security")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(securityDetails.name)
                            .font(.title)
                            Spacer()
                        }
                        Text(securityDetails.symbol)
                            .font(.subheadline)
                    }
                }
                Section(header: Text("Market Data")) {
                    StockFinancialView(symbol: securityDetails.symbol)
                }
                Section {
                    HStack {
                        Button(action: buy) {
                            Text("Buy")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: sell) {
                            Text("Sell")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                Section(header: Text("Your allocations")) {
                    HStack {
                        Text("Current Allocation:")
                        Spacer()
                        Text("10")
                    }
                    HStack {
                        Text("Buying Value")
                        Spacer()
                        Text("3.456 EUR")
                    }
                    HStack {
                        Text("Current Value")
                        Spacer()
                        Text("4.556 EUR")
                    }
                    HStack {
                        Text("Loss / Gain")
                        Spacer()
                        Text("456 EUR")
                    }
                    HStack {
                        Text("Percentage")
                        Spacer()
                        Text("5.6 %")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .padding()
        }
    }
}

struct SecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecurityView.Content(securityDetails: SecurityDetails(symbol: "AAPL", name: "Apple"), buy: {}, sell: {})
        }
    }
}

struct StockFinancialView: View {
    var symbol: String
    @State private var currentPrice = Money(amount: 0.0)
    @State private var absoluteChange = Money(amount: 0.0)
    @State private var percentageChange:Decimal = 0.0

    var body: some View {
        VStack(alignment: .leading) {
            Text(currentPrice.string())
                .padding(.top)
            HStack {
                Text("\(percentageChange.string()) %")
                    .foregroundColor(percentageChange.isNegative() ? .red : .green)
                Text(absoluteChange.string())
                    .foregroundColor(absoluteChange.isNegative() ? .red : .green)
                    .padding(.leading)
            }
        }
        .onAppear(perform: getQuotes)
    }
    
    func getQuotes() {
        getQuotesForSymbol(symbol: symbol) { result in
            switch result {
            case .success(let quote):
                currentPrice = quote.currentPrice
                absoluteChange = quote.changeAbsolute
                percentageChange = quote.changePercentage
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getQuotesForSymbol(symbol: String, completion: (Result<Quote, Error>) -> Void) {
        completion(.success(Quote()))
    }
}

struct Quote {
    let currentPrice = Money(amount: 420.0)
    let changeAbsolute = Money(amount: 20.0)
    let changePercentage: Decimal = 3.9
}
