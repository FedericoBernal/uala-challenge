import Foundation

/// Optimized search algorithm for cities using prefix-based matching
/// 
/// This implementation uses a binary search approach for O(log n) average case performance
/// when searching through sorted city data. The cities are pre-sorted by city name first,
/// then by country code to ensure consistent ordering.
class SearchAlgorithm {
    
    /// Searches for cities that match the given prefix
    /// - Parameters:
    ///   - cities: Sorted array of cities (must be sorted by city name, then country)
    ///   - prefix: The search prefix (case insensitive)
    ///   - showFavoritesOnly: Whether to filter only favorite cities
    ///   - favorites: Set of favorite city IDs
    /// - Returns: Array of matching cities
    static func searchCities(
        cities: [City],
        prefix: String,
        showFavoritesOnly: Bool = false,
        favorites: Set<Int> = []
    ) -> [City] {
        // Early return for empty prefix
        guard !prefix.isEmpty else {
            if showFavoritesOnly {
                return cities.filter { favorites.contains($0.id) }
            }
            return cities
        }
        
        let lowercasedPrefix = prefix.lowercased()
        
        if showFavoritesOnly {
            return cities.filter { city in
                favorites.contains(city.id) && 
                city.name.lowercased().hasPrefix(lowercasedPrefix)
            }
        }
        
        let startIndex = findStartingIndex(for: lowercasedPrefix, in: cities)
        
        // Collect all matching cities from the starting point
        var results: [City] = []
        
        for i in startIndex..<cities.count {
            let city = cities[i]
            
            // Check if city name starts with prefix (case insensitive)
            let cityNameLowercased = city.name.lowercased()
            
            // If we've moved past cities that could match the prefix, stop searching
            if !cityNameLowercased.hasPrefix(lowercasedPrefix) {
                break
            }
            
            results.append(city)
        }
        
        return results
    }
    
    /// Binary search to find the starting index for cities matching the prefix
    /// - Parameters:
    ///   - prefix: The search prefix (lowercased)
    ///   - cities: Sorted array of cities
    /// - Returns: Index where cities matching the prefix begin
    private static func findStartingIndex(for prefix: String, in cities: [City]) -> Int {
        var left = 0
        var right = cities.count
        
        while left < right {
            let mid = left + (right - left) / 2
            let cityName = cities[mid].name.lowercased()
            
            if cityName < prefix {
                left = mid + 1
            } else {
                right = mid
            }
        }
        
        return left
    }
    
    /// Sorts cities by name first, then by country code for consistent ordering
    /// This sorting is crucial for the binary search algorithm to work correctly
    /// - Parameter cities: Array of cities to sort
    /// - Returns: Sorted array of cities
    static func sortCities(_ cities: [City]) -> [City] {
        return cities.sorted { city1, city2 in
            let nameComparison = city1.name.localizedCaseInsensitiveCompare(city2.name)
            if nameComparison == .orderedSame {
                return city1.country.localizedCaseInsensitiveCompare(city2.country) == .orderedAscending
            }
            return nameComparison == .orderedAscending
        }
    }
} 