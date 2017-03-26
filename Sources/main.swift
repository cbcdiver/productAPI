import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

var products = ["products":[
    ["number":212, "name":"Pencil", "description":"Basic Pencil", "price":0.99],
    ["number":423, "name":"Workbook", "description":"20 page lined workbook", "price":2.99],
    ["number":100, "name":"Claculator", "description":"Scienctific Calculator", "price":13.99]
    ]]

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"


/* ************************************************************************* */
func removeProduct(productNumber: Int) -> Bool {
    var index = 0
    for product in products["products"]! {
        if product["number"] as! Int == productNumber {
            products["products"]?.remove(at: index)
            return true
        }
        index+=1
    }
    return false
}
/* ************************************************************************* */

var routes = Routes()

/* ************************************************************************* */

routes.add(method: .get, uri: "/json/products/all") {
    request, response in
    do {
        try response.setBody(json: products)
        response.setHeader(.contentType, value: "application/json")
        response.completed()
        
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}
/* ************************************************************************* */

routes.add(method: .delete, uri: "/json/products/delete/{number}") { (request, response) in
    let productNumber = request.urlVariables["number"]!
    do {
        if removeProduct(productNumber: Int(productNumber)!) {
            try response.setBody(json: ["Result":"true"])
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        } else {
            try response.setBody(json: ["Result":"false"])
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
