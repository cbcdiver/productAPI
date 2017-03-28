import Foundation

struct Product {
    var number:Int
    var name:String
    var price:Double
    
    var asDictionary:[String:Any] {
        get {
            return ["number":self.number,
                    "name":self.name,
                    "price":self.price]
        }
    }
}
