import XCTest
@testable import UalaCities

final class SearchAlgorithmTests: XCTestCase {
    
    var testCities: [City]!
    
    override func setUp() {
        super.setUp()
        testCities = [
            City(id: 1, country: "US", name: "Alabama", coord: Coordinates(lon: -86.79113, lat: 32.806671)),
            City(id: 2, country: "US", name: "Albuquerque", coord: Coordinates(lon: -106.65014, lat: 35.08449)),
            City(id: 3, country: "US", name: "Anaheim", coord: Coordinates(lon: -117.91449, lat: 33.83659)),
            City(id: 4, country: "US", name: "Arizona", coord: Coordinates(lon: -111.43122, lat: 33.729759)),
            City(id: 5, country: "AU", name: "Sydney", coord: Coordinates(lon: 151.20732, lat: -33.86785))
        ]
        testCities = SearchAlgorithm.sortCities(testCities)
    }
    
    override func tearDown() {
        testCities = nil
        super.tearDown()
    }
    
    func testSearchWithPrefixA() {
        let results = SearchAlgorithm.searchCities(cities: testCities, prefix: "A")
        XCTAssertEqual(results.count, 4)
        XCTAssertTrue(results.contains { $0.name == "Alabama" })
        XCTAssertTrue(results.contains { $0.name == "Albuquerque" })
        XCTAssertTrue(results.contains { $0.name == "Anaheim" })
        XCTAssertTrue(results.contains { $0.name == "Arizona" })
        XCTAssertFalse(results.contains { $0.name == "Sydney" })
    }
    
    func testSearchWithPrefixAl() {
        let results = SearchAlgorithm.searchCities(cities: testCities, prefix: "Al")
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.contains { $0.name == "Alabama" })
        XCTAssertTrue(results.contains { $0.name == "Albuquerque" })
    }
    
    func testSearchWithPrefixS() {
        let results = SearchAlgorithm.searchCities(cities: testCities, prefix: "s")
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.contains { $0.name == "Sydney" })
    }
} 