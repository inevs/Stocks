import Foundation

struct Depot: Identifiable, Codable {
    let id: UUID
    var name: String
    private (set) var balance: Money
    var cashTransactions: [CashTransaction]
    var orderTransactions: [OrderTransaction]
    
    init(id: UUID = UUID(), name: String, initialBalance: Money) {
        self.id = id
        self.name = name
        self.balance = initialBalance
        self.cashTransactions = [
            CashTransaction(date: Date(), amount: initialBalance, kind: .income, beneficiary: "Initial Balance")
        ]
        self.orderTransactions = []
    }
    
    mutating func addCashTransaction(_ transaction: CashTransaction) {
        self.cashTransactions.append(transaction)
        switch transaction.kind {
        case .income:
            balance += transaction.amount
        case .withdraw:
            balance -= transaction.amount
        }
    }
    
    mutating func addOrderTransaction(_ transaction: OrderTransaction) {
        self.orderTransactions.append(transaction)
    }
}

extension Depot {
    var currentValue: Money {
        balance
    }
}
