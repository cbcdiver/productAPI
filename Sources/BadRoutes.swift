import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

class BadRoutes {
    private var badRoutesDictionary:[String:String] = [:]
    
    func add(route:String, errorMessage:String) -> BadRoutes {
        self.badRoutesDictionary[route] = errorMessage
        return self
    }
    
    func add(routsAndErrors routes:[String:String]) -> BadRoutes {
        for (route, errorMessage) in routes {
            self.badRoutesDictionary[route] = errorMessage
        }
        return self
    }
    
    func addBadRoutes(to theRoutes: inout Routes){
        for (route, errorMessage) in self.badRoutesDictionary {
            theRoutes.add(method: .get, uri: route) { request, response in
                response.setBody(string: errorMessage)
                response.completed()
            }
        }
    }
}
