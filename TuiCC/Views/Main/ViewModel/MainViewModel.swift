import Foundation
import SwiftUI
import Combine
import CoreLocation

protocol MainViewModelInterface: ObservableObject {
    var canPerformSearch: Bool { get set }
    var currentState: ViewState { get set }
    var connections: [Connection] { get set }
    var cities: [String] { get set }
    var error: Error? { get set }
    var originSearchFieldViewModel: SearchFieldViewModel { get }
    var destinationSearchFieldViewModel: SearchFieldViewModel { get }
    var pathResult: PathResult? { get set }
    func fetchData()
    func clear()
    func calculatePaths()
}

enum ViewState {
    
    case initial
    case loading
    case idle
}

final class MainViewModel: MainViewModelInterface {
    
    // MARK: - Properties
    
    private var networkProvider: ConnectionsServiceInterface
    private let pathCalculator = PathCalculator()
    
    @Published var currentState: ViewState = .loading
    @Published var connections = [Connection]()
    @Published var cities = [String]()
    @Published var error: Error?
    @Published var pathResult: PathResult?
    
    private var disposableBag = Set<AnyCancellable>()
    let originSearchFieldViewModel = SearchFieldViewModel(connectionType: .origin)
    let destinationSearchFieldViewModel = SearchFieldViewModel(connectionType: .destination)
    
    @Published var canPerformSearch: Bool = false
    
    // MARK: - Init
    
    init(
        networkProvider: ConnectionsServiceInterface = ConnectionsService()
    ) {
        self.networkProvider = networkProvider
    }
    
    // MARK: - Public interface
    
    func fetchData() {
        currentState = .loading
        Task {
            do {
                let connections = try await networkProvider.fetchConnections()
                await pathCalculator.updateConnections(connections)
                await MainActor.run {
                    self.connections = connections
                    extractCities()
                    withAnimation {
                        currentState = .idle
                    }
                    print(self.connections)
                }
            } catch {
                currentState = .idle
                self.error = error
                print(error.localizedDescription)
            }
        }
    }
    
    func clear() {
        originSearchFieldViewModel.text = String()
        destinationSearchFieldViewModel.text = String()
        pathResult = nil
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
