import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

var products = ["products":[
    ["number":"212", "name":"Pencil", "description":"Basic Pencil", "price":"0.99"],
    ["number":"423", "name":"Workbook", "description":"20 page lined workbook", "price":"2.99"],
    ["number":"100", "name":"Claculator", "description":"Scienctific Calculator", "price":"13.99"]
    ]]

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"


/* ************************************************************************* */
func removeProduct(productNumber: String) -> Bool {
    var index = 0
    for product in products["products"]! {
        if product["number"]  == productNumber {
            products["products"]?.remove(at: index)
            return true
        }
        index+=1
    }
    return false
}

/* ************************************************************************* 
func isFieldUnique(value: String, fieldName: String) -> Bool {
    for account in names["accounts"]! {
        if account["username"] == username {
            return true
        }
    }
    return false
 ************************************************************************* */

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
        if removeProduct(productNumber: productNumber) {
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
