import Foundation

class StorageController {
    private let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private var appDataFileURL: URL {
        return documentsDirectoryURL
            .appendingPathComponent("Stocks")
            .appendingPathExtension("json")
    }
    
    func save(_ portfolio: Portfolio) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(portfolio) else { return }
        try? data.write(to: appDataFileURL)
    }
        
    func save(_ depots: [Depot]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(depots) else { return }
        try? data.write(to: appDataFileURL)
    }

    func fetchPortfolio() -> Portfolio {
        guard let data = try? Data(contentsOf: appDataFileURL) else { return Portfolio(depots: []) }
        let decoder = JSONDecoder()
        let portfolio = try? decoder.decode(Portfolio.self, from: data)
        return portfolio ?? Portfolio(depots: [])
    }

    func fetchDepots() -> [Depot] {
        guard let data = try? Data(contentsOf: appDataFileURL) else { return [] }
        let decoder = JSONDecoder()
        let depots = try? decoder.decode([Depot].self, from: data)
        return depots ?? []
    }
}
