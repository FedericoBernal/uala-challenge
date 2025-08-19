import XCTest
@testable import UalaCities

final class SearchBarTests: XCTestCase {
    
    func testSearchBarInitialState() throws {
        let searchBar = SearchBar(
            searchText: .constant(""),
            showFavoritesOnly: .constant(false),
            totalCitiesCount: 200000,
            favoritesCount: 5,
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
    
    func testSearchBarWithSearchText() throws {
        let searchBar = SearchBar(
            searchText: .constant("New York"),
            showFavoritesOnly: .constant(false),
            totalCitiesCount: 200000,
            favoritesCount: 5,
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
    
    func testSearchBarFavoritesOnly() throws {
        let searchBar = SearchBar(
            searchText: .constant(""),
            showFavoritesOnly: .constant(true),
            totalCitiesCount: 200000,
            favoritesCount: 5,
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
    
    func testSearchBarWithHighCounts() throws {
        let searchBar = SearchBar(
            searchText: .constant(""),
            showFavoritesOnly: .constant(false),
            totalCitiesCount: 999999,
            favoritesCount: 999,
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
} 