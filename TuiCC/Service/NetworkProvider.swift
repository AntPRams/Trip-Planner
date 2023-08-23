import Foundation

protocol APICallerInterface {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}

class APICaller: APICallerInterface {
    
    static let shared = APICaller()
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        let fetchedData = try JSONDecoder().decode(T.self, from: try mapResponse(response: (data,response)))
        return fetchedData
    }
}

var connectionsServiceAPIClient: ConnectionsServiceAPI = {
    ConnectionsService.API.client()
}()

enum ConnectionsService {
    enum API { }
}

protocol ConnectionsServiceAPI {
    func fetch() async throws -> [Connection]
}

extension ConnectionsService.API {
    static func client() -> ConnectionsServiceAPI {
        ConnectionsService.API.Client()
    }
    
    struct Client: ConnectionsServiceAPI {
        func fetch() async throws -> [Connection] {
            let data: Connections = try await APICaller.shared.fetch(from: URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json")!)
            
            guard data.connections.isNotEmpty else {
                throw NetworkError.notFound
            }
            
            return data.connections
        }
    }
}




//
//public var socialProofApiClient: SocialProofAPI = {
//    SocialProof.API.client()
//}()
//
//public enum SocialProof {
//    public enum API { }
//}
//
//public protocol SocialProofAPI {
//    func loadSocialProof(for urn: String) -> AnyPublisher<SocialProofQuery.Data, ResponseError>
//}
//
//extension SocialProof.API {
//    static func client() -> SocialProofAPI {
//        SocialProof.API.Client()
//    }
//    
//    struct Client: SocialProofAPI {
//        func loadSocialProof(for urn: String) -> AnyPublisher<SocialProofQuery.Data, ResponseError> {
//            return Future<SocialProofQuery.Data, ResponseError> { promise in
//                XINGOne.shared.fetch(
//                    query: SocialProofQuery(urn: urn),
//                    cachePolicy: .fetchIgnoringCacheData
//                ) { result in
//                    switch result {
//                    case .success(let response):
//                        guard response.errors == nil else {
//                            promise(.failure(.apiError))
//                            return
//                        }
//                        
//                        if let data = response.data {
//                            promise(.success(data))
//                        } else {
//                            promise(.failure(.apiError))
//                        }
//                    case .failure:
//                        promise(.failure(.apiError))
//                    }
//                }
//            }
//            .eraseToAnyPublisher()
//        }
//    }
//}
