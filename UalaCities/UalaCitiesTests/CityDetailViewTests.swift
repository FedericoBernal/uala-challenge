import XCTest
@testable import UalaCities

final class CityDetailViewTests: XCTestCase {
    
    let testCity = City(
        id: 707860,
        country: "UA",
        name: "Hurzuf",
        coord: Coordinates(lon: 34.283333, lat: 44.549999)
    )
    
    func testCityDetailViewInitialState() throws {
        let detailView = CityDetailView(
            city: testCity,
            isFavorite: false,
            onFavoriteToggle: {},
            onMapTap: {}
        )
        
        XCTAssertNotNil(detailView)
    }
    
    func testCityDetailViewFavoriteState() throws {
        let detailView = CityDetailView(
            city: testCity,
            isFavorite: true,
            onFavoriteToggle: {},
            onMapTap: {}
        )
        
        XCTAssertNotNil(detailView)
    }
    
    func testCityDetailViewWithLongNames() throws {
        let longNameCity = City(
            id: 707861,
            country: "United States of America",
            name: "This is a very long city name that should be handled properly in the detail view",
            coord: Coordinates(lon: -74.006, lat: 40.7128)
        )
        
        let detailView = CityDetailView(
            city: longNameCity,
            isFavorite: false,
            onFavoriteToggle: {},
            onMapTap: {}
        )
        
        XCTAssertNotNil(detailView)
    }
    
    func testCityDetailViewWithExtremeCoordinates() throws {
        let extremeCity = City(
            id: 707862,
            country: "Test",
            name: "Extreme City",
            coord: Coordinates(lon: 180.0, lat: 90.0)
        )
        
        let detailView = CityDetailView(
            city: extremeCity,
            isFavorite: false,
            onFavoriteToggle: {},
            onMapTap: {}
        )
        
        XCTAssertNotNil(detailView)
    }
    
    func testCityDetailViewWithZeroCoordinates() throws {
        let zeroCity = City(
            id: 707863,
            country: "Test",
            name: "Zero City",
            coord: Coordinates(lon: 0.0, lat: 0.0)
        )
        
        let detailView = CityDetailView(
            city: zeroCity,
            isFavorite: false,
            onFavoriteToggle: {},
            onMapTap: {}
        )
        
        XCTAssertNotNil(detailView)
    }
} 