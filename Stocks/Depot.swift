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
        balance = initialBalance
        cashTransactions = [
            CashTransaction(date: Date(), amount: initialBalance, kind: .income, beneficiary: "Initial Balance")
        ]
        orderTransactions = []
        securityAllocations = []
    }
    
    mutating func addCashTransaction(_ transaction: CashTransaction) {
        cashTransactions.append(transaction)
        switch transaction.kind {
        case .income:
            balance += transaction.amount
        case .withdraw:
            balance -= transaction.amount
        }
    }

    mutating func addOrderTransaction(_ transaction: OrderTransaction) {
        orderTransactions.append(transaction)
        var security = transaction.security
        security.latestPrice = transaction.price
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
            if newAmount > 0 {
                securityAllocations.append(SecurityAllocation(amount: newAmount, security: security))
            }
            let cashTransaction = CashTransaction(from: transaction)
            addCashTransaction(cashTransaction)
        }
    }

    mutating func update(security: Security, withPrice price: Money) {
        if let index = securityAllocations.firstIndex(where: { $0.security == security }) {
            securityAllocations[index].security.latestPrice = price
        }
    }
    
    func allocation(for security: Security) -> SecurityAllocation? {
        securityAllocations.first(where: { $0.security == security })
    }

    var securities: [Security] {
        securityAllocations.map { $0.security }
    }
}

extension Depot {
    var currentValue: Money {
        var value = Money.zero
        securityAllocations.forEach { allocation in
            let securityValue = allocation.security.latestPrice * allocation.amount
            value += securityValue
        }
        value += balance
        return value
    }
}

struct SecurityAllocation: Identifiable, Codable, Equatable {
    let amount: Decimal
    var security: Security
    
    var id: String { security.symbol }
    
    static func ==(lhs: SecurityAllocation, rhs: SecurityAllocation) -> Bool {
        lhs.security == rhs.security && lhs.amount == rhs.amount
    }
}

