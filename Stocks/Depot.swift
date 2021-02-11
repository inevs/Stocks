import Foundation

struct Depot: Identifiable, Codable {
    let id: UUID
    var name: String
    var cashTransactions: [CashTransaction]
    var orderTransactions: [OrderTransaction]
    private (set) var balance: Money
    private (set) var securityAllocations: [SecurityAllocation]
    
    init(id: UUID = UUID(), name: String, initialBalance: Money) {
        self.id = id
        self.name = name
        self.balance = initialBalance
        self.cashTransactions = [
            CashTransaction(date: Date(), amount: initialBalance, kind: .income, beneficiary: "Initial Balance")
        ]
        self.orderTransactions = []
        self.securityAllocations = []
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
        let security = transaction.security
        let securityAllocation = allocation(for: security) ?? SecurityAllocation(amount: 0.0, security: security)
        let amount = securityAllocation.amount
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
            if let index = securityAllocations.firstIndex(of: securityAllocation) {
                securityAllocations.remove(at: index)
            }
            securityAllocations.append(SecurityAllocation(amount: newAmount, security: security))
            let cashTransaction = CashTransaction(from: transaction)
            addCashTransaction(cashTransaction)
        }
    }
    
    func allocation(for security: Security) -> SecurityAllocation? {
        return securityAllocations.first(where: { $0.security == security })
    }
}

extension Depot {
    var currentValue: Money {
        balance
    }
}

struct SecurityAllocation: Identifiable, Codable, Equatable {
    let amount: Decimal
    let security: Security
    
    var id: String { security.symbol }
    
    static func ==(lhs: SecurityAllocation, rhs: SecurityAllocation) -> Bool {
        return lhs.security == rhs.security && lhs.amount == rhs.amount
    }
}

