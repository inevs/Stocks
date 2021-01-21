import Foundation

let comdirect = Depot(name: "Comdirect", cash: Money(amount: 34.56))

let testDepots: [Depot] = [
    comdirect,
    Depot(name: "Ing", cash: Money(amount: 123.67)),
]

