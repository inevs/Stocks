import Foundation

extension Date {
    static func from(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        return dateFormatter.date(from: string) ?? Date()
    }
    
    var transactionFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }

}
