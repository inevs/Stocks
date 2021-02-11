import XCTest
@testable import Stocks

class DepotTests: XCTestCase {

    func testAddingIncomeTransactionIncreasesBalance() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100.0))
        let transaction = CashTransaction(date: Date(), amount: Money(amount: 50.0), kind: .income, beneficiary: "")
        depot.addCashTransaction(transaction)
        
        XCTAssertEqual(depot.balance, Money(amount: 150.0))
    }
    
    func testAddingWithdrawTransactionIncreasesBalance() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100.0))
        let transaction = CashTransaction(date: Date(), amount: Money(amount: 50.0), kind: .withdraw, beneficiary: "")
        depot.addCashTransaction(transaction)
        
        XCTAssertEqual(depot.balance, Money(amount: 50.0))
    }

    func testAddingSecurityLeadsToSecurityAllocation() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100.0))
        let apple = Security(symbol: "AAPL", name: "Apple")
        let transaction = OrderTransaction(date: Date(), amount: 12.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(transaction)
        let securityAllocation = depot.allocation(for: apple)
        XCTAssertNotNil(securityAllocation)
        XCTAssertEqual(securityAllocation, SecurityAllocation(amount: 12.0, security: apple))
    }
    
    func testIncreaseSecurityAllocation() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100.0))
        let apple = Security(symbol: "AAPL", name: "Apple")
        let transaction = OrderTransaction(date: Date(), amount: 12.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(transaction)
        let transaction2 = OrderTransaction(date: Date(), amount: 5.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(transaction2)
        let securityAllocation = depot.allocation(for: apple)
        XCTAssertNotNil(securityAllocation)
        XCTAssertEqual(securityAllocation, SecurityAllocation(amount: 17.0, security: apple))
    }

    func testDecreaseSecurityAllocation() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100.0))
        let apple = Security(symbol: "AAPL", name: "Apple")
        let buy = OrderTransaction(date: Date(), amount: 12.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(buy)
        let sell = OrderTransaction(date: Date(), amount: 5.0, kind: .sell, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(sell)
        let securityAllocation = depot.allocation(for: apple)
        XCTAssertNotNil(securityAllocation)
        XCTAssertEqual(securityAllocation, SecurityAllocation(amount: 7.0, security: apple))
    }

}
