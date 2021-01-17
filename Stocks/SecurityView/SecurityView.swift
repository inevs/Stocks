import SwiftUI

struct SecurityDetails {
    let symbol: String
    let name: String
}

struct SecurityView: View {
    @EnvironmentObject var depotData: DepotData
    let securityDetails: SecurityDetails
    @State private var isShowingSheet = false
    
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
//                    transactionType = .buy
                    isShowingSheet.toggle()
                })
                Spacer()
                Button("Sell", action: {
//                    transactionType = .sell
                    isShowingSheet.toggle()
                })
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $isShowingSheet) {
            SecurityOrderView()
                .environmentObject(depotData)
        }
    }
}

struct SecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecurityView(securityDetails: SecurityDetails(symbol: "AAPL", name: "Apple"))
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
