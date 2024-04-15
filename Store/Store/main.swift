import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

protocol PricingScheme {
    func applyScheme(to receipt: Receipt)
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
    private var discount: Int = 0
    
    func items() -> [SKU] {
        return receiptItems
    }
    
    func add(_ item: SKU) {
        receiptItems.append(item)
    }
    
    func total() -> Int {
        var total = 0
        for item in receiptItems {
            let itemPrice = item.price()
            total += itemPrice
        }
        
        return total - discount
    }
    
    func output() -> String {
        var receiptOutput: String = "Receipt:\n"
        
        for item in receiptItems {
            let newLine = "\(item.name): $\(Double(item.price()) / 100.0)\n"
            receiptOutput.append(newLine)
        }
        
        receiptOutput.append("------------------\n")
        
        if (discount > 0) {
            receiptOutput.append("DISCOUNT: -$\(Double(self.discount) / 100.0)\n")
            receiptOutput.append("------------------\n")
        }
        
        receiptOutput.append("TOTAL: $\(Double(self.total()) / 100.0)")
        
        return receiptOutput
    }
    
    func applyDiscount(_ discountValue: Int) {
        discount += discountValue
    }
    
    func clear() {
        receiptItems.removeAll()
        discount = 0
    }
}

class Register {
    private var receipt: Receipt
    private let pricingScheme: TwoForOnePricing = TwoForOnePricing("Beans (8oz Can)")
    
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        receipt.add(sku)
    }
    
    func getReceipt() -> Receipt {
        return self.receipt
    }
    
    func subtotal() -> Int {
        pricingScheme.applyScheme(to: receipt)
        return receipt.total()
    }
    
    func total() -> Receipt {
        pricingScheme.applyScheme(to: receipt)
        let curr = self.receipt
        receipt = Receipt()
        return curr
    }
    
    func clear() {
        receipt.clear()
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

class TwoForOnePricing: PricingScheme {
    private var itemName: String
    
    init(_ itemName: String) {
        self.itemName = itemName
    }
    
    func applyScheme(to receipt: Receipt) {
        var items = receipt.items()
        
        items = items.filter {
            $0.name == itemName
        }
        
        if items.count < 2 {
            return
        }
        
        let numBunches = items.count / 3
        
        let discount = numBunches * 299
        
        receipt.applyDiscount(discount)
    }
}

