//
//  ContentView.swift
//  UalaCities
//
//  Created by Federico Bernal on 18/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CitiesViewModel()
    @State private var selectedCity: City?
    @State private var showingCityDetail = false
    @State private var showingMap = false
    
    var body: some View {
        NavigationView {
            CityListView(
                viewModel: viewModel,
                onCityTap: { city in
                    selectedCity = city
                    showingMap = true
                },
                onCityInfoTap: { city in
                    selectedCity = city
                    showingCityDetail = true
                }
            )
            .sheet(isPresented: $showingCityDetail) {
                if let city = selectedCity {
                    NavigationView {
                        CityDetailView(
                            city: city,
                            isFavorite: viewModel.isFavorite(city),
                            onFavoriteToggle: {
                                viewModel.toggleFavorite(city)
                            },
                            onMapTap: {
                                showingCityDetail = false
                                showingMap = true
                            }
                        )
                    }
                }
            }
            .sheet(isPresented: $showingMap) {
                if let city = selectedCity {
                    NavigationView {
                        MapView(
                            cities: viewModel.filteredCities,
                            selectedCity: city,
                            onCityTap: { tappedCity in
                                selectedCity = tappedCity
                            }
                        )
                        .navigationTitle("Map")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    showingMap = false
                                }
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
