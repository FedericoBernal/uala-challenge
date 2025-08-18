import Foundation
import Combine

/// Service responsible for downloading and managing cities data
/// 
/// This service handles the network request to fetch cities from the JSON endpoint
/// and provides the data in a format optimized for the search algorithm.
class CitiesService: ObservableObject {
    
    /// Published property containing all cities
    @Published var allCities: [City] = []
    
    /// Published property indicating loading state
    @Published var isLoading = false
    
    /// Published property for error handling
    @Published var error: Error?
    
    /// The URL for the cities JSON data
    private let citiesURL = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
    
    /// Cancellable for network request
    private var cancellable: AnyCancellable?
    
    init() {
        loadCities()
    }
    
    /// Loads cities from the remote JSON endpoint
    func loadCities() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: citiesURL) else {
            error = NetworkError.invalidURL
            isLoading = false
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [City].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] cities in
                    // Sort cities for optimal search performance
                    self?.allCities = SearchAlgorithm.sortCities(cities)
                }
            )
    }
    
    /// Reloads cities data
    func reloadCities() {
        loadCities()
    }
    
    /// Gets cities filtered by search criteria
    /// - Parameters:
    ///   - searchText: The search prefix
    ///   - showFavoritesOnly: Whether to show only favorites
    ///   - favorites: Set of favorite city IDs
    /// - Returns: Filtered array of cities
    func getFilteredCities(
        searchText: String,
        showFavoritesOnly: Bool = false,
        favorites: Set<Int> = []
    ) -> [City] {
        return SearchAlgorithm.searchCities(
            cities: allCities,
            prefix: searchText,
            showFavoritesOnly: showFavoritesOnly,
            favorites: favorites
        )
    }
    
    /// Gets the total count of cities
    /// - Returns: Total number of cities
    func getTotalCitiesCount() -> Int {
        return allCities.count
    }
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        }
    }
} 