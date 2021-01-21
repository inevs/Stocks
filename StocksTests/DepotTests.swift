import XCTest
@testable import Stocks

class DepotTests: XCTestCase {

    func testAddingIncomeTransactionIncreasesBalance() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100.0))
        let transaction = CashTransaction(date: Date(), amount: Money(amount: 50.0), kind: .income)
        depot.addCashTransaction(transaction)
        
        XCTAssertEqual(depot.balance, Money(amount: 150.0))
    }
    
    func testAddingWithdrawTransactionIncreasesBalance() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100.0))
        let transaction = CashTransaction(date: Date(), amount: Money(amount: 50.0), kind: .withdraw)
        depot.addCashTransaction(transaction)
        
        XCTAssertEqual(depot.balance, Money(amount: 50.0))
    }

}
