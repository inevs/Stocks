import Foundation

class DepotData: ObservableObject {
    @Published var depots: [Depot]
    
    init(depots: [Depot] = []) {
        self.depots = depots
    }
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("depot.data")
    }

    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.depots = testDepots
                }
                #endif
                return
            }
            guard let depots = try? JSONDecoder().decode([Depot].self, from: data) else {
                fatalError("Can't decode saved scrum data.")
            }
            DispatchQueue.main.async {
                self?.depots = depots
            }
        }
    }
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let depots = self?.depots else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(depots) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}

extension DepotData {
    
    func addSecurityAllocation(withData data: SecurityAllocation.Data, toDepot depot: Depot) {
        guard let depotIndex = depots.firstIndex(where: { $0.name == depot.name }) else { return }
        
        guard let securityAllocationIndex = depot.securityAllocations.firstIndex(where: { $0.security.symbol == data.symbol }) else {
            let securityAllocation = SecurityAllocation(from: data)
            depots[depotIndex].securityAllocations.append(securityAllocation)
            return
        }
        depots[depotIndex].securityAllocations[securityAllocationIndex].amount += Decimal(from: data.amount)
        
    }
    
    func removeSecurityAllocation(withData data: SecurityAllocation.Data, fromDepot depot: Depot) {
        guard let depotIndex = depots.firstIndex(where: { $0.name == depot.name }) else { return }
        
        guard let securityAllocationIndex = depot.securityAllocations.firstIndex(where: { $0.security.symbol == data.symbol }) else {
            return
        }
        
        if (depot.securityAllocations[securityAllocationIndex]).amount > Decimal(from: data.amount) {
            depots[depotIndex].securityAllocations[securityAllocationIndex].amount -= Decimal(from: data.amount)
        } else {
            depots[depotIndex].securityAllocations.remove(at: securityAllocationIndex)
        }
    }

}
