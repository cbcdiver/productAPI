import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

class BadRoutes {
    private var badRoutes:[[String:Any]] = []
    
    func add(method:HTTPMethod, route:String, errorMessage:String) -> BadRoutes {
        self.badRoutes.append(["method":method, "route":route, "error":errorMessage])
        return self
    }
    
    func add(routesAndErrors routes:[[String:Any]]) -> BadRoutes {
        self.badRoutes += routes
        return self
    }
    
    func addBadRoutes(to theRoutes: inout Routes){
        for aRoute in self.badRoutes {
            theRoutes.add(method: aRoute["method"] as! HTTPMethod, uri: aRoute["route"] as! String) { request, response in
                do {
                    try response.setBody(json: ["Result":false,
                                                "Message":aRoute["error"] as! String,
                                                "data":""])
                    response.setHeader(.contentType, value: "application/json")
                    response.completed()
                } catch {
                    response.setBody(string: "Error handling request: \(error)")
                    response.completed()
                }
            }
        }
    }
}
