//
//  MainTabBarViewController.swift
//  navi
//
//  Created by Даня on 03.01.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        vc2.tabBarItem = UITabBarItem(title: "Coming", image: UIImage(systemName: "play.circle.fill"), selectedImage: nil)
        vc3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
    

}
