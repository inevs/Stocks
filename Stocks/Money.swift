import Foundation

struct Money {
    let amount: Decimal
    
    init(amount: Decimal) {
        self.amount = amount
    }
}

extension Money {
    init(from string: String) {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = formatter.number(from: string) as? NSDecimalNumber  {
            self.amount = formattedNumber as Decimal
        } else {
            self.amount = 0.0
        }
    }

    func string(precision: Int = 2) -> String {
        return "\(amount.string(precision: precision)) EUR"
    }
    
    func isNegative() -> Bool {
        amount.isNegative()
    }
}

extension Money: AdditiveArithmetic {
    static var zero: Money {
        Money(amount: 0.0)
    }
    
    static func +(lhs: Money, rhs: Money) -> Money {
        return Money(amount: lhs.amount + rhs.amount)
    }

    static func - (lhs: Money, rhs: Money) -> Money {
        return Money(amount: lhs.amount - rhs.amount)
    }
    
    static func * (lhs: Money, rhs: Decimal) -> Money {
        return Money(amount: lhs.amount * rhs)
    }

    static func * (lhs: Decimal, rhs: Money) -> Money {
        return Money(amount: lhs * rhs.amount)
    }
}

extension Decimal {
    init(from string: String) {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = formatter.number(from: string) as? NSDecimalNumber  {
            self = formattedNumber as Decimal
        } else {
            self = 0.0
        }
    }
    
    func string(precision: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = precision
        
        if let string = formatter.string(for: self) {
            return "\(string)"
        }
        return "n/a"
    }
    
    func isNegative() -> Bool {
        self < 0.0
    }
    
}
