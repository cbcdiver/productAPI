import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

/* ************************************************************************* */

func send(HTTPResponse response:HTTPResponse, withJSON theJSON:[String:Any]) {
    do {
        try response.setBody(json: theJSON)
        response.setHeader(.contentType, value: "application/json")
        response.completed()
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}

/* ************************************************************************* */

let productList = ProductList()

productList.add(product:Product(number: 123, name: "Name 1", price: 22.00))
productList.add(product:Product(number: 456, name: "Name 2", price: 50.50))
productList.add(product:Product(number: 565, name: "Name 3", price: 5.00))

/* ************************************************************************* */

print(productList.isUnique(field: "name", value: "Name 4"))

/* ************************************************************************* */

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

/* ************************************************************************* */

let routesAndErrors = ["/json/": "This route needs a module.",
                       "/json/products/":"This route needs an action.",
                       "/json/products/delete/":"This route needs a product number to delete"]

BadRoutes().add(routsAndErrors: routesAndErrors).addBadRoutes(to: &routes)

/* ************************************************************************* */

routes.add(method: .get, uri: "/json/products/all") {
    request, response in
    send(HTTPResponse: response, withJSON: productList.asDictionary)
}

/* ************************************************************************* */

routes.add(method: .delete, uri: "/json/products/delete/{number}") {
    (request, response) in
    let productNumber = Int(request.urlVariables["number"]!)!
    send(HTTPResponse: response,
         withJSON: ["Result":productList.remove(productNumber: productNumber)])
}

/* ************************************************************************* */

routes.add(method: .post, uri: "/json/add") {
    (request, response) in
    let productNumber = request.param(name: "number")
    let name = request.param(name: "name")
    let price = request.param(name: "price")
    
    var canAdd = true
    var errorMessage:String!
    
    var missingFields = [String]()
    for field in ["number", "name", "price"] {
        if request.param(name: field) == nil {
            missingFields.append(field)
        }
    }
    
    if missingFields.count > 0 {
        canAdd = false
        errorMessage = "Can not add, the following fields are missing: " +
            missingFields.joined(separator: ", ")
    }
    
    if canAdd {
        var blankFields = [String]()
        for field in ["number", "name", "price"] {
            if request.param(name: field) == "" {
                blankFields.append(field)
            }
        }
        
        if blankFields.count > 0 {
            canAdd = false
            errorMessage = "Can not add, the following fields are blank: " +
                blankFields.joined(separator: ", ")
        }
    }
}

/* ************************************************************************* */

server.addRoutes(routes)

/* ************************************************************************* */

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}



