import XCTest
@testable import UalaCities

final class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "FavoriteCityIds")
        favoritesManager = FavoritesManager()
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "FavoriteCityIds")
        favoritesManager = nil
        super.tearDown()
    }
    
    func testInitialState() throws {
        XCTAssertEqual(favoritesManager.favoriteCityIds.count, 0)
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 0)
    }
    
    func testAddToFavorites() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        XCTAssertFalse(favoritesManager.isFavorite(testCity))
        favoritesManager.addToFavorites(testCity)
        XCTAssertTrue(favoritesManager.isFavorite(testCity))
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 1)
    }
    
    func testRemoveFromFavorites() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        favoritesManager.addToFavorites(testCity)
        XCTAssertTrue(favoritesManager.isFavorite(testCity))
        
        favoritesManager.removeFromFavorites(testCity)
        XCTAssertFalse(favoritesManager.isFavorite(testCity))
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 0)
    }
    
    func testToggleFavorite() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        XCTAssertFalse(favoritesManager.isFavorite(testCity))
        
        favoritesManager.toggleFavorite(testCity)
        XCTAssertTrue(favoritesManager.isFavorite(testCity))
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 1)
        
        favoritesManager.toggleFavorite(testCity)
        XCTAssertFalse(favoritesManager.isFavorite(testCity))
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 0)
    }
    
    func testClearAllFavorites() throws {
        let testCity1 = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        let testCity2 = City(
            id: 707861,
            country: "US",
            name: "New York",
            coord: Coordinates(lon: -74.006, lat: 40.7128)
        )
        
        favoritesManager.addToFavorites(testCity1)
        favoritesManager.addToFavorites(testCity2)
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 2)
        
        favoritesManager.clearAllFavorites()
        XCTAssertEqual(favoritesManager.getFavoritesCount(), 0)
        XCTAssertFalse(favoritesManager.isFavorite(testCity1))
        XCTAssertFalse(favoritesManager.isFavorite(testCity2))
    }
} 