protocol ConnectionsServiceInterface {
    func fetchConnections() async throws -> [Connection]
}
