import Foundation

struct Portfolio: Codable {
    var depots: [Depot]
    
    init(depots: [Depot] = []) {
        self.depots = depots
    }
}
    
    
    
    
