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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var shouldShowSplitScreen: Bool {
        return horizontalSizeClass == .regular || 
               (horizontalSizeClass == .compact && verticalSizeClass == .compact)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView("Loading cities...")
                            .font(.headline)
                        Text("Please wait while we load the city data")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        
                        Text("Error loading cities")
                            .font(.headline)
                        
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            viewModel.reloadCities()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    if shouldShowSplitScreen {
                        HStack(spacing: 0) {
                            CityListView(
                                viewModel: viewModel,
                                selectedCity: $selectedCity,
                                onCityTap: { city in
                                    DispatchQueue.main.async {
                                        selectedCity = city
                                    }
                                },
                                onCityInfoTap: { city in
                                    selectedCity = city
                                    showingCityDetail = true
                                }
                            )
                            .frame(maxWidth: .infinity)
                            
                            MapView(
                                cities: viewModel.filteredCities,
                                selectedCity: selectedCity,
                                onCityTap: { city in
                                    DispatchQueue.main.async {
                                        selectedCity = city
                                    }
                                }
                            )
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        CityListView(
                            viewModel: viewModel,
                            selectedCity: $selectedCity,
                            onCityTap: { city in
                                selectedCity = city
                            },
                            onCityInfoTap: { city in
                                selectedCity = city
                                showingCityDetail = true
                            }
                        )
                        .background(
                            NavigationLink(
                                destination: PortraitMapView(
                                    cities: viewModel.filteredCities,
                                    selectedCity: selectedCity,
                                    onCityTap: { city in
                                        selectedCity = city
                                    }
                                ),
                                isActive: Binding(
                                    get: { selectedCity != nil },
                                    set: { if !$0 { selectedCity = nil } }
                                )
                            ) {
                                EmptyView()
                            }
                            .hidden()
                        )
                    }
                }
            }
            .navigationTitle("Uala Cities")
            .navigationBarTitleDisplayMode(.large)
        }
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
                            selectedCity = city
                        }
                    )
                }
            }
        }
        .environmentObject(viewModel)
    }
}

struct PortraitMapView: View {
    let cities: [City]
    let selectedCity: City?
    let onCityTap: (City) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        MapView(
            cities: cities,
            selectedCity: selectedCity,
            onCityTap: onCityTap
        )
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
