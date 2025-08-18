import Foundation
import SwiftUI
import Combine

class CitiesViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var filteredCities: [City] = []
    @Published var showFavoritesOnly = false
    @Published var isLoading = false
    @Published var error: Error?
    
    private let citiesService = CitiesService()
    private let favoritesManager = FavoritesManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        citiesService.$allCities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
        
        citiesService.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        citiesService.$error
            .receive(on: DispatchQueue.main)
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
        
        favoritesManager.$favoriteCityIds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }
    
    func performSearch() {
        filteredCities = citiesService.getFilteredCities(
            searchText: searchText,
            showFavoritesOnly: showFavoritesOnly,
            favorites: favoritesManager.favoriteCityIds
        )
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        performSearch()
    }
    
    func toggleFavoritesOnly() {
        showFavoritesOnly.toggle()
        performSearch()
    }
    
    func toggleFavorite(_ city: City) {
        favoritesManager.toggleFavorite(city)
    }
    
    func isFavorite(_ city: City) -> Bool {
        return favoritesManager.isFavorite(city)
    }
    
    func getTotalCitiesCount() -> Int {
        return citiesService.getTotalCitiesCount()
    }
    
    func getFavoritesCount() -> Int {
        return favoritesManager.getFavoritesCount()
    }
    
    func reloadCities() {
        citiesService.reloadCities()
    }
    
    func clearSearch() {
        searchText = ""
        performSearch()
    }
    
    func getCitiesForSearch(_ searchText: String) -> [City] {
        return citiesService.getFilteredCities(
            searchText: searchText,
            showFavoritesOnly: showFavoritesOnly,
            favorites: favoritesManager.favoriteCityIds
        )
    }
} 