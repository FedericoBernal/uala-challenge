import SwiftUI
import MapKit

struct CityDetailView: View {
    let city: City
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onMapTap: () -> Void
    
    @State private var region: MKCoordinateRegion
    
    init(city: City, isFavorite: Bool, onFavoriteToggle: @escaping () -> Void, onMapTap: @escaping () -> Void) {
        self.city = city
        self.isFavorite = isFavorite
        self.onFavoriteToggle = onFavoriteToggle
        self.onMapTap = onMapTap
        
        // Initialize map region centered on the city
        let coordinate = city.coordinate
        self._region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // City header
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(city.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(city.country)
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: onFavoriteToggle) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(isFavorite ? .red : .secondary)
                        }
                    }
                    
                    Text(city.coordinatesString)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Map preview
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Location")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Open in Maps") {
                            onMapTap()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)
                    
                    Map(coordinateRegion: $region, annotationItems: [city]) { city in
                        MapMarker(coordinate: city.coordinate, tint: .red)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // City details
                VStack(alignment: .leading, spacing: 16) {
                    Text("City Information")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        DetailRow(title: "City ID", value: "\(city.id)")
                        DetailRow(title: "Country Code", value: city.country)
                        DetailRow(title: "Latitude", value: String(format: "%.6f", city.coord.lat))
                        DetailRow(title: "Longitude", value: String(format: "%.6f", city.coord.lon))
                    }
                    .padding(.horizontal)
                }
                
                // Action buttons
                VStack(spacing: 12) {
                    Button("Get Directions") {
                        openInMaps()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    
                    Button("Share City") {
                        shareCity()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("City Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openInMaps() {
        let coordinate = city.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = city.displayName
        mapItem.openInMaps(launchOptions: nil)
    }
    
    private func shareCity() {
        let text = "Check out \(city.displayName) at coordinates: \(city.coordinatesString)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        CityDetailView(
            city: City(
                id: 707860,
                country: "UA",
                name: "Hurzuf",
                coord: Coordinates(lon: 34.283333, lat: 44.549999)
            ),
            isFavorite: false,
            onFavoriteToggle: {},
            onMapTap: {}
        )
    }
} 