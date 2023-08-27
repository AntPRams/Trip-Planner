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
    var coordinates: [CLLocationCoordinate2D]? { get set }
    func fetchData()
    func calculatePaths()
}

enum ViewState: Equatable {
    
    case initial
    case loading
    case idle
}

final class SearchFieldViewModel: ObservableObject {
    
    var isBeingEdited: Bool = false
    @Published var text = String()
    @Published var cities = [String]()
    @Published var showDropDown: Bool = false
    var connectionType: ConnectionType
    private var allCities = [String]()
    
    var disposableBag = Set<AnyCancellable>()
    
    init(connectionType: ConnectionType) {
        self.connectionType = connectionType
        subscribeToTextChanges()
    }
    
    func updateCities(_ cities: [String]) {
        allCities = cities
    }
    
    private func subscribeToTextChanges() {
        $text.sink { [weak self] query in
            guard let self else { return }
            query != String() ? performSearch(query: query) : cities.removeAll()
        }
        .store(in: &disposableBag)
    }
    
    func performSearch(query: String) {
        cities = allCities.filter({ city in
            search(for: query, city)
        })
    }
    
    func shouldShowDropdown() {
        withAnimation {
            showDropDown = isBeingEdited &&
            !cities.contains(text) &&
            text != String() &&
            cities.isNotEmpty
        }
    }
    
    private func search(for query: String, _ city: String) -> Bool {
        let rhs = query.folding(options: [.caseInsensitive], locale: nil)
        let lhs = city.folding(options: [.caseInsensitive], locale: nil)
        
        return lhs.contains(rhs)
    }
}

final class MainViewModel: MainViewModelInterface {
    
    private var networkProvider: ConnectionsServiceInterface
    private let pathCalculator = PathCalculator()
    
    @Published var currentState: ViewState = .loading
    @Published var connections = [Connection]()
    @Published var cities = [String]()
    @Published var error: Error?
    @Published var coordinates: [CLLocationCoordinate2D]?
    
    var disposableBag = Set<AnyCancellable>()
    let originSearchFieldViewModel = SearchFieldViewModel(connectionType: .origin)
    let destinationSearchFieldViewModel = SearchFieldViewModel(connectionType: .destination)
    
    @Published var canPerformSearch: Bool = false
    
    init(
        networkProvider: ConnectionsServiceInterface = ConnectionsService()
    ) {
        self.networkProvider = networkProvider
    }
    
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
    
    private func extractCities() {
        let allCities = connections.flatMap { model in
            [model.origin, model.destination]
        }
        
        cities = allCities.removingDuplicates()
        originSearchFieldViewModel.updateCities(cities)
        destinationSearchFieldViewModel.updateCities(cities)
        
        self.objectWillChange.send()
    }
    
    
    func calculatePaths() {
        coordinates = nil
        Task {
            let origin = originSearchFieldViewModel.text
            let destination = destinationSearchFieldViewModel.text
            let cheapest = try await pathCalculator.getCheapestPath(from: origin, to: destination)
            await MainActor.run {
                coordinates = cheapest.coordinates
            }
            print(cheapest)
        }
    }
}
