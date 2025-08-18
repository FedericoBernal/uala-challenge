import SwiftUI

struct CityListView: View {
    @ObservedObject var viewModel: CitiesViewModel
    let onCityTap: (City) -> Void
    let onCityInfoTap: (City) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            SearchBar(
                searchText: $viewModel.searchText,
                showFavoritesOnly: $viewModel.showFavoritesOnly,
                totalCitiesCount: viewModel.getTotalCitiesCount(),
                favoritesCount: viewModel.getFavoritesCount(),
                onSearchTextChanged: { text in
                    viewModel.updateSearchText(text)
                },
                onFavoritesToggle: {
                    viewModel.toggleFavoritesOnly()
                }
            )
            
            // Cities list
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading cities...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            } else if let error = viewModel.error {
                Spacer()
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
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            } else if viewModel.filteredCities.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    if viewModel.searchText.isEmpty && !viewModel.showFavoritesOnly {
                        Text("No cities found")
                            .font(.headline)
                        Text("Cities are being loaded...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if viewModel.showFavoritesOnly {
                        Text("No favorite cities")
                            .font(.headline)
                        Text("Add cities to your favorites to see them here")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("No cities match '\(viewModel.searchText)'")
                            .font(.headline)
                        Text("Try a different search term")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            } else {
                List(viewModel.filteredCities, id: \.id) { city in
                    CityCell(
                        city: city,
                        isFavorite: viewModel.isFavorite(city),
                        onFavoriteToggle: {
                            viewModel.toggleFavorite(city)
                        },
                        onInfoTap: {
                            onCityInfoTap(city)
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .onTapGesture {
                        onCityTap(city)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Cities")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        CityListView(
            viewModel: CitiesViewModel(),
            onCityTap: { _ in },
            onCityInfoTap: { _ in }
        )
    }
} 