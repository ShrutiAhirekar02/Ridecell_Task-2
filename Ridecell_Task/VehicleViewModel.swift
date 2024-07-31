//
//  VehicleViewModel.swift
//  Ridecell_Task
//
//  Created by Shruti Ahirekar on 29/07/24.
import Foundation

class VehicleViewModel {
    var vehicles: [Vehicle] = []
    
    func loadVehicles() {
        guard let url = Bundle.main.url(forResource: "vehicles", withExtension: "json") else {
            print("Error: vehicles.json file not found in the main bundle.")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Error: Failed to load data from vehicles.json.")
            return
        }
        
        // Print JSON data as a string for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON Data: \(jsonString)")
        } else {
            print("Error: Failed to convert data to JSON string.")
        }
        
        // Decode JSON data into Vehicle objects
        do {
            let decoder = JSONDecoder()
            self.vehicles = try decoder.decode([Vehicle].self, from: data)
            print("Loaded vehicles: \(self.vehicles.count)")
        } catch {
            print("Error: Failed to decode vehicles.json data. \(error.localizedDescription)")
        }
    }
}
