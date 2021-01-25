import Foundation

class StateController: ObservableObject {
    @Published var portfolio: Portfolio
    
    private let storageController = StorageController()
    
    init(portfolio: Portfolio = Portfolio()) {
        self.portfolio = storageController.fetchPortfolio()
    }
    
    func addDepot(named name: String, withCash cash: String) {
        let depot = Depot(name: name, initialBalance: Money(from: cash))
        portfolio.depots.append(depot)
        storageController.save(portfolio)
    }
    
    func deleteDepots(atIndexSet indexSet: IndexSet) {
        indexSet.forEach { index in
            portfolio.depots.remove(at: index)
        }
        storageController.save(portfolio)
    }
    
    func addCashTransaction(_ transaction: CashTransaction, toDepot depot: Depot) {
        guard let depotIndex = portfolio.depots.firstIndex(where: { $0.id == depot.id }) else { return }
        portfolio.depots[depotIndex].addCashTransaction(transaction)
        storageController.save(portfolio)
    }

    func addOrderTransaction(_ transaction: OrderTransaction, toDepot depot: Depot) {
        guard let depotIndex = portfolio.depots.firstIndex(where: { $0.id == depot.id }) else { return }
        portfolio.depots[depotIndex].addOrderTransaction(transaction)
        storageController.save(portfolio)
    }

}
