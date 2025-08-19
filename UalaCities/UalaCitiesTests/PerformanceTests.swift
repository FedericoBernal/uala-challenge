import XCTest
@testable import UalaCities

final class PerformanceTests: XCTestCase {
    
    func testSearchPerformanceWithLargeDataset() throws {
        let largeCities = (0..<10000).map { i in
            City(
                id: i,
                country: "Country\(i % 100)",
                name: "City\(i)",
                coord: Coordinates(lon: Double(i % 360), lat: Double(i % 180))
            )
        }
        
        let sortedCities = SearchAlgorithm.sortCities(largeCities)
        
        measure {
            let _ = SearchAlgorithm.searchCities(
                cities: sortedCities,
                prefix: "City1",
                showFavoritesOnly: false,
                favorites: []
            )
        }
    }
    
    func testSortingPerformance() throws {
        let largeCities = (0..<5000).map { i in
            City(
                id: i,
                country: "Country\(i % 50)",
                name: "City\(i)",
                coord: Coordinates(lon: Double(i % 360), lat: Double(i % 180))
            )
        }
        
        measure {
            let _ = SearchAlgorithm.sortCities(largeCities)
        }
    }
    
    func testFavoritesPerformance() throws {
        UserDefaults.standard.removeObject(forKey: "FavoriteCityIds")
        let favoritesManager = FavoritesManager()
        
        measure {
            for i in 0..<1000 {
                let city = City(
                    id: i,
                    country: "Test",
                    name: "City\(i)",
                    coord: Coordinates(lon: 0, lat: 0)
                )
                favoritesManager.addToFavorites(city)
            }
        }
        
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 1000)
        
        UserDefaults.standard.removeObject(forKey: "FavoriteCityIds")
    }
    
    func testSearchAlgorithmEfficiency() throws {
        let cities = (0..<1000).map { i in
            City(
                id: i,
                country: "Test",
                name: "City\(i)",
                coord: Coordinates(lon: 0, lat: 0)
            )
        }
        
        let sortedCities = SearchAlgorithm.sortCities(cities)
        
        measure {
            for prefix in ["C", "Ci", "Cit", "City"] {
                let _ = SearchAlgorithm.searchCities(
                    cities: sortedCities,
                    prefix: prefix,
                    showFavoritesOnly: false,
                    favorites: []
                )
            }
        }
    }
    
    func testLargeDatasetSortingPerformance() throws {
        let cities = (0..<50000).map { i in
            City(
                id: i,
                country: "Country\(i % 100)",
                name: "City\(i)",
                coord: Coordinates(lon: Double(i % 360), lat: Double(i % 180))
            )
        }
        
        measure {
            let _ = SearchAlgorithm.sortCities(cities)
        }
    }
    
    func testLargeDatasetSearchPerformance() throws {
        let cities = (0..<50000).map { i in
            City(
                id: i,
                country: "Country\(i % 100)",
                name: "City\(i)",
                coord: Coordinates(lon: Double(i % 360), lat: Double(i % 180))
            )
        }
        
        let sortedCities = SearchAlgorithm.sortCities(cities)
        
        measure {
            let _ = SearchAlgorithm.searchCities(
                cities: sortedCities,
                prefix: "City",
                showFavoritesOnly: false,
                favorites: []
            )
        }
    }
} 