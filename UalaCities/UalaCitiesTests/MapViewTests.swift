import XCTest
@testable import UalaCities

final class MapViewTests: XCTestCase {
    
    let testCities = [
        City(id: 707860, country: "UA", name: "Hurzuf", coord: Coordinates(lon: 34.283333, lat: 44.549999)),
        City(id: 707861, country: "US", name: "New York", coord: Coordinates(lon: -74.006, lat: 40.7128)),
        City(id: 707862, country: "UK", name: "London", coord: Coordinates(lon: -0.1276, lat: 51.5074))
    ]
    
    func testMapViewWithCities() throws {
        let mapView = MapView(
            cities: testCities,
            selectedCity: nil,
            onCityTap: { _ in }
        )
        
        XCTAssertNotNil(mapView)
    }
    
    func testMapViewWithSelectedCity() throws {
        let mapView = MapView(
            cities: testCities,
            selectedCity: testCities[0],
            onCityTap: { _ in }
        )
        
        XCTAssertNotNil(mapView)
    }
    
    func testMapViewEmptyCities() throws {
        let mapView = MapView(
            cities: [],
            selectedCity: nil,
            onCityTap: { _ in }
        )
        
        XCTAssertNotNil(mapView)
    }
    
    func testMapViewSingleCity() throws {
        let mapView = MapView(
            cities: [testCities[0]],
            selectedCity: testCities[0],
            onCityTap: { _ in }
        )
        
        XCTAssertNotNil(mapView)
    }
    
    func testMapViewWithManyCities() throws {
        let manyCities = (0..<100).map { i in
            City(
                id: i,
                country: "Test\(i)",
                name: "City\(i)",
                coord: Coordinates(lon: Double(i), lat: Double(i))
            )
        }
        
        let mapView = MapView(
            cities: manyCities,
            selectedCity: manyCities[0],
            onCityTap: { _ in }
        )
        
        XCTAssertNotNil(mapView)
    }
} 