import Foundation

//Here we could use enum cases and build urls with the help of computed var's instead of a plain method,
//since we are only using one endPoint i'll use the enum as a namespace
enum EndPoint {
    
    static func connections() -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = "/TuiMobilityHub/ios-code-challenge/master/connections.json"
        
        return components.url
    }
}

