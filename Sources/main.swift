import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let productList = ProductList()

productList.add(product:Product(number: 123, name: "Name 1", price: 22.00))
productList.add(product:Product(number: 456, name: "Name 2", price: 50.50))
productList.add(product:Product(number: 565, name: "Name 3", price: 5.00))

print(productList.isUnique(field: "name", value: "Name 4"))

/*
 
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
    do {
        try response.setBody(json: productList.asDictionary)
        response.setHeader(.contentType, value: "application/json")
        response.completed()
        
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}
/* ************************************************************************* */


routes.add(method: .delete, uri: "/json/products/delete/{number}") { (request, response) in
    let productNumber = Int(request.urlVariables["number"]!)!
    do {
        if productList.remove(productNumber: productNumber) {
            let result = ["Result":["message":"true"]]
            try response.setBody(json: result)
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        } else {
            let result = ["Result":["message":"false"]]
            try response.setBody(json: result)
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        }
    } catch {
        response.setBody(string: "Error Generating JSON response: \(error)")
        response.completed()
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

*/

