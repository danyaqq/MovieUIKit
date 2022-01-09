//
//  HeroHeaderUIView.swift
//  Movie
//
//  Created by Даня on 04.01.2022.
//

//static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
//static let baseURL = "https://api.themoviedb.org"

import UIKit

class HeroHeaderUIView: UIView {
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.titleLabel?.textColor = UIColor.red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heroImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "poster")
        return image
    }()
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buttonsStackView.addArrangedSubview(playButton)
        buttonsStackView.addArrangedSubview(downloadButton)
        
        addSubview(heroImageView)
        addGradient()
        addSubview(buttonsStackView)
        
        applyConstraints()
    }
    
    private func applyConstraints(){
        
        let buttonsStackViewConstraints = [
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ]
        
        let playButtonConstraints = [
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
            downloadButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ]
        
        
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(buttonsStackViewConstraints)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
