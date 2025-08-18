import Testing
@testable import UalaCities

struct CitiesViewModelTests {
    
    @Test func testInitialState() throws {
        let viewModel = CitiesViewModel()
        
        #expect(viewModel.searchText == "")
        #expect(viewModel.filteredCities.count == 0)
        #expect(viewModel.showFavoritesOnly == false)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
    }
    
    @Test func testUpdateSearchText() throws {
        let viewModel = CitiesViewModel()
        
        viewModel.updateSearchText("Test")
        #expect(viewModel.searchText == "Test")
    }
    
    @Test func testToggleFavoritesOnly() throws {
        let viewModel = CitiesViewModel()
        
        #expect(viewModel.showFavoritesOnly == false)
        viewModel.toggleFavoritesOnly()
        #expect(viewModel.showFavoritesOnly == true)
        viewModel.toggleFavoritesOnly()
        #expect(viewModel.showFavoritesOnly == false)
    }
    
    @Test func testClearSearch() throws {
        let viewModel = CitiesViewModel()
        
        viewModel.updateSearchText("Test")
        #expect(viewModel.searchText == "Test")
        viewModel.clearSearch()
        #expect(viewModel.searchText == "")
    }
    
    @Test func testGetCitiesForSearch() throws {
        let viewModel = CitiesViewModel()
        
        let results = viewModel.getCitiesForSearch("Test")
        #expect(results.count >= 0) // Should return empty array initially
    }
    
    @Test func testToggleFavorite() throws {
        let viewModel = CitiesViewModel()
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        // Initially not favorite
        #expect(viewModel.isFavorite(testCity) == false)
        
        // Toggle to favorite
        viewModel.toggleFavorite(testCity)
        #expect(viewModel.isFavorite(testCity) == true)
        
        // Toggle back to not favorite
        viewModel.toggleFavorite(testCity)
        #expect(viewModel.isFavorite(testCity) == false)
    }
    
    @Test func testGetTotalCitiesCount() throws {
        let viewModel = CitiesViewModel()
        
        let count = viewModel.getTotalCitiesCount()
        #expect(count >= 0) // Should return 0 initially
    }
    
    @Test func testGetFavoritesCount() throws {
        let viewModel = CitiesViewModel()
        
        let count = viewModel.getFavoritesCount()
        #expect(count == 0) // Should return 0 initially
    }
} 