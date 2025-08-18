import Testing
@testable import UalaCities

struct CityTests {
    
    @Test func testCityInitialization() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        #expect(testCity.id == 707860)
        #expect(testCity.country == "UA")
        #expect(testCity.name == "Hurzuf")
        #expect(testCity.coord.lon == 34.283333)
        #expect(testCity.coord.lat == 44.549999)
    }
    
    @Test func testDisplayName() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        #expect(testCity.displayName == "Hurzuf, UA")
    }
    
    @Test func testCoordinatesString() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        let expectedString = "Lat: 44.5500, Lon: 34.2833"
        #expect(testCity.coordinatesString == expectedString)
    }
    
    @Test func testCoordinate() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        let coordinate = testCity.coordinate
        #expect(coordinate.latitude == 44.549999)
        #expect(coordinate.longitude == 34.283333)
    }
} 