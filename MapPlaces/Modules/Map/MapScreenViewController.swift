//
//  MapScreenViewController.swift
//  MapPlaces
//
//  Created TOOK on 27.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//
import UIKit
import MapKit
import CollectionKit

class MapScreenViewController: UIViewController {
    // MARK: - Properties
    var presenter: MapScreenPresenterInterface?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchTextField = SearchTextField()
    let collectionView = CollectionView()
    private var startingScrollingOffset = CGPoint.zero
    private let locationManager = CLLocationManager()
    private var collectionData: [PlacesCell.Data] = []
    private let authorizationStatus = CLLocationManager.authorizationStatus()
    private let regionRadius: Double = 1000
    private var collectionViewDataSource = ArrayDataSource<PlacesCell.Data>(data: [])
    private var placesProvider: PlacesProvider!
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }
}


// MARK: - MapScreenView
extension MapScreenViewController: MapScreenView {
    func displayCollectionData(data: [PlacesCell.Data]) {
        collectionData = data
        collectionView.setContentOffset(.zero, animated: false)
        collectionViewDataSource.data = data
    }
}

// MARK: - UI Config
extension MapScreenViewController {
    private func configureUI() {
        configureMapView()
//        configureSearch()
        configureCollectionView()
        configureLocationServices()
    }
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        addDroppablePin()
        searchBar.delegate = self
//        view.addSubview(mapView)
//        mapView.fillSuperview()
    }
    private func configureSearch() {
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        view.addSubview(searchTextField)
        searchTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        searchTextField.backgroundColor = .white
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        let height: CGFloat = CGFloat(120).dp
        collectionView.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: view.frame.width, heightConstant: height)
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.delaysContentTouches = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        placesProvider = PlacesProvider(collectionViewDataSource, tapHandler: { [weak self] context in
            guard let self = self else { return }
            let annotations = self.mapView.annotations
            annotations.forEach { (annotation) in
                if annotation.title == context.view.placeName.text {
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
        collectionView.provider = placesProvider
        
    }
    
    // MARK: - LongPressGestureRecognizer
    private func addDroppablePin() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(dropPin))
        tap.minimumPressDuration = 0.5
        tap.delaysTouchesBegan = true
        mapView.addGestureRecognizer(tap)
    }
    
    private func removePins() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
    
    private func configGestures(isEnabled: Bool) {
        mapView.gestureRecognizers?.first?.isEnabled = isEnabled
    }
    
    // MARK: - Drop Pin
    @objc func dropPin(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            TapticEngine.impact.feedback(.heavy)
            removePins()
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
            annotation.coordinate = touchCoordinate
            ConvertCoordToPlacemark.lookUpCurrentLocation(touchCoordinates: touchCoordinate) { address in
                annotation.title = address
                annotation.subtitle = "Посмотреть фото"
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
                let circle = MKCircle(center: annotation.coordinate, radius: self.regionRadius)
                self.mapView.addOverlay(circle)
            }
        }
    }
    
    @objc private func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search:", err)
                return
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            var arrayOfMapItems: [MKMapItem] = []
            resp?.mapItems.forEach({ (mapItem) in
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                arrayOfMapItems.append(mapItem)
            })
            self.presenter?.mappingValues(items: arrayOfMapItems)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    private func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    private func searchIsDisplaying(textField: UITextField, isSearching: Bool) {
        textField.resignFirstResponder()
        if isSearching {
            self.removePins()
            self.performLocalSearch()
        } else {
            collectionViewDataSource.data.removeAll()
            self.removePins()
            textField.text?.removeAll()
            centerMapOnUserLocation()
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension MapScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchIsDisplaying(textField: textField, isSearching: true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchIsDisplaying(textField: textField, isSearching: false)
        return false
    }
    
}

// MARK: - MKMapViewDelegate
extension MapScreenViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        //        MKMarkerAnnotationView(annotation: <#T##MKAnnotation?#>, reuseIdentifier: <#T##String?#>)
        if annotation is MKPointAnnotation {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            annotationView.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        }
        if annotation is DroppablePin {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
            annotationView.canShowCallout = true
            annotationView.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            annotationView.animatesDrop = true
            annotationView.sizeToFit()
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard
            let index = collectionData.firstIndex(where: {$0.placeName == view.annotation?.title}),
            let coord = view.annotation?.coordinate
            else { return }
        
        let coordinateRegion = MKCoordinateRegion(center: coord, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        if collectionData.count != 1 {
            self.collectionView.scroll(to: index, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.cyan.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.cyan.withAlphaComponent(0.8)
        return renderer
    }
    
}

extension MapScreenViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.isTranslucent = false
    }
}

// MARK: - UIScrollViewDelegate
extension MapScreenViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startingScrollingOffset = scrollView.contentOffset
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth = collectionView.frame.width - CGFloat(64).dp //collectionSize.width
        let page: CGFloat
        let offset = scrollView.contentOffset.x
        let proposedPage = offset / max(1, cellWidth)
        let snapPoint: CGFloat = 0.1
        let snapDelta: CGFloat = offset > startingScrollingOffset.x ? (1 - snapPoint) : snapPoint
        
        if floor(proposedPage + snapDelta) == floor(proposedPage) {
            page = floor(proposedPage)
        }
        else {
            page = floor(proposedPage + 1)
        }
        
        targetContentOffset.pointee = CGPoint(
            x: cellWidth * page - 24, //spacing + inset
            y: targetContentOffset.pointee.y
        )
    }
}

