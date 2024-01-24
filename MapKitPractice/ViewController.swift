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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in theaterList {
            self.setMap(item: item)
        }

    }

    @IBAction func filterButtonClicked(_ sender: UIButton) {
        showActionSheet()
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
    
}

extension ViewController {
    
}
