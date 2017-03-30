import Foundation

class ProductList {
    private var theList:[Product] = []
    private let fieldNames = ["number", "name", "price"]
    
    func add(product:Product) {
        theList.append(product)
    }
    
    func isUnique<T:Comparable>(field:String, value:T) -> Bool {
        let arrayOfProductDicts = self.asDictionary["products"] as! [[String:Any]]
        for aProduct in arrayOfProductDicts  {
            if aProduct[field] as! T == value {
                return false
            }
        }
        return true
    }
    
    func remove(productNumber:Int)->Bool {
        var index = 0
        for aProduct in theList {
            if productNumber == aProduct.number {
                self.theList.remove(at: index)
                return true
            }
            index+=1
        }
        return false
    }
    
    var asDictionary:[String:Any] {
        get {
            var arrayOfProducts:[[String:Any]] = []
            for product in self.theList {
                arrayOfProducts.append(product.asDictionary)
            }
            return ["products":arrayOfProducts]
        }
    }
    
    func validateAndAdd(params:[String:String?]) -> (Bool, String) {
        
        var missingFields = [String]()
        for field in ["number", "name", "price"] {
            if params[field]! == nil {
                missingFields.append(field)
            }
        }
        
        if missingFields.count > 0 {
            return (false, "Can not add, the following fields are missing: " +  missingFields.joined(separator: ", "))
        }
        
        var blankFields = [String]()
        for field in ["number", "name", "price"] {
            if params[field]! == "" {
                blankFields.append(field)
            }
        }
        
        if blankFields.count > 0 {
            return (false, "Can not add, the following fields are blank: " +  blankFields.joined(separator: ", "))
        }
        
        let name = params["name"]!!
        let productNumber = Int(params["number"]!!)!
        let price = Double(params["price"]!!)!
        
        var duplicateFields = [String]()
        if !productList.isUnique(field: "name", value: name) {
            duplicateFields.append("name")
        }
        if !productList.isUnique(field: "number", value: productNumber) {
            duplicateFields.append("number")
        }
        
        if duplicateFields.count > 0 {
            return (false, "Can not add, the following fields are not unique: " +  duplicateFields.joined(separator: ", "))
        }
        
        self.add(product:Product(number: productNumber, name: name, price: price))
        return (true, "Product Added")
    }
}
