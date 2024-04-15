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
    var discount: Int = 0
    
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
    private let beanPricingScheme: TwoForOnePricing = TwoForOnePricing("Beans (8oz Can)")
    private let ketchupAndBeerPricingScheme: GroupedPricing = GroupedPricing(Set(["Beer", "Ketchup"]), 10)
    
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
        checkDiscounts()
        return receipt.total()
    }
    
    func total() -> Receipt {
        checkDiscounts()
        let curr = self.receipt
        receipt = Receipt()
        return curr
    }
    
    func clear() {
        receipt.clear()
    }
    
    func checkDiscounts() {
        beanPricingScheme.applyScheme(to: receipt)
        ketchupAndBeerPricingScheme.applyScheme(to: receipt)
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

class GroupedPricing: PricingScheme {
    private let discountItemGroup: Set<String>
    private let discountRate: Int
    
    init(_ discountItemGroup: Set<String>, _ discountRate: Int) {
        self.discountItemGroup = discountItemGroup
        self.discountRate = discountRate
    }
    
    func applyScheme(to receipt: Receipt) {
        var discountItems: [Item] = []
        
        for sku in receipt.items() {
            let item = sku as! Item
            
            let itemName = item.name.components(separatedBy: " (")[0]
            if discountItemGroup.contains(itemName) {
                discountItems.append(item)
            }
        }
        
        if discountItems.count == discountItemGroup.count {
            for item in discountItems {
                let itemDiscount = item.price() * discountRate / 100
                receipt.applyDiscount(itemDiscount)
            }
        }
    }
}

