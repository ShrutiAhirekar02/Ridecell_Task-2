//
//  DetailsViewController.swift
//  Ridecell_Task
//
//  Created by Shruti Ahirekar on 31/07/24.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var isActive: Bool?
    var isAvailable: Bool?
    var lat: Double?
    var lng: Double?
    var pool: String?
    var vehicleTypeId: Int?
    var transmissionMode: String?
    var vehicles: [Vehicle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VehicleCell")
        tableView.reloadData()
        
        let detailsText = """
               Active: \(isActive ?? false)
               Available: \(isAvailable ?? false)
               Latitude: \(lat ?? 0.0)
               Longitude: \(lng ?? 0.0)
               Pool: \(pool ?? "N/A")
               Vehicle Type ID: \(vehicleTypeId ?? 0)
               Transmission Mode: \(transmissionMode ?? "N/A" )
               """
               
               detailsLabel.text = detailsText
           }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath)
        let vehicle = vehicles[indexPath.row]
        cell.textLabel?.text = "Type: \(vehicle.vehicleType ?? "N/A") - ID: \(vehicle.id)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = vehicles[indexPath.row]
        navigateToVehicle(withId: vehicle.id)
    }
    

    private func navigateToVehicle(withId id: Int) {
        NotificationCenter.default.post(name: .didSelectVehicle, object: id)
        navigationController?.popViewController(animated: true)
    }
    
    }
    

