//
//  ViewController.swift
//  Ridecell_Task
//
//  Created by Shruti Ahirekar on 29/07/24.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: VehicleViewModel!
    var selectedVehicle: Vehicle?
    
    let defaultLatitude: Double = 0.0
    let defaultLongitude: Double = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel = VehicleViewModel()
        mapView.delegate = self
        fetchVehicles()
        
        if viewModel.vehicles.isEmpty {
         
        } else {
            print("Vehicles loaded: \(viewModel.vehicles.count)")
            setupMap()
            collectionView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleVehicleSelection(_:)), name: .didSelectVehicle, object: nil)
            }

            @objc private func handleVehicleSelection(_ notification: Notification) {
                guard let id = notification.object as? Int,
                      let index = viewModel.vehicles.firstIndex(where: { $0.id == id }) else { return }

                let indexPath = IndexPath(item: index, section: 0)
                
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

                let vehicle = viewModel.vehicles[indexPath.item]
                let location = CLLocationCoordinate2D(
                    latitude: vehicle.lat ?? defaultLatitude,
                    longitude: vehicle.lng ?? defaultLongitude
                )
                mapView.setCenter(location, animated: true)
            }
    
    private func setupMap() {
        guard let firstVehicle = viewModel.vehicles.first else {
            print("No vehicles available for map setup")
            return
        }
        
        let initialLocation = CLLocationCoordinate2D(latitude: firstVehicle.lat ?? defaultLatitude, longitude: firstVehicle.lng ?? defaultLongitude)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let geocoder = CLGeocoder()
        
        for vehicle in viewModel.vehicles {
            guard let latitude = vehicle.lat, let longitude = vehicle.lng else {
                continue
            }
            
            let annotation = VehicleAnnotation(vehicle: vehicle)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = vehicle.vehicleMake
            mapView.addAnnotation(annotation)
        }
    }
    
    private func fetchVehicles() {
        guard let url = Bundle.main.url(forResource: "vehicles", withExtension: "json") else {
            print("Failed to find vehicles.json in the bundle")
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let vehicles = try decoder.decode([Vehicle].self, from: data)
                
                DispatchQueue.main.async {
                    self.viewModel.vehicles = vehicles
                    self.setupMap()
                    self.collectionView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                   print("Error decoding vehicles data: \(error.localizedDescription)")
                }
            }
        }
    }
  
    @IBAction func details_Button(_ sender: Any) {
        
        guard let vehicle = viewModel.vehicles.first else {
                   print("No vehicle to display details for")
                   return
               }
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                   
                   detailsVC.vehicles = viewModel.vehicles
                   detailsVC.isActive = vehicle.isActive
                   detailsVC.isAvailable = vehicle.isAvailable
                   detailsVC.lat = vehicle.lat
                   detailsVC.lng = vehicle.lng
                   detailsVC.pool = vehicle.pool
                   detailsVC.vehicleTypeId = vehicle.vehicleTypeId
                   detailsVC.transmissionMode = vehicle.transmissionMode
                   
                   navigationController?.pushViewController(detailsVC, animated: true)
               }
                }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? VehicleAnnotation {
            let vehicle = annotation.vehicle
            if let index = viewModel.vehicles.firstIndex(where: { $0.id == vehicle.id }) {
                let indexPath = IndexPath(item: index, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
                let location = CLLocationCoordinate2D(
                    latitude: vehicle.lat ?? defaultLatitude,
                    longitude: vehicle.lng ?? defaultLongitude
                )
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.vehicles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleCell", for: indexPath) as! VehicleDetailsCollectionViewCell
        let vehicle = viewModel.vehicles[indexPath.row]
        cell.vehicle_type_label.text = vehicle.vehicleType
        cell.details_label.text = """
            ID: \(vehicle.id)
            License Plate: \(vehicle.licensePlateNumber ?? "N/A")
            Remaining Mileage: \(vehicle.remainingMileage ?? 0)
            Range: \(vehicle.remainingRangeInMeters ?? 0) meters
        """
        cell.imageView.image = UIImage(named: "placeholder")

            if let urlString = vehicle.vehiclePicAbsoluteUrl, let url = URL(string: urlString) {
                cell.imageView.af.setImage(withURL: url)

        } else {
            cell.imageView.image = UIImage(named: "placeholder")
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vehicle = viewModel.vehicles[indexPath.row]
        let location = CLLocationCoordinate2D(
            latitude: vehicle.lat ?? defaultLatitude,
            longitude: vehicle.lng ?? defaultLongitude
        )
        mapView.setCenter(location, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let height: CGFloat = 180
            return CGSize(width: width, height: height)
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let center = CGPoint(x: collectionView.bounds.width / 2 + collectionView.contentOffset.x, y: collectionView.bounds.height / 2)
        guard let indexPath = collectionView.indexPathForItem(at: center) else { return }
        
        let vehicle = viewModel.vehicles[indexPath.item]
        let location = CLLocationCoordinate2D(
            latitude: vehicle.lat ?? defaultLatitude,
            longitude: vehicle.lng ?? defaultLongitude
        )
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}

class VehicleAnnotation: MKPointAnnotation {
    var vehicle: Vehicle
    var placeName: String?

    init(vehicle: Vehicle, placeName: String? = nil) {
        self.vehicle = vehicle
        self.placeName = placeName
        super.init()
    }
}

extension NSNotification.Name {
    static let didSelectVehicle = NSNotification.Name("didSelectVehicle")
}
