//
//  CollectionViweTableViewCell.swift
//  navi
//
//  Created by Даня on 03.01.2022.
//

import UIKit

protocol CollectionViweTableViewCellDelegate: AnyObject{
    
    func collectionViweTableViewCellDidTapCell(_ cell: CollectionViweTableViewCell, viewModel: DetailViewModel)

}

class CollectionViweTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViweTableViewCell"
    
    weak var delegate: CollectionViweTableViewCellDelegate?
    
    private var movies: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movies: [Movie]){
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}


extension CollectionViweTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", image: UIImage(systemName: "square.and.arrow.down"), identifier: nil, discoverabilityTitle: nil, state: .off) { action in
                print("Hello")
            }
            return UIMenu(image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [downloadAction])
        }
        return config
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        guard let model = movies[indexPath.row].posterPath else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = self.movies[indexPath.row]
        guard let titleMovie = title.originalTitle ?? title.originalName else { return }
        
        APICaller.shared.getMovie(with: titleMovie + " trailer") { [weak self] result in
            switch result{
            case .success(let video):
                
                let title = self?.movies[indexPath.row]
                guard let titleMovie = title?.originalTitle ?? title?.originalName else { return }
                guard let titleOverView = title?.overview else { return }
                let viewModel = DetailViewModel(title: titleMovie, youtubeVideo: video, titleOverview: titleOverView)
                
                guard let strongSelf = self else { return }
                
                self?.delegate?.collectionViweTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


