import SwiftUI
import Combine

final class SearchFieldViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var text = String()
    @Published var cities = [String]()
    @Published var showDropDown: Bool = false
    
    var isBeingEdited: Bool = false
    var connectionType: ConnectionType
    private var allCities = [String]()
    
    var disposableBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(connectionType: ConnectionType) {
        self.connectionType = connectionType
        subscribeToTextChanges()
    }
    
    // MARK: - Public interface
    
    func updateCities(_ cities: [String]) {
        allCities = cities
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
}

// MARK: - Private work

extension SearchFieldViewModel {
    
    private func search(for query: String, _ city: String) -> Bool {
        let rhs = query.folding(options: [.caseInsensitive], locale: nil)
        let lhs = city.folding(options: [.caseInsensitive], locale: nil)
        
        return lhs.contains(rhs)
    }
    
    private func subscribeToTextChanges() {
        $text.sink { [weak self] query in
            guard let self else { return }
            query != String() ? performSearch(query: query) : cities.removeAll()
        }
        .store(in: &disposableBag)
    }
}
