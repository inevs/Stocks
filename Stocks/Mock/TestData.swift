import Foundation

let apple = Security(symbol: "AAPL", name: "Apple Inc.", price: Money(amount: 105.34))
let microsoft = Security(symbol: "MSFT", name: "Microsoft", price: Money(amount: 205.70))
let nvidia = Security(symbol: "NVD", name: "Nvidia", price: Money(amount: 435.17))

let comdirect = Depot(name: "Comdirect", cash: Money(amount: 34.56), securityAllocations: [
    SecurityAllocation(amount: 50.0, security: apple),
    SecurityAllocation(amount: 12.0, security: microsoft),
    SecurityAllocation(amount: 5.0, security: nvidia),
])

let testDepots: [Depot] = [
    comdirect,
    Depot(name: "Ing", cash: Money(amount: 123.67)),
]

let securitySearchResult = [
    SecurityQueryResult(symbol: "AAPL", name: "Apple"),
    SecurityQueryResult(symbol: "MSFT", name: "Microsoft"),
    SecurityQueryResult(symbol: "GGGG", name: "sjjsjkd kdd"),
    SecurityQueryResult(symbol: "HHHH", name: "jjsjs jsjjs"),
    SecurityQueryResult(symbol: "KKKK", name: "fjiijs"),
    SecurityQueryResult(symbol: "MMMM", name: "hsushduus"),
]

