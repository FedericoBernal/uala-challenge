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
        citiesService.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        citiesService.$error
            .receive(on: DispatchQueue.main)
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
        
        citiesService.$allCities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                guard let self = self else { return }
                if !cities.isEmpty && self.searchText.isEmpty && !self.showFavoritesOnly {
                    self.filteredCities = cities
                } else if !cities.isEmpty {
                    self.performSearch()
                }
            }
            .store(in: &cancellables)
        
        favoritesManager.$favoriteCityIds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.citiesService.allCities.isEmpty {
                    self.performSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func performSearch() {
        guard !citiesService.isLoading else { return }
        
        filteredCities = citiesService.getFilteredCities(
            searchText: searchText,
            showFavoritesOnly: showFavoritesOnly,
            favorites: favoritesManager.favoriteCityIds
        )
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        DispatchQueue.main.async {
            self.performSearch()
        }
    }
    
    func toggleFavoritesOnly() {
        showFavoritesOnly.toggle()
        DispatchQueue.main.async {
            self.performSearch()
        }
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
        DispatchQueue.main.async {
            self.performSearch()
        }
    }
    
    func getCitiesForSearch(_ searchText: String) -> [City] {
        return citiesService.getFilteredCities(
            searchText: searchText,
            showFavoritesOnly: showFavoritesOnly,
            favorites: favoritesManager.favoriteCityIds
        )
    }
} 