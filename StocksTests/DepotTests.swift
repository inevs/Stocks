import XCTest
@testable import Stocks

class DepotTests: XCTestCase {
    var depot: Depot!
    let apple = Security(symbol: "AAPL", name: "Apple")

    override func setUpWithError() throws {
        depot = Depot(name: "Test", initialBalance: Money(amount: 1000.0))
    }

    func testAddingIncomeTransactionIncreasesBalance() throws {
        let transaction = CashTransaction(date: Date(), amount: Money(amount: 50.0), kind: .income, beneficiary: "")
        depot.addCashTransaction(transaction)
        
        XCTAssertEqual(depot.balance, Money(amount: 1050.0))
    }
    
    func testAddingWithdrawTransactionIncreasesBalance() throws {
        let transaction = CashTransaction(date: Date(), amount: Money(amount: 50.0), kind: .withdraw, beneficiary: "")
        depot.addCashTransaction(transaction)
        
        XCTAssertEqual(depot.balance, Money(amount: 950.0))
    }

    func testAddingSecurityLeadsToSecurityAllocation() throws {
        let transaction = OrderTransaction(date: Date(), amount: 12.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(transaction)
        let securityAllocation = depot.allocation(for: apple)
        XCTAssertNotNil(securityAllocation)
        XCTAssertEqual(securityAllocation, SecurityAllocation(amount: 12.0, security: apple))
    }
    
    func testIncreaseSecurityAllocation() throws {
        let transaction = OrderTransaction(date: Date(), amount: 12.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(transaction)
        let transaction2 = OrderTransaction(date: Date(), amount: 5.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(transaction2)
        let securityAllocation = depot.allocation(for: apple)
        XCTAssertNotNil(securityAllocation)
        XCTAssertEqual(securityAllocation, SecurityAllocation(amount: 17.0, security: apple))
    }

    func testDecreaseSecurityAllocation() throws {
        let buy = OrderTransaction(date: Date(), amount: 12.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(buy)
        let sell = OrderTransaction(date: Date(), amount: 5.0, kind: .sell, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(sell)
        let securityAllocation = depot.allocation(for: apple)
        XCTAssertNotNil(securityAllocation)
        XCTAssertEqual(securityAllocation, SecurityAllocation(amount: 7.0, security: apple))
    }

    func testValueUsesPriceFromSecurities() throws {
        let buy = OrderTransaction(date: Date(), amount: 2.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(buy)
        XCTAssertEqual(depot.balance, Money(amount: 600.0))
        XCTAssertEqual(depot.currentValue, Money(amount: 1000.0))
    }
    
    func testDecreasesCashOnBuySecurity() throws {
        let buy = OrderTransaction(date: Date(), amount: 2.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(buy)
        XCTAssertEqual(depot.balance, Money(amount: 600.0))
    }

    func testIncreasesCashOnSellSecurity() throws {
        let buy = OrderTransaction(date: Date(), amount: 2.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(buy)
        let sell = OrderTransaction(date: Date(), amount: 1.0, kind: .sell, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(sell)
        XCTAssertEqual(depot.balance, Money(amount: 800.0))
    }

    func testReducesCashByFeeForOrdertransactions() throws {
        let buy = OrderTransaction(date: Date(), amount: 1.0, kind: .buy, security: apple, price: Money(amount: 200.0), fees: Money(amount: 10.0))
        depot.addOrderTransaction(buy)
        XCTAssertEqual(depot.balance, Money(amount: 790.0))
    }

    func testReducesCashByTaxForOrdertransactions() throws {
        let buy = OrderTransaction(date: Date(), amount: 1.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(buy) // 800 Cash
        let sell = OrderTransaction(date: Date(), amount: 1.0, kind: .sell, security: apple, price: Money(amount: 200.0), fees: Money(amount: 10.0), tax: Money(amount: 15.0))
        depot.addOrderTransaction(sell)
        XCTAssertEqual(depot.balance, Money(amount: 975.0))
    }
    
    func testRemoveSecurityAllocationOnZeroAmount() throws {
        let buy = OrderTransaction(date: Date(), amount: 1.0, kind: .buy, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(buy)
        let sell = OrderTransaction(date: Date(), amount: 1.0, kind: .sell, security: apple, price: Money(amount: 200.0))
        depot.addOrderTransaction(sell)
        XCTAssertEqual(depot.securityAllocations.count, 0)
    }

}
