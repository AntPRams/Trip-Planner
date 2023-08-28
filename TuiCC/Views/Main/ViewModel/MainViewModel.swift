import Foundation
import SwiftUI
import Combine
import CoreLocation

protocol MainViewModelInterface: ObservableObject {
    var error: Error? { get set }
    var cities: [String] { get set }
    var pathResult: PathResult? { get set }
    var connections: [FlightConnection] { get set }
    var currentState: ViewState { get set }
    var pathCalculator: PathCalculator { get }
    var service: ConnectionsService { get }
    var originSearchFieldViewModel: SearchFieldViewModel { get }
    var destinationSearchFieldViewModel: SearchFieldViewModel { get }
    
    func clear()
    func fetchData()
    func calculatePaths()
}

final class MainViewModel: MainViewModelInterface {
    
    // MARK: - Properties
    
    private(set) var service: ConnectionsService
    private(set) var pathCalculator: PathCalculator
    
    @Published var error: Error?
    @Published var cities = [String]()
    @Published var pathResult: PathResult?
    @Published var connections = [FlightConnection]()
    @Published var currentState: ViewState = .loading
    
    let originSearchFieldViewModel = SearchFieldViewModel(connectionType: .origin)
    let destinationSearchFieldViewModel = SearchFieldViewModel(connectionType: .destination)
    
    private var disposableBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        service: ConnectionsService = ConnectionsService(),
        pathCalculator: PathCalculator = PathCalculator()
    ) {
        self.pathCalculator = pathCalculator
        self.service = service
    }
    
    // MARK: - Public interface
    
    func fetchData() {
        currentState = .loading
        Task {
            do {
                let connections = try await service.fetchConnections()
                await pathCalculator.updateConnections(connections)
                await MainActor.run {
                    self.connections = connections
                    extractCities()
                    withAnimation {
                        currentState = .idle
                    }
                }
            } catch {
                await MainActor.run {
                    currentState = .idle
                    self.error = error
                }
            }
        }
    }
    
    func calculatePaths() {
        let origin = originSearchFieldViewModel.text
        let destination = destinationSearchFieldViewModel.text
        currentState = .loading
        Task {
            do {
                try validateSearch(origin: origin, destination: destination)
                let path = try await pathCalculator.generatePath(
                    from: origin,
                    to: destination
                )
                await MainActor.run {
                    pathResult = path
                    currentState = .idle
                }
            } catch {
                await MainActor.run {
                    pathResult = nil
                    currentState = .idle
                    self.error = error
                }
            }
        }
    }
    
    func clear() {
        originSearchFieldViewModel.text = String()
        destinationSearchFieldViewModel.text = String()
        pathResult = nil
    }
    
    func validateSearch(origin: String, destination: String) throws {
        switch (origin, destination) {
        case _ where origin.isEmpty && destination.isEmpty:
            throw AppError.pathMissing
        case _ where origin.isEmpty:
            throw AppError.originMissing
        case _ where destination.isEmpty:
            throw AppError.destinationMissing
        case _ where destination == origin:
            throw AppError.sameCityInBothFields
        default:
            return
        }
    }
}

// MARK: - Private work

extension MainViewModel {
    
    private func extractCities() {
        let allCities = connections.flatMap { model in
            [model.origin, model.destination]
        }
        
        cities = allCities.removingDuplicates()
        originSearchFieldViewModel.updateCities(cities)
        destinationSearchFieldViewModel.updateCities(cities)
    }
}
