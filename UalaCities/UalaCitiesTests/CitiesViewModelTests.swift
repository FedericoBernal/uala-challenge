import XCTest
@testable import UalaCities

final class CitiesViewModelTests: XCTestCase {
    
    var viewModel: CitiesViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CitiesViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() throws {
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertEqual(viewModel.filteredCities.count, 0)
        XCTAssertFalse(viewModel.showFavoritesOnly)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    func testUpdateSearchText() throws {
        viewModel.updateSearchText("Test")
        XCTAssertEqual(viewModel.searchText, "Test")
    }
    
    func testToggleFavoritesOnly() throws {
        XCTAssertFalse(viewModel.showFavoritesOnly)
        viewModel.toggleFavoritesOnly()
        XCTAssertTrue(viewModel.showFavoritesOnly)
        viewModel.toggleFavoritesOnly()
        XCTAssertFalse(viewModel.showFavoritesOnly)
    }
    
    func testClearSearch() throws {
        viewModel.updateSearchText("Test")
        XCTAssertEqual(viewModel.searchText, "Test")
        viewModel.clearSearch()
        XCTAssertEqual(viewModel.searchText, "")
    }
    
    func testGetCitiesForSearch() throws {
        let results = viewModel.getCitiesForSearch("Test")
        XCTAssertNotNil(results)
    }
    
    func testToggleFavorite() throws {
        let testCity = City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        )
        
        XCTAssertFalse(viewModel.isFavorite(testCity))
        
        viewModel.toggleFavorite(testCity)
        XCTAssertTrue(viewModel.isFavorite(testCity))
        
        viewModel.toggleFavorite(testCity)
        XCTAssertFalse(viewModel.isFavorite(testCity))
    }
    
    func testGetTotalCitiesCount() throws {
        let count = viewModel.getTotalCitiesCount()
        XCTAssertEqual(count, 0)
    }
    
    func testGetFavoritesCount() throws {
        let count = viewModel.getFavoritesCount()
        XCTAssertEqual(count, 0)
    }
} 