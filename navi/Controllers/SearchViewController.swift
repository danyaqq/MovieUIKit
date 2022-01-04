//
//  SearchViewController.swift
//  navi
//
//  Created by Даня on 03.01.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 120, height: 44)
        button.backgroundColor = UIColor.green
        button.setTitle("Next VC", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
//        button.addAction(changeSelectedTab(), for: .touchUpInside)
        return button
    }()
    func changeSelectedTab(){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        nextButton.center = view.center
        view.addSubview(nextButton)
        
    }
    
    
}

