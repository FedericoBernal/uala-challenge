import XCTest
@testable import UalaCities

final class SearchBarTests: XCTestCase {
    
    func testSearchBarInitialState() throws {
        let searchBar = SearchBar(
            searchText: .constant(""),
            showFavoritesOnly: .constant(false),
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
    
    func testSearchBarWithSearchText() throws {
        let searchBar = SearchBar(
            searchText: .constant("New York"),
            showFavoritesOnly: .constant(false),
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
    
    func testSearchBarFavoritesOnly() throws {
        let searchBar = SearchBar(
            searchText: .constant(""),
            showFavoritesOnly: .constant(true),
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
    
    func testSearchBarWithDifferentStates() throws {
        let searchBar = SearchBar(
            searchText: .constant("London"),
            showFavoritesOnly: .constant(true),
            onSearchTextChanged: { _ in },
            onFavoritesToggle: {}
        )
        
        XCTAssertNotNil(searchBar)
    }
} 