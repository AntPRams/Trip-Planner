import SwiftUI
import Combine

final class SearchFieldViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var text = String()
    @Published var filteredCities = [String]()
    @Published var showDropDown: Bool = false
    
    var isBeingEdited: Bool = false
    var connectionType: ConnectionType
    private var cities = [String]()
    
    var disposableBag = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(connectionType: ConnectionType) {
        self.connectionType = connectionType
        subscribeToTextChanges()
    }
    
    // MARK: - Public interface
    
    func updateCities(_ cities: [String]) {
        self.cities = cities
    }
    
    func performSearch(query: String) {
        filteredCities = cities.filter({ city in
            search(for: query, city)
        })
    }
    
    func shouldShowDropdown() {
        withAnimation {
            showDropDown = isBeingEdited &&
            !filteredCities.contains(text) &&
            text.isNotEmpty &&
            filteredCities.isNotEmpty
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
            query != String() ? performSearch(query: query) : filteredCities.removeAll()
        }
        .store(in: &disposableBag)
    }
}
