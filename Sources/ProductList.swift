import Foundation

class ProductList {
    private var theList:[Product] = []
    
    func add(product:Product) {
        theList.append(product)
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
}
