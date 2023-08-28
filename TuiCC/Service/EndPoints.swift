import Foundation

enum EndPoint {
    
    case connections
    
    var url: URL? {
        switch self {
        case .connections: return EndPoint.url("/TuiMobilityHub/ios-code-challenge/master/connections.json")
        }
    }
}

extension EndPoint {
    static private func url(_ path: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = path
        
        return components.url
    }
}

