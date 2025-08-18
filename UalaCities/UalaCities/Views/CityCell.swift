import SwiftUI

struct CityCell: View {
    let city: City
    let isFavorite: Bool
    let isSelected: Bool
    let onFavoriteToggle: () -> Void
    let onInfoTap: () -> Void
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var shouldShowSelection: Bool {
        return horizontalSizeClass == .regular || 
               (horizontalSizeClass == .compact && verticalSizeClass == .compact)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // City info
            VStack(alignment: .leading, spacing: 4) {
                Text(city.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(city.coordinatesString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Action buttons
            HStack(spacing: 8) {
                // Info button
                Button(action: onInfoTap) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                
                // Favorite toggle button
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .secondary)
                        .font(.title2)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            shouldShowSelection && isSelected ? Color.blue : Color.clear, 
                            lineWidth: 2
                        )
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    VStack(spacing: 16) {
        CityCell(
            city: City(
                id: 707860,
                country: "UA",
                name: "Hurzuf",
                coord: Coordinates(lon: 34.283333, lat: 44.549999)
            ),
            isFavorite: false,
            isSelected: false,
            onFavoriteToggle: {},
            onInfoTap: {}
        )
        
        CityCell(
            city: City(
                id: 707861,
                country: "US",
                name: "New York",
                coord: Coordinates(lon: -74.006, lat: 40.7128)
            ),
            isFavorite: true,
            isSelected: true,
            onFavoriteToggle: {},
            onInfoTap: {}
        )
    }
    .padding()
} 