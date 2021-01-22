import Foundation

struct TestData {
    
    static let cashTransaction = CashTransaction(date: Date(), amount: Money(amount: 500), kind: .income, beneficiary: "Test")

    static let comdirect = Depot(name: "Comdirect", initialBalance: Money(amount: 34.56))

    static let testDepots: [Depot] = [
        comdirect,
        Depot(name: "Ing", initialBalance: Money(amount: 123.67)),
    ]
}
