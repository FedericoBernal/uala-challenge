import Testing
@testable import UalaCities

struct FavoritesManagerTests {
    
    @Test func testInitialState() throws {
        let manager = FavoritesManager()
        
        #expect(manager.favoriteCityIds.count == 0)
        #expect(manager.getFavoritesCount() == 0)
    }
    
    @Test func testAddToFavorites() throws {
        let manager = FavoritesManager()
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        #expect(manager.isFavorite(testCity) == false)
        manager.addToFavorites(testCity)
        #expect(manager.isFavorite(testCity) == true)
        #expect(manager.getFavoritesCount() == 1)
    }
    
    @Test func testRemoveFromFavorites() throws {
        let manager = FavoritesManager()
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        manager.addToFavorites(testCity)
        #expect(manager.isFavorite(testCity) == true)
        
        manager.removeFromFavorites(testCity)
        #expect(manager.isFavorite(testCity) == false)
        #expect(manager.getFavoritesCount() == 0)
    }
    
    @Test func testToggleFavorite() throws {
        let manager = FavoritesManager()
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        // Initially not favorite
        #expect(manager.isFavorite(testCity) == false)
        
        // Toggle to favorite
        manager.toggleFavorite(testCity)
        #expect(manager.isFavorite(testCity) == true)
        #expect(manager.getFavoritesCount() == 1)
        
        // Toggle back to not favorite
        manager.toggleFavorite(testCity)
        #expect(manager.isFavorite(testCity) == false)
        #expect(manager.getFavoritesCount() == 0)
    }
    
    @Test func testClearAllFavorites() throws {
        let manager = FavoritesManager()
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
        
        manager.addToFavorites(testCity1)
        manager.addToFavorites(testCity2)
        #expect(manager.getFavoritesCount() == 2)
        
        manager.clearAllFavorites()
        #expect(manager.getFavoritesCount() == 0)
        #expect(manager.isFavorite(testCity1) == false)
        #expect(manager.isFavorite(testCity2) == false)
    }
} 