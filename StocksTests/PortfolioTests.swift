import XCTest
@testable import Stocks

class PortfolioTests: XCTestCase {

    func testUpdatedPriceOfSecuritiesUpdatesValueOfPortfolio() throws {
        var depot = Depot(name: "Test", initialBalance: Money(amount: 100))
        let apple = Security(symbol: "AAPL", name: "Apple")
        let buy = OrderTransaction(date: Date(), amount: 1, kind: .buy, security: apple, price: Money(amount: 100.0))
        depot.addOrderTransaction(buy)
        var portfolio = Portfolio(depots: [depot])
        portfolio.update(security: apple, withPrice: Money(amount: 120))
        
        XCTAssertEqual(portfolio.depots[0].currentValue, Money(amount: 120))
    }

}
