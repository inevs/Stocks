import Foundation

struct Depot: Identifiable, Codable {
    let id: UUID
    var name: String
    private (set) var balance: Money
    var cashTransactions: [CashTransaction]
    
    init(id: UUID = UUID(), name: String, initialBalance: Money) {
        self.id = id
        self.name = name
        self.balance = initialBalance
        self.cashTransactions = [
            CashTransaction(date: Date(), amount: initialBalance, kind: .income, beneficiary: "Initial Balance")
        ]
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
}

extension Depot {
    var currentValue: Money {
        balance
    }
}
