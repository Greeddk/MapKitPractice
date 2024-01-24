//
//  ViewController.swift
//  MapKitPractice
//
//  Created by Greed on 1/24/24.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var mapKit: MKMapView!
    
    let theaterList = TheaterList().mapAnnotations
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in theaterList {
            self.setMap(item: item)
        }
        
        locationManager.delegate = self
        
        checkDeviceLocationAuthrization()

    }

    @IBAction func filterButtonClicked(_ sender: UIButton) {
        showActionSheet()
    }
    
    @IBAction func curretLocationClicked(_ sender: UIButton) {
        findMyCoordinate()
    }
    
}

extension ViewController {
    
    func showActionSheet() {
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let mega = UIAlertAction(title: "메가박스", style: .default) { _ in
            
            self.deleteAnnotation()
            for item in self.theaterList.filter({ $0.type == "메가박스" }) {
                self.setMap(item: item)
            }
            
        }
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
            
            self.deleteAnnotation()
            for item in self.theaterList.filter({ $0.type == "롯데시네마"}) {
                self.setMap(item: item)
            }
            
        }
        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
            
            self.deleteAnnotation()
            for item in self.theaterList.filter({ $0.type == "CGV"}) {
                self.setMap(item: item)
            }
            
        }
        let all = UIAlertAction(title: "전체보기", style: .default) { _ in
            
            self.deleteAnnotation()
            for item in self.theaterList {
                self.setMap(item: item)
            }
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        sheet.addAction(mega)
        sheet.addAction(lotte)
        sheet.addAction(cgv)
        sheet.addAction(all)
        sheet.addAction(cancel)
        
        present(sheet, animated: true)
        
    }
    
    func setMap(item: Theater) {
        
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapKit.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = item.location
        
        mapKit.addAnnotation(annotation)
        
    }
    
    func deleteAnnotation() {
        
        let allAnnotations = mapKit.annotations
        mapKit.removeAnnotations(allAnnotations)
        
    }
    
    func findMyCoordinate() {
        
        let currentLocation = locationManager.location?.coordinate
        let sesacCoordinate = CLLocationCoordinate2D(latitude: 39.01944, longitude: 125.75472)

        let region = MKCoordinateRegion(center: currentLocation ?? sesacCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapKit.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation ?? sesacCoordinate
        annotation.title = "요기있지~"
        
        mapKit.addAnnotation(annotation)
        
        locationManager.stopUpdatingLocation()
        
    }
    
}

extension ViewController {
    
    func checkDeviceLocationAuthrization() {
        
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {
                
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
                
            } else {
                
                print("위치 권한을 켜주세욤 ㅠㅠ")
            }
            
            self.locationManager.stopUpdatingLocation()
            
        }
        
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("notDetermined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            showAlert()
            
            self.findMyCoordinate()
        case .authorizedWhenInUse:
            print("authorezedWhenInUse")
            locationManager.startUpdatingLocation()
            
            self.findMyCoordinate()
        default:
            print("Authorization Error")
            
        }
        
    }
    
    func showAlert() { //권한이 필요하니 설정으로 이동시켜주는 알러트
        
        let alert = UIAlertController(title: "권한이 필요합니다", message: "위치 서비스를 사용하기 위해서는 설정에서 권한이 필요합니다.", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "확인", style: .default) { _ in
            
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("setting 오류")
            }
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthrization()
    }
}
