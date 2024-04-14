import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

class Item: SKU {
    var name: String
    private var priceEach: Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    func price() -> Int {
        return priceEach
    }
}

class Receipt {
    private var receiptItems: [SKU] = []
    
    func items() -> [SKU] {
        return receiptItems
    }
    
    func add(_ item: SKU) {
        receiptItems.append(item)
    }
    
    func total() -> Double {
        var total = 0.0
        for item in receiptItems {
            let itemPrice: Double = Double(item.price())
            total += itemPrice
        }
        
        return total
    }
    
    func output() -> String {
        var receiptOutput: String = "Receipt:\n"
        
        for item in receiptItems {
            let newLine = "\(item.name): $\(Double(item.price()) / 100.0)\n"
            receiptOutput.append(newLine)
        }
        
        receiptOutput.append("------------------\n")
        receiptOutput.append("TOTAL: $\(self.total() / 100.0)")
        
        return receiptOutput
    }
}

class Register {
    private var receipt: Receipt
    
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        receipt.add(sku)
    }
    
    func subtotal() -> Double {
        return receipt.total()
    }
    
    func total() -> Receipt {
        let curr = self.receipt
        receipt = Receipt()
        return curr
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

