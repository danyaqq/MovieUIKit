//
//  SearchViewController.swift
//  navi
//
//  Created by Даня on 03.01.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
// Создание массива с фильмами
    
    private var movies: [Movie] = []
    
// MARK: Создание UI элементов
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        discoverTableConfigure()
        fetchDiscover()
    }
    
// Функции для разгрузки viewDidLoad
    
    private func configureUI(){
        title = "Search"
        view.backgroundColor = .systemBackground
        view.addSubview(discoverTable)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
    }
    
    private func discoverTableConfigure(){
        discoverTable.delegate = self
        discoverTable.dataSource = self
    }
    
// Вызов функции, которая и перезагружает строки и секции таблицы
    
    private func fetchDiscover(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
}

// MARK: Расширение SearchViewControllel, которое содержит в себе методы протоколов TableView
// Разгружаем контроллер от большого количества кода

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{

// Метод для создания контекстного меню, которое появляется при долгом нажатии на Row
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download", image: UIImage(systemName: "square.and.arrow.down"), identifier: nil, discoverabilityTitle: nil, state: .off) { action in
                    print("Hello")
                }
                return UIMenu(image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [downloadAction])
            }
            return config
    }
    
// Количество строк в секции
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

// Создаём и конфигурируем ячейку
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        let model = MovieViewModel(titleName: movie.originalTitle ?? movie.originalName ?? "Unknown", posterURL: movie.posterPath ?? "")
        
        cell.configure(with: model)
        return cell
    }
    
// Задаём высоту для Row
    
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

// MARK: Расширение SearchViewControllel для UISearchController

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultController = searchController.searchResultsController as? SearchResultViewController
        else { return }
        
        resultController.delegate = self
        
        APICaller.shared.searchMovie(with: query) {result in
                switch result{
                case .success(let movies):
                    DispatchQueue.main.async {
                    resultController.movies = movies
                    resultController.searchResultCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                
            }
            
        }
    }
    
// Пушим DetailViewController по нажатию на ячейку
    
    func searchResultViewControllerDidTapItem(_ viewModel: DetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = DetailViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
