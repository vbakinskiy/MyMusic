//
//  MainTabBarController.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/22/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
}

class MainTabBarController: UITabBarController {
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackDetailView()
        
        view.backgroundColor = .white
        tabBar.tintColor = secondarySystemColor
        
        viewControllers = [
            generateVC(rootViewController: searchVC, image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon"), title: "Search"),
            generateVC(rootViewController: ViewController(), image: #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon"), title: "Library")
        ]
    }
    
    private func generateVC(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        
        // auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true  
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func minimizeTrackDetailController() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: self.view.layoutIfNeeded,
            completion: nil)
    }
}
