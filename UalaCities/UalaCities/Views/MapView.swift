import SwiftUI
import MapKit

struct MapView: View {
    let cities: [City]
    let selectedCity: City?
    let onCityTap: (City) -> Void
    
    @State private var mapType: MKMapType = .standard
    @State private var position: MapCameraPosition
    @State private var isMapReady = false
    
    init(cities: [City], selectedCity: City?, onCityTap: @escaping (City) -> Void) {
        self.cities = cities
        self.selectedCity = selectedCity
        self.onCityTap = onCityTap
        
        // Initialize with a default position (will be updated when cities are available)
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self._position = State(initialValue: .region(MKCoordinateRegion(
            center: defaultCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
        )))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Map")
                    .font(.headline)
                
                Spacer()
                
                Picker("Map Type", selection: $mapType) {
                    Text("Standard").tag(MKMapType.standard)
                    Text("Satellite").tag(MKMapType.satellite)
                    Text("Hybrid").tag(MKMapType.hybrid)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            // Map view
            Map(position: $position) {
                if let selectedCity = selectedCity {
                    Annotation(selectedCity.name, coordinate: selectedCity.coordinate) {
                        Button(action: {
                            onCityTap(selectedCity)
                        }) {
                            VStack(spacing: 2) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                Text(selectedCity.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.white)
                                    .cornerRadius(4)
                                    .shadow(radius: 1)
                            }
                        }
                    }
                } else if cities.count <= 10 {
                    ForEach(cities) { city in
                        Annotation(city.name, coordinate: city.coordinate) {
                            Button(action: {
                                onCityTap(city)
                            }) {
                                Image(systemName: "mappin.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                } else {
                    ForEach(Array(cities.prefix(5))) { city in
                        Annotation(city.name, coordinate: city.coordinate) {
                            Button(action: {
                                onCityTap(city)
                            }) {
                                Image(systemName: "mappin.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .mapStyle(mapType == .standard ? .standard : mapType == .satellite ? .hybrid : .hybrid)
            .onAppear {
                if !isMapReady {
                    updateMapPosition()
                    isMapReady = true
                }
            }
            .onChange(of: selectedCity) { _, _ in
                if isMapReady {
                    updateMapPosition()
                }
            }
        }
        .background(Color(.systemBackground))
    }
    
    private func updateMapPosition() {
        guard !cities.isEmpty else { return }
        
        if let selectedCity = selectedCity {
            position = .region(MKCoordinateRegion(
                center: selectedCity.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        } else if cities.count == 1 {
            position = .region(MKCoordinateRegion(
                center: cities[0].coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        } else if cities.count <= 10 {
            let coordinates = cities.map { $0.coordinate }
            let minLat = coordinates.map { $0.latitude }.min() ?? 0
            let maxLat = coordinates.map { $0.latitude }.max() ?? 0
            let minLon = coordinates.map { $0.longitude }.min() ?? 0
            let maxLon = coordinates.map { $0.longitude }.max() ?? 0
            
            let centerLat = (minLat + maxLat) / 2
            let centerLon = (minLon + maxLon) / 2
            let spanLat = max(maxLat - minLat, 0.1)
            let spanLon = max(maxLon - minLon, 0.1)
            
            position = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon)
            ))
        } else {
            position = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 120)
            ))
        }
    }
}

#Preview {
    MapView(
        cities: [
            City(id: 707860, country: "UA", name: "Hurzuf", coord: Coordinates(lon: 34.283333, lat: 44.549999)),
            City(id: 707861, country: "US", name: "New York", coord: Coordinates(lon: -74.006, lat: 40.7128))
        ],
        selectedCity: nil,
        onCityTap: { _ in }
    )
} 