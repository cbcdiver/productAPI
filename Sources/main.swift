import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let names = ["products":[
    ["number":212, "name":"Pencil", "description":"Basic Pencil", "price":0.99],
    ["number":423, "name":"Workbook", "description":"20 page lined workbook", "price":2.99],
    ["number":100, "name":"Claculator", "description":"Scienctific Calculator", "price":13.99]
    ]]

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

routes.add(method: .get, uri: "/json/products/all") {
    request, response in
    do {
        try response.setBody(json: names)
        response.setHeader(.contentType, value: "application/json")
        response.completed()
        
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}

server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
