struct MockNetworkProvider: NetworkProviderInterface {
    func fetch() {
        print("Network mock data fetched")
    }
    
    
}
