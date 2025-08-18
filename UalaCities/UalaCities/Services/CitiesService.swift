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
    
    /// Retry count for failed requests
    private var retryCount = 0
    private let maxRetries = 3
    
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
            .timeout(.seconds(30), scheduler: DispatchQueue.main) // Add timeout
            .map(\.data)
            .decode(type: [City].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] cities in
                    self?.retryCount = 0 // Reset retry count on success
                    self?.allCities = SearchAlgorithm.sortCities(cities)
                }
            )
    }
    
    /// Reloads cities data
    func reloadCities() {
        if retryCount < maxRetries {
            retryCount += 1
            loadCities()
        } else {
            error = NetworkError.maxRetriesExceeded
            isLoading = false
        }
    }
    
    /// Handles errors with retry logic
    private func handleError(_ error: Error) {
        if retryCount < maxRetries {
            // Auto-retry for certain errors
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.reloadCities()
            }
        } else {
            self.error = error
        }
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
    
    /// Checks if cities are loaded
    /// - Returns: True if cities are available
    func hasCities() -> Bool {
        return !allCities.isEmpty
    }
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case timeout
    case maxRetriesExceeded
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        case .timeout:
            return "Request timed out"
        case .maxRetriesExceeded:
            return "Maximum retry attempts exceeded"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Please check the URL configuration"
        case .noData:
            return "Please check your internet connection and try again"
        case .decodingError:
            return "The data format has changed. Please update the app"
        case .timeout:
            return "The request is taking too long. Please try again"
        case .maxRetriesExceeded:
            return "Please check your connection and try again later"
        }
    }
} 