import XCTest
@testable import UalaCities

final class CityTests: XCTestCase {
    
    var testCity: City!
    
    override func setUp() {
        super.setUp()
        testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
    }
    
    override func tearDown() {
        testCity = nil
        super.tearDown()
    }
    
    func testCityInitialization() throws {
        XCTAssertEqual(testCity.id, 707860)
        XCTAssertEqual(testCity.country, "UA")
        XCTAssertEqual(testCity.name, "Hurzuf")
        XCTAssertEqual(testCity.coord.lon, 34.283333)
        XCTAssertEqual(testCity.coord.lat, 44.549999)
    }
    
    func testDisplayName() throws {
        XCTAssertEqual(testCity.displayName, "Hurzuf, UA")
    }
    
    func testCoordinatesString() throws {
        let expectedString = "Lat: 44.5500, Lon: 34.2833"
        XCTAssertEqual(testCity.coordinatesString, expectedString)
    }
    
    func testCoordinate() throws {
        let coordinate = testCity.coordinate
        XCTAssertEqual(coordinate.latitude, 44.549999)
        XCTAssertEqual(coordinate.longitude, 34.283333)
    }
} 