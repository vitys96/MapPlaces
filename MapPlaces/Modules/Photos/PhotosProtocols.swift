//
//  PhotosProtocols.swift
//  MapPlaces
//
//  Created TOOK on 19.01.2020.
//  Copyright © 2020 TOOK. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import Foundation

//MARK: Wireframe -
enum PhotosNavigationOption {
    //    case firstModule
    //    case secondModule(someData)
}

protocol PhotosWireframeInterface: class {
    func navigate(to option: PhotosNavigationOption)
}

//MARK: Presenter -
protocol PhotosPresenterInterface: class {

    var interactor: PhotosInteractorInput? { get set }
    
    // MARK: - Lifecycle -
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()

}
extension PhotosPresenterInterface {
    func viewDidLoad() {/*leaves this empty*/}
    func viewWillAppear() {/*leaves this empty*/}
    func viewDidAppear() {/*leaves this empty*/}
    func viewWillDisappear() {/*leaves this empty*/}
    func viewDidDisappear() {/*leaves this empty*/}
}


//MARK: Interactor -
protocol PhotosInteractorOutput: class {

    /* Interactor -> Presenter */
}

protocol PhotosInteractorInput: class {

    var presenter: PhotosInteractorOutput?  { get set }

    /* Presenter -> Interactor */
}

//MARK: View -
protocol PhotosView: class {

    var presenter: PhotosPresenterInterface?  { get set }

    /* Presenter -> ViewController */
}
