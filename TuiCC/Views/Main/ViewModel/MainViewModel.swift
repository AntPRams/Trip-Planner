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
    var canPerformSearch: Bool { get set }
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
    
    
    @Published var currentState: ViewState = .loading
    @Published var connections = [FlightConnection]()
    @Published var cities = [String]()
    @Published var error: Error?
    @Published var pathResult: PathResult?
    
    private var disposableBag = Set<AnyCancellable>()
    let originSearchFieldViewModel = SearchFieldViewModel(connectionType: .origin)
    let destinationSearchFieldViewModel = SearchFieldViewModel(connectionType: .destination)
    
    @Published var canPerformSearch: Bool = false
    
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
                let path = try await pathCalculator.getCheapestPath(
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
