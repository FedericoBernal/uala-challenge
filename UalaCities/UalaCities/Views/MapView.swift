import SwiftUI
import MapKit

struct MapView: View {
    let cities: [City]
    let selectedCity: City?
    let onCityTap: (City) -> Void
    
    @State private var region: MKCoordinateRegion
    @State private var mapType: MKMapType = .standard
    
    init(cities: [City], selectedCity: City? = nil, onCityTap: @escaping (City) -> Void) {
        self.cities = cities
        self.selectedCity = selectedCity
        self.onCityTap = onCityTap
        
        // Initialize map region
        if let selectedCity = selectedCity {
            self._region = State(initialValue: MKCoordinateRegion(
                center: selectedCity.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        } else if let firstCity = cities.first {
            self._region = State(initialValue: MKCoordinateRegion(
                center: firstCity.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            ))
        } else {
            // Default to a world view
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
            ))
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Map
            Map(coordinateRegion: $region, annotationItems: cities) { city in
                MapAnnotation(coordinate: city.coordinate) {
                    CityAnnotationView(
                        city: city,
                        isSelected: selectedCity?.id == city.id,
                        onTap: {
                            onCityTap(city)
                        }
                    )
                }
            }
            .mapStyle(mapType == .standard ? .standard : .hybrid)
            .ignoresSafeArea()
            
            // Map controls
            VStack(spacing: 12) {
                // Map type toggle
                Button(action: {
                    mapType = mapType == .standard ? .hybrid : .standard
                }) {
                    HStack {
                        Image(systemName: mapType == .standard ? "map" : "map.fill")
                        Text(mapType == .standard ? "Standard" : "Satellite")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                }
                
                // Zoom controls
                VStack(spacing: 4) {
                    Button(action: zoomIn) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Button(action: zoomOut) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.top, 60)
            .padding(.trailing, 16)
            
            // City info overlay (if city is selected)
            if let selectedCity = selectedCity {
                VStack {
                    Spacer()
                    
                    CityInfoOverlay(
                        city: selectedCity,
                        onClose: {
                            // Handle close if needed
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .onChange(of: selectedCity) { newCity in
            if let city = newCity {
                withAnimation(.easeInOut(duration: 0.5)) {
                    region.center = city.coordinate
                    region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                }
            }
        }
    }
    
    private func zoomIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            region.span.latitudeDelta *= 0.5
            region.span.longitudeDelta *= 0.5
        }
    }
    
    private func zoomOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            region.span.latitudeDelta *= 2.0
            region.span.longitudeDelta *= 2.0
        }
    }
}

struct CityAnnotationView: View {
    let city: City
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(isSelected ? .red : .blue)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
                
                if isSelected {
                    Text(city.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.white)
                        .cornerRadius(4)
                        .shadow(radius: 2)
                        .lineLimit(1)
                }
            }
        }
    }
}

struct CityInfoOverlay: View {
    let city: City
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(city.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(city.country)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            Text(city.coordinatesString)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}

#Preview {
    MapView(
        cities: [
            City(id: 707860, country: "UA", name: "Hurzuf", coord: Coordinates(lon: 34.283333, lat: 44.549999)),
            City(id: 707861, country: "US", name: "New York", coord: Coordinates(lon: -74.006, lat: 40.7128))
        ],
        selectedCity: City(id: 707860, country: "UA", name: "Hurzuf", coord: Coordinates(lon: 34.283333, lat: 44.549999)),
        onCityTap: { _ in }
    )
} 