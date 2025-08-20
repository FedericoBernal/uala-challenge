import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var showFavoritesOnly: Bool
    let onSearchTextChanged: (String) -> Void
    let onFavoritesToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Search input field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search cities...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: searchText) { _, newValue in
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
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Favorites toggle and counts
            HStack {
                Button(action: onFavoritesToggle) {
                    HStack(spacing: 6) {
                        Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                            .foregroundColor(showFavoritesOnly ? .red : .secondary)
                        Text(showFavoritesOnly ? "Show All" : "Favorites Only")
                            .font(.subheadline)
                            .foregroundColor(showFavoritesOnly ? .red : .primary)
                    }
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Text("\(searchText.isEmpty ? "All" : "Found") cities")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

#Preview {
    SearchBar(
        searchText: .constant("New York"),
        showFavoritesOnly: .constant(false),
        onSearchTextChanged: { _ in },
        onFavoritesToggle: {}
    )
} 