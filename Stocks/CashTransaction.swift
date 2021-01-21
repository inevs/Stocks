import Foundation

struct CashTransaction: Codable, Identifiable {
    enum Kind: String, Codable, CaseIterable {
        case withdraw, income
    }

    let id: UUID
    let date: Date
    let amount: Money
    let kind: Kind

    init(id: UUID = UUID(), date: Date, amount: Money, kind: Kind) {
        self.id = id
        self.date = date
        self.amount = amount
        self.kind = kind
    }
}
