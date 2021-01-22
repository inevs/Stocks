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
}
