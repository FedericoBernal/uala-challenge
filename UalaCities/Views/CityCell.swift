import SwiftUI

struct CityCell: View {
    let city: City
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onInfoTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // City info
            VStack(alignment: .leading, spacing: 4) {
                Text(city.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(city.coordinatesString)
                    .font(.caption)
                    .foregroundColor(.secondary)
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
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    CityCell(
        city: City(
            id: 707860,
            country: "UA",
            name: "Hurzuf",
            coord: Coordinates(lon: 34.283333, lat: 44.549999)
        ),
        isFavorite: false,
        onFavoriteToggle: {},
        onInfoTap: {}
    )
    .padding()
} 