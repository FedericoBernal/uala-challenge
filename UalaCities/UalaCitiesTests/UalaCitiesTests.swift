//
//  UalaCitiesTests.swift
//  UalaCitiesTests
//
//  Created by Federico Bernal on 18/08/2025.
//

import Testing
@testable import UalaCities

struct UalaCitiesTests {
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    // Include our custom test suites
    static var allTests = [
        CityTests.self,
        SearchAlgorithmTests.self,
        CitiesViewModelTests.self,
        FavoritesManagerTests.self
    ]
}
