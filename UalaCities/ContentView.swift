import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CitiesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading cities...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error loading cities")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            viewModel.reloadCities()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        Text("Cities loaded: \(viewModel.getTotalCitiesCount())")
                            .font(.headline)
                            .padding()
                        
                        Text("Favorites: \(viewModel.getFavoritesCount())")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button("Toggle Favorites Only") {
                            viewModel.toggleFavoritesOnly()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        if viewModel.showFavoritesOnly {
                            Text("Showing favorites only")
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Uala Cities")
            .navigationBarTitleDisplayMode(.large)
        }
        .environmentObject(viewModel)
    }
} 