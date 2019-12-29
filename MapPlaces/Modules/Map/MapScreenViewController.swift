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
    var mapView = MKMapView()
    var searchTextField = SearchTextField()
    let collectionView = CollectionView()
    private var timer: Timer?
    private var startingScrollingOffset = CGPoint.zero
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupRegionForMap()
        presenter?.viewDidLoad()
    }
}


// MARK: - MapScreenView
extension MapScreenViewController: MapScreenView {
    func displayCollectionData(data: [PlacesCell.Data]) {
        collectionView.setContentOffset(.zero, animated: false)
        let provider = PlacesProvider(ArrayDataSource(data: data), tapHandler: { [weak self] context in
            guard let self = self else { return }
            let annotations = self.mapView.annotations
            annotations.forEach { (annotation) in
                if annotation.title == context.view.placeName.text {
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
        collectionView.provider = provider
    }
}

// MARK: - UI Config
extension MapScreenViewController {
    private func configureUI() {
        configureMapView()
        configureSearch()
        configureCollectionView()
    }
    private func configureMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
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
    }
    
    private func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
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
                print (mapItem.address())
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

extension MapScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.performLocalSearch()
        return true
    }
}

extension MapScreenViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true
        //        annotationView.image = #imageLiteral(resourceName: "tourist")
        return annotationView
    }
}

extension MapScreenViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startingScrollingOffset = scrollView.contentOffset
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth = collectionView.frame.width - CGFloat(60).dp //collectionSize.width
        let page: CGFloat
        let offset = scrollView.contentOffset.x // 2
        let proposedPage = offset / max(1, cellWidth)
        let snapPoint: CGFloat = 0.1
        let snapDelta: CGFloat = offset > startingScrollingOffset.x ? (1 - snapPoint) : snapPoint
        
        if floor(proposedPage + snapDelta) == floor(proposedPage) { // 3
            page = floor(proposedPage) // 4
        }
        else {
            page = floor(proposedPage + 1) // 5
        }
        
        targetContentOffset.pointee = CGPoint(
            x: cellWidth * page - 40, //spacing + inset
            y: targetContentOffset.pointee.y
        )
    }
}
