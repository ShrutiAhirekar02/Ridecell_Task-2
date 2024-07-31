//
//  Vehicle.swift
//  Ridecell_Task
//
//  Created by Shruti Ahirekar on 29/07/24.
//
import Foundation

struct Vehicle: Codable {
    let id: Int
    let isActive: Bool?
    let isAvailable: Bool?
    let lat: Double?
    let lng: Double?
    let licensePlateNumber: String?
    let pool: String?
    let remainingMileage: Int?
    let remainingRangeInMeters: Int?
    let transmissionMode: String?
    let vehicleMake: String?
    let vehiclePic: String?
    let vehiclePicAbsoluteUrl: String?
    let vehicleType: String?
    let vehicleTypeId: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
        case isAvailable = "is_available"
        case lat
        case lng
        case licensePlateNumber = "license_plate_number"
        case pool
        case remainingMileage = "remaining_mileage"
        case remainingRangeInMeters = "remaining_range_in_meters"
        case transmissionMode = "transmission_mode"
        case vehicleMake = "vehicle_make"
        case vehiclePic = "vehicle_pic"
        case vehiclePicAbsoluteUrl = "vehicle_pic_absolute_url"
        case vehicleType = "vehicle_type"
        case vehicleTypeId = "vehicle_type_id"
    }
    
    // Function to decode JSON and process vehicles
    static func loadVehicles() {
        let jsonString = """
        [
            {
                "id": 84,
                "is_active": true,
                "is_available": true,
                "lat": 37.779816,
                "lng": -122.395447,
                "license_plate_number": "7LVF807",
                "pool": "active",
                "remaining_mileage": 91,
                "remaining_range_in_meters": 146000,
                "transmission_mode": "park",
                "vehicle_make": "BMW i3 Van",
                "vehicle_pic": "/media/uploads/vehicles/display_pics/739c2443-5c6b-405a-9eb1-b70f30debe34.png",
                "vehicle_pic_absolute_url": "https://d16vxu8318b851.cloudfront.net/uploads/vehicles/display_pics/739c2443-5c6b-405a-9eb1-b70f30debe34.png",
                "vehicle_type": "BMW i3 Van",
                "vehicle_type_id": 11
            },
            {
                "id": 1102,
                "is_active": true,
                "is_available": true,
                "lat": 47.61328,
                "lng": -122.342385,
                "license_plate_number": "7LKJ997",
                "pool": "active",
                "remaining_mileage": 37,
                "remaining_range_in_meters": 59000,
                "transmission_mode": "park",
                "vehicle_make": "BMW i3 Van",
                "vehicle_pic": "/media/uploads/vehicles/display_pics/5b96f5f8-2342-4448-8bfc-745275389988.png",
                "vehicle_pic_absolute_url": "https://d16vxu8318b851.cloudfront.net/uploads/vehicles/display_pics/5b96f5f8-2342-4448-8bfc-745275389988.png",
                "vehicle_type": "BMW i3 Van",
                "vehicle_type_id": 11
            },
            {
                "id": 4770,
                "is_active": true,
                "is_available": true,
                "license_plate_number": "plate627",
                "pool": "active",
                "remaining_mileage": 0,
                "vehicle_make": "BMW i3 Van",
                "vehicle_pic": "/media/uploads/vehicles/display_pics/739c2443-5c6b-405a-9eb1-b70f30debe34.png",
                "vehicle_pic_absolute_url": "https://d16vxu8318b851.cloudfront.net/uploads/vehicles/display_pics/739c2443-5c6b-405a-9eb1-b70f30debe34.png",
                "vehicle_type": "BMW i3 Van",
                "vehicle_type_id": 11
            }
        ]
        """
        
        // Convert the JSON string to Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error converting JSON string to Data")
            return
        }
        
        do {
            // Decode JSON data into an array of Vehicle objects
            let vehicles = try JSONDecoder().decode([Vehicle].self, from: jsonData)
            
            // Filter out vehicles with missing location data
            let validVehicles = vehicles.filter { $0.lat != nil && $0.lng != nil }
            
            // Print valid vehicles
            for vehicle in validVehicles {
                print("Vehicle ID: \(vehicle.id), Latitude: \(vehicle.lat!), Longitude: \(vehicle.lng!)")
            }
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
