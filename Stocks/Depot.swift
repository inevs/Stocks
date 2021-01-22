import Foundation

struct Depot: Identifiable, Codable {
    let id: UUID
    var name: String
    private (set) var balance: Money
    var cashTransactions: [CashTransaction]
    var orderTransactions: [OrderTransaction]
    var securities: [String: Decimal]
    
    init(id: UUID = UUID(), name: String, initialBalance: Money) {
        self.id = id
        self.name = name
        self.balance = initialBalance
        self.cashTransactions = [
            CashTransaction(date: Date(), amount: initialBalance, kind: .income, beneficiary: "Initial Balance")
        ]
        self.orderTransactions = []
        self.securities = [:]
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
        let symbol = transaction.security.symbol
        let amount = securities[symbol] ?? 0.0
        let newAmount: Decimal
        switch transaction.kind {
        case .buy:
            newAmount = amount + transaction.amount
        case .sell:
            newAmount = amount - transaction.amount
        }
        if newAmount < 0.0 {
            print("Error: selling too much")
        } else {
            securities[symbol] = newAmount
            let cashTransaction = CashTransaction(from: transaction)
            addCashTransaction(cashTransaction)
        }
    }
}

extension Depot {
    var currentValue: Money {
        balance
    }
}
