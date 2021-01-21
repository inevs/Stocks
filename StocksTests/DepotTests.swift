import XCTest
@testable import Stocks

class DepotTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
//        let apple = Security(symbol: "AAPL", name: "Apple")
//        let nvidia = Security(symbol: "NVD", name: "Nvidia")
//        let appleBuy10 = SecurityTransaction(security: apple, amount: 10, kind: .buy)
//        var depot = Depot(name: "test", cash: Money.zero)
//        depot.securityTransactions = [appleBuy10]

//        XCTAssertEqual(depot.securityAllocations.count, 1)
//        XCTAssertEqual(depot.securityAllocations.first, SecurityAllocation(amount: 10, security: apple))
    }
}

extension SecurityTransaction {
    init(security: Security, amount: Decimal, kind: Kind) {
        self.init(id: UUID(), date: Date(), security: security, amount: amount, kind: kind, fees: Money.zero, tax: Money.zero, price: Money.zero)
    }
}
