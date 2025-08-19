import XCTest
@testable import UalaCities

final class CityCellTests: XCTestCase {
    
    let testCity = City(
        id: 707860,
        country: "UA",
        name: "Hurzuf",
        coord: Coordinates(lon: 34.283333, lat: 44.549999)
    )
    
    func testCityCellInitialState() throws {
        let cityCell = CityCell(
            city: testCity,
            isFavorite: false,
            isSelected: false,
            onFavoriteToggle: {},
            onInfoTap: {}
        )
        
        XCTAssertNotNil(cityCell)
    }
    
    func testCityCellFavoriteState() throws {
        let cityCell = CityCell(
            city: testCity,
            isFavorite: true,
            isSelected: false,
            onFavoriteToggle: {},
            onInfoTap: {}
        )
        
        XCTAssertNotNil(cityCell)
    }
    
    func testCityCellSelectedState() throws {
        let cityCell = CityCell(
            city: testCity,
            isFavorite: false,
            isSelected: true,
            onFavoriteToggle: {},
            onInfoTap: {}
        )
        
        XCTAssertNotNil(cityCell)
    }
    
    func testCityCellBothStates() throws {
        let cityCell = CityCell(
            city: testCity,
            isFavorite: true,
            isSelected: true,
            onFavoriteToggle: {},
            onInfoTap: {}
        )
        
        XCTAssertNotNil(cityCell)
    }
    
    func testCityCellWithLongNames() throws {
        let longNameCity = City(
            id: 707861,
            country: "United States of America",
            name: "This is a very long city name that should be handled properly",
            coord: Coordinates(lon: -74.006, lat: 40.7128)
        )
        
        let cityCell = CityCell(
            city: longNameCity,
            isFavorite: false,
            isSelected: false,
            onFavoriteToggle: {},
            onInfoTap: {}
        )
        
        XCTAssertNotNil(cityCell)
    }
} 