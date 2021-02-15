import Foundation

struct CashTransaction: Codable, Identifiable {
    enum Kind: String, Codable, CaseIterable, Identifiable {
        case withdraw = "Withdraw",
             income = "Income"
        
        var id: Kind { self }
    }

    let id: UUID
    let date: Date
    let amount: Money
    let kind: Kind
    let beneficiary: String

    init(id: UUID = UUID(), date: Date, amount: Money, kind: Kind, beneficiary: String) {
        self.id = id
        self.date = date
        self.amount = amount
        self.kind = kind
        self.beneficiary = beneficiary
    }
    
    init(from order: OrderTransaction) {
        self.id = UUID()
        self.date = order.date
        switch order.kind {
        case .buy:
            self.kind = .withdraw
            self.beneficiary = "Buy \(order.security.name)"
            self.amount = order.amount * order.price + order.fees + order.tax
        case .sell:
            self.kind = .income
            self.beneficiary = "Sell \(order.security.name)"
            self.amount = order.amount * order.price - order.fees - order.tax
        }
    }
}

extension CashTransaction {
    struct Data {
        var date: Date
        var amount: String
        var transactionType: CashTransaction.Kind
        var beneficiary: String
        
        init() {
            self.date = Date()
            self.amount = ""
            self.transactionType = .income
            self.beneficiary = ""
        }
    }
    
    init(from data: Data) {
        self.id = UUID()
        self.date = data.date
        self.amount = Money(from: data.amount)
        self.kind = data.transactionType
        self.beneficiary = data.beneficiary
    }
}
