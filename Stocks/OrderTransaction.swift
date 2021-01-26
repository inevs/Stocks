import Foundation

struct OrderTransaction: Codable, Identifiable {
    enum Kind: String, Codable, CaseIterable, Identifiable {
        case buy = "Buy",
             sell = "Sell"
        
        var id: Kind { self }
    }

    let id: UUID
    let date: Date
    let amount: Decimal
    let kind: Kind
    let security: Security
    let price: Money
    let fees: Money
    let tax: Money

    init(id: UUID = UUID(), date: Date, amount: Decimal, kind: Kind, security: Security, price: Money, fees: Money = Money.zero, tax: Money = Money.zero) {
        self.id = id
        self.date = date
        self.amount = amount
        self.kind = kind
        self.security = security
        self.price = price
        self.fees = fees
        self.tax = tax
    }
}

extension OrderTransaction {
    struct Data {
        var date: String
        var security: Security.SecurityData
        var amount: String
        var price: String
        var fees: String
        var tax: String
        var transactionType: OrderTransaction.Kind
        
        init() {
            date = Date().transactionFormat
            security = Security.SecurityData(symbol: "", name: "")
            amount = ""
            price = ""
            fees = ""
            tax = ""
            transactionType = .buy
        }
    }
    
    init(from data: Data) {
        self.id = UUID()
        self.date = Date.from(data.date)
        self.amount = Decimal(from: data.amount)
        self.kind = data.transactionType
        self.security = Security(symbol: data.security.symbol, name: data.security.name)
        self.price = Money(from: data.price)
        self.tax = Money(from: data.tax)
        self.fees = Money(from: data.tax)
    }
}
