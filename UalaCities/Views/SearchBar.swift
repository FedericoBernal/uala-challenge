import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var showFavoritesOnly: Bool
    let totalCitiesCount: Int
    let favoritesCount: Int
    let onSearchTextChanged: (String) -> Void
    let onFavoritesToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Search input field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search cities...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        onSearchTextChanged(newValue)
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        onSearchTextChanged("")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Favorites toggle and counts
            HStack {
                Button(action: onFavoritesToggle) {
                    HStack {
                        Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                            .foregroundColor(showFavoritesOnly ? .red : .secondary)
                        Text(showFavoritesOnly ? "Show All" : "Favorites Only")
                            .foregroundColor(showFavoritesOnly ? .red : .primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(showFavoritesOnly ? .red : .secondary, lineWidth: 1)
                    )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Total: \(totalCitiesCount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if showFavoritesOnly {
                        Text("Favorites: \(favoritesCount)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    SearchBar(
        searchText: .constant(""),
        showFavoritesOnly: .constant(false),
        totalCitiesCount: 200000,
        favoritesCount: 5,
        onSearchTextChanged: { _ in },
        onFavoritesToggle: {}
    )
} 