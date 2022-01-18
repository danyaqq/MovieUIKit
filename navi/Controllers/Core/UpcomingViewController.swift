//
//  UpcomingViewController.swift
//  navi
//
//  Created by Даня on 03.01.2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var movies: [Movie] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        fetchUpcoming()
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download", image: UIImage(systemName: "square.and.arrow.down"), identifier: nil, discoverabilityTitle: nil, state: .off) { action in
                    print("Hello")
                }
                return UIMenu(image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [downloadAction])
            }
            return config
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieViewModel(titleName: movies[indexPath.row].originalName ?? movies[indexPath.row].originalTitle ?? "Unknown" , posterURL: movies[indexPath.row].posterPath ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        guard let titleName = movie.originalName ?? movie.originalTitle else { return }
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result{
            case .success(let video):
                
                DispatchQueue.main.async {
                    let vc = DetailViewController()
                    vc.configure(with: DetailViewModel(title: titleName, youtubeVideo: video, titleOverview: movie.overview ?? "No overview"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
        
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
