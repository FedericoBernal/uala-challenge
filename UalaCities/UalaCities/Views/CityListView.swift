import SwiftUI

struct CityListView: View {
    @ObservedObject var viewModel: CitiesViewModel
    @Binding var selectedCity: City?
    let onCityTap: (City) -> Void
    let onCityInfoTap: (City) -> Void
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var shouldShowSelection: Bool {
        return horizontalSizeClass == .regular || 
               (horizontalSizeClass == .compact && verticalSizeClass == .compact)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            SearchBar(
                searchText: $viewModel.searchText,
                showFavoritesOnly: $viewModel.showFavoritesOnly,
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
                        isSelected: shouldShowSelection && selectedCity?.id == city.id,
                        onFavoriteToggle: {
                            viewModel.toggleFavorite(city)
                        },
                        onInfoTap: {
                            onCityInfoTap(city)
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(shouldShowSelection && selectedCity?.id == city.id ? Color.blue.opacity(0.1) : Color.clear)
                    )
                    .contentShape(Rectangle())
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
            selectedCity: .constant(nil),
            onCityTap: { _ in },
            onCityInfoTap: { _ in }
        )
    }
} 