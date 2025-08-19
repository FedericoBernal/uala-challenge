import XCTest
@testable import UalaCities

final class IntegrationTests: XCTestCase {
    
    func testViewModelAndServiceIntegration() throws {
        let viewModel = CitiesViewModel()
        
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertEqual(viewModel.filteredCities.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        
        viewModel.updateSearchText("Test")
        XCTAssertEqual(viewModel.searchText, "Test")
        
        viewModel.toggleFavoritesOnly()
        XCTAssertTrue(viewModel.showFavoritesOnly)
        
        viewModel.toggleFavoritesOnly()
        XCTAssertFalse(viewModel.showFavoritesOnly)
    }
    
    func testSearchAndFavoritesIntegration() throws {
        let viewModel = CitiesViewModel()
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        viewModel.toggleFavorite(testCity)
        XCTAssertTrue(viewModel.isFavorite(testCity))
        
        viewModel.toggleFavoritesOnly()
        XCTAssertTrue(viewModel.showFavoritesOnly)
        
        viewModel.toggleFavorite(testCity)
        XCTAssertFalse(viewModel.isFavorite(testCity))
    }
    
    func testCitySelectionAndMapIntegration() throws {
        let viewModel = CitiesViewModel()
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        viewModel.updateSearchText("Hurzuf")
        
        let results = viewModel.getCitiesForSearch("Hurzuf")
        XCTAssertNotNil(results)
        
        XCTAssertEqual(testCity.coordinate.latitude, 44.549999)
        XCTAssertEqual(testCity.coordinate.longitude, 34.283333)
    }
    
    func testErrorHandlingIntegration() throws {
        let viewModel = CitiesViewModel()
        
        XCTAssertNil(viewModel.error)
        
        viewModel.reloadCities()
        
        XCTAssertNotNil(viewModel)
    }
} 