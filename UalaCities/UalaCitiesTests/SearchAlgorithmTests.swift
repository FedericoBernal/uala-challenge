import Testing
@testable import UalaCities

struct SearchAlgorithmTests {
    
    @Test func testSearchWithPrefixA() throws {
        let testCities = [
            City(id: 1, country: "US", name: "Alabama", coord: Coordinates(lon: -86.79113, lat: 32.806671)),
            City(id: 2, country: "US", name: "Albuquerque", coord: Coordinates(lon: -106.65014, lat: 35.08449)),
            City(id: 3, country: "US", name: "Anaheim", coord: Coordinates(lon: -117.91449, lat: 33.83659)),
            City(id: 4, country: "US", name: "Arizona", coord: Coordinates(lon: -111.43122, lat: 33.729759)),
            City(id: 5, country: "AU", name: "Sydney", coord: Coordinates(lon: 151.20732, lat: -33.86785))
        ]
        
        let sortedCities = SearchAlgorithm.sortCities(testCities)
        let results = SearchAlgorithm.searchCities(cities: sortedCities, prefix: "A")
        
        #expect(results.count == 4)
        #expect(results.contains { $0.name == "Alabama" })
        #expect(results.contains { $0.name == "Albuquerque" })
        #expect(results.contains { $0.name == "Anaheim" })
        #expect(results.contains { $0.name == "Arizona" })
        #expect(!results.contains { $0.name == "Sydney" })
    }
    
    @Test func testSearchWithPrefixAl() throws {
        let testCities = [
            City(id: 1, country: "US", name: "Alabama", coord: Coordinates(lon: -86.79113, lat: 32.806671)),
            City(id: 2, country: "US", name: "Albuquerque", coord: Coordinates(lon: -106.65014, lat: 35.08449)),
            City(id: 3, country: "US", name: "Anaheim", coord: Coordinates(lon: -117.91449, lat: 33.83659)),
            City(id: 4, country: "US", name: "Arizona", coord: Coordinates(lon: -111.43122, lat: 33.729759)),
            City(id: 5, country: "AU", name: "Sydney", coord: Coordinates(lon: 151.20732, lat: -33.86785))
        ]
        
        let sortedCities = SearchAlgorithm.sortCities(testCities)
        let results = SearchAlgorithm.searchCities(cities: sortedCities, prefix: "Al")
        
        #expect(results.count == 2)
        #expect(results.contains { $0.name == "Alabama" })
        #expect(results.contains { $0.name == "Albuquerque" })
    }
    
    @Test func testSearchWithPrefixS() throws {
        let testCities = [
            City(id: 1, country: "US", name: "Alabama", coord: Coordinates(lon: -86.79113, lat: 32.806671)),
            City(id: 2, country: "US", name: "Albuquerque", coord: Coordinates(lon: -106.65014, lat: 35.08449)),
            City(id: 3, country: "US", name: "Anaheim", coord: Coordinates(lon: -117.91449, lat: 33.83659)),
            City(id: 4, country: "US", name: "Arizona", coord: Coordinates(lon: -111.43122, lat: 33.729759)),
            City(id: 5, country: "AU", name: "Sydney", coord: Coordinates(lon: 151.20732, lat: -33.86785))
        ]
        
        let sortedCities = SearchAlgorithm.sortCities(testCities)
        let results = SearchAlgorithm.searchCities(cities: sortedCities, prefix: "s")
        
        #expect(results.count == 1)
        #expect(results.contains { $0.name == "Sydney" })
    }
} 