import Foundation

class StateController: ObservableObject {
    @Published var portfolio: Portfolio

    private let storageController = StorageController()

    init(portfolio: Portfolio = Portfolio()) {
        self.portfolio = storageController.fetchPortfolio()
    }

    func addDepot(named name: String, withCash cash: String) {
        portfolio.addDepot(named: name, withCash: cash)
        storageController.save(portfolio)
    }

    func deleteDepots(atIndexSet indexSet: IndexSet) {
        portfolio.deleteDepots(atIndexSet: indexSet)
        storageController.save(portfolio)
    }

    func addCashTransaction(_ transaction: CashTransaction, toDepot depot: Depot) {
        portfolio.addCashTransaction(transaction, toDepot: depot)
        storageController.save(portfolio)
    }

    func addOrderTransaction(_ transaction: OrderTransaction, toDepot depot: Depot) {
        portfolio.addOrderTransaction(transaction, toDepot: depot)
        storageController.save(portfolio)
    }

    func updateQuotes() {
        let financeAPI = FinanceAPI.shared
        let securities = portfolio.allSecurities
        securities.forEach { security in
            financeAPI.getQuoteForSymbol(symbol: security.symbol) { [self] result in
                switch result {
                case .success(let quote):
                    portfolio.update(security: security, withPrice: quote.currentPrice)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}
