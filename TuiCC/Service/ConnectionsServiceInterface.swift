protocol ConnectionsServiceInterface {
    func fetchConnections() async throws -> [FlightConnection]
}
