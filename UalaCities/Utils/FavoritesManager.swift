import Foundation

/// Manages favorite cities with persistent storage using UserDefaults
/// 
/// This class provides a simple and efficient way to store and retrieve favorite cities
/// between app launches. It uses UserDefaults for simplicity, but could be extended
/// to use Core Data for more complex scenarios.
class FavoritesManager: ObservableObject {
    
    /// Published property that triggers UI updates when favorites change
    @Published var favoriteCityIds: Set<Int> = []
    
    /// UserDefaults key for storing favorite city IDs
    private let favoritesKey = "FavoriteCityIds"
    
    init() {
        loadFavorites()
    }
    
    /// Adds a city to favorites
    /// - Parameter city: The city to add to favorites
    func addToFavorites(_ city: City) {
        favoriteCityIds.insert(city.id)
        saveFavorites()
    }
    
    /// Removes a city from favorites
    /// - Parameter city: The city to remove from favorites
    func removeFromFavorites(_ city: City) {
        favoriteCityIds.remove(city.id)
        saveFavorites()
    }
    
    /// Toggles the favorite status of a city
    /// - Parameter city: The city to toggle
    func toggleFavorite(_ city: City) {
        if favoriteCityIds.contains(city.id) {
            removeFromFavorites(city)
        } else {
            addToFavorites(city)
        }
    }
    
    /// Checks if a city is in favorites
    /// - Parameter city: The city to check
    /// - Returns: True if the city is in favorites
    func isFavorite(_ city: City) -> Bool {
        return favoriteCityIds.contains(city.id)
    }
    
    /// Gets the count of favorite cities
    /// - Returns: Number of favorite cities
    func getFavoritesCount() -> Int {
        return favoriteCityIds.count
    }
    
    /// Clears all favorites
    func clearAllFavorites() {
        favoriteCityIds.removeAll()
        saveFavorites()
    }
    
    // MARK: - Private Methods
    
    /// Loads favorites from UserDefaults
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let ids = try? JSONDecoder().decode(Set<Int>.self, from: data) {
            favoriteCityIds = ids
        }
    }
    
    /// Saves favorites to UserDefaults
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteCityIds) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
} 