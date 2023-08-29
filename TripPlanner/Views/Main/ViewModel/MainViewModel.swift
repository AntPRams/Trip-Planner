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
    var service: any Service { get }
    var originSearchFieldViewModel: SearchFieldViewModel { get }
    var destinationSearchFieldViewModel: SearchFieldViewModel { get }
    
    func clear()
    func fetchData()
    func calculatePaths()
}

final class MainViewModel: MainViewModelInterface {
    
    // MARK: - Properties
    
    private(set) var pathCalculator: PathCalculator
    private(set) var service: any Service
    
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
        service: any Service = ConnectionsService(),
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
                guard let connections = try await service.fetchConnections() as? [FlightConnection] else {
                    throw NetworkError.unknown
                }
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
    
    /// Will calculate paths based on the text in both `SearchField`s.
    /// Before the request it will validate if both fields have the data as it should
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
    
    /// A method to validate the input on both `SearchField`s
    /// - Parameters:
    ///   - origin: Origin text
    ///   - destination: Destination text
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
    
    /// Will convert `Connection`s in a array of cities to inject them in each `SearchFieldViewModel`
    private func extractCities() {
        let allCities = connections.flatMap { model in
            [model.origin, model.destination]
        }
        
        cities = allCities.removingDuplicates()
        originSearchFieldViewModel.updateCities(cities)
        destinationSearchFieldViewModel.updateCities(cities)
    }
}
