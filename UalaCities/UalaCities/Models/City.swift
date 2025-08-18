import Foundation
import CoreLocation

struct City: Codable, Identifiable, Hashable {
    let id: Int
    let country: String
    let name: String
    let coord: Coordinates
    
    // Custom coding keys to map "_id" to "id"
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country, name, coord
    }
    
    // Computed property for display name
    var displayName: String {
        return "\(name), \(country)"
    }
    
    // Computed property for coordinates string
    var coordinatesString: String {
        return "Lat: \(String(format: "%.4f", coord.lat)), Lon: \(String(format: "%.4f", coord.lon))"
    }
    
    // Computed property for CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Coordinates: Codable, Hashable {
    let lon: Double
    let lat: Double
} 