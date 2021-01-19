import Foundation

class StorageController {
    private let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private var appDataFileURL: URL {
        return documentsDirectoryURL
            .appendingPathComponent("Stocks")
            .appendingPathExtension("json")
    }
    
    func save(_ depots: [Depot]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(depots) else { return }
        try? data.write(to: appDataFileURL)
    }
    
    func fetchDepots() -> [Depot] {
        guard let data = try? Data(contentsOf: appDataFileURL) else { return [] }
        let decoder = JSONDecoder()
        let depots = try? decoder.decode([Depot].self, from: data)
        return depots ?? []
    }
}
