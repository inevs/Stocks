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
        VStack(alignment: .leading) {
            HStack {
                Text(securityDetails.name)
                .font(.title)
                Spacer()
            }
            Text(securityDetails.symbol)
                .font(.subheadline)
            StockFinancialView(symbol: securityDetails.symbol)
            HStack {
                Button("Buy", action: {
                    transactionType = .buy
                    isShowingSheet.toggle()
                })
                Spacer()
                Button("Sell", action: {
                   transactionType = .sell
                    isShowingSheet.toggle()
                })
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isShowingSheet) {
            SecurityOrderView(securityAllocationData: $securityAllocationData) {
                securityAllocationData.name = securityDetails.name
                securityAllocationData.symbol = securityDetails.symbol
                switch transactionType {
                case .buy:
                    depotData.addSecurityAllocation(withData: securityAllocationData, toDepot: depot)
                case .sell:
                    depotData.removeSecurityAllocation(withData: securityAllocationData, fromDepot: depot)
                }
                isShowingSheet = false
            }
        }
    }
    
    enum TransactionType {
        case buy, sell
    }
}

struct SecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecurityView(securityDetails: SecurityDetails(symbol: "AAPL", name: "Apple"), depot: comdirect)
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
