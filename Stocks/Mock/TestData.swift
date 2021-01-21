import Foundation

let comdirect = Depot(name: "Comdirect", initialBalance: Money(amount: 34.56))

let testDepots: [Depot] = [
    comdirect,
    Depot(name: "Ing", initialBalance: Money(amount: 123.67)),
]

