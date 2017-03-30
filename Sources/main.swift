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

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

/* ************************************************************************* */

let routesAndErrors:[[String:Any]] = [["method":HTTPMethod.get,
                                       "route":"/json/",
                                       "error":"This route needs a module."],
                                      ["method":HTTPMethod.get,
                                       "route":"/json/products/",
                                       "error":"This route needs an action."],
                                      ["method":HTTPMethod.post,
                                       "route":"/json/products/",
                                       "error":"This route needs an action."],
                                      ["method":HTTPMethod.delete,
                                       "route":"/json/products/delete",
                                       "error":"This route needs a product number to delete"]]

BadRoutes().add(routesAndErrors: routesAndErrors).addBadRoutes(to: &routes)

/* ************************************************************************* */

routes.add(method: .get, uri: "/json/products/all") {
    request, response in
    send(HTTPResponse: response, withJSON: ["Result":true,
                                            "Message":"Data retreived",
                                            "data":productList.asDictionary])
}

/* ************************************************************************* */

routes.add(method: .delete, uri: "/json/products/delete/{number}") {
    (request, response) in
    let productNumber = Int(request.urlVariables["number"]!)!
    
    let didDelete = productList.remove(productNumber: productNumber)
    var message = "Product \(productNumber) Deleted"
    if !didDelete {
        message = "Product Not Found"
    }

    send(HTTPResponse: response,
         withJSON: ["Result":didDelete,
                    "Message":message,
                    "data":""])
}

/* ************************************************************************* */

routes.add(method: .post, uri: "/json/products/add") {
    (request, response) in

    let fields = ["number":request.param(name: "number"),
                  "name": request.param(name: "name"),
                  "price": request.param(name: "price")]

    let (wasAdded, message) = productList.validateAndAdd(params: fields)
    
    send(HTTPResponse: response,
         withJSON: ["Result":wasAdded,
                    "Message":message,
                    "data":""])
}

/* ************************************************************************* */

server.addRoutes(routes)

/* ************************************************************************* */

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}



