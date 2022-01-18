//
//  HomeViewController.swift
//  navi
//
//  Created by Даня on 03.01.2022.
//

import UIKit

enum Sections: Int{
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Movie?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies","Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViweTableViewCell.self, forCellReuseIdentifier: CollectionViweTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        title = "Movies"
        
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        configureHeroHeaderView()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureNavBar()
    }
    
    private func configureHeroHeaderView(){
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result{
            case .success(let movies):
                let selectedTitle = movies.randomElement()
                
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: MovieViewModel(titleName: selectedTitle?.originalName ?? selectedTitle?.originalTitle ?? "Unknown", posterURL: selectedTitle?.posterPath ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let leftItemButton = UIButton(type: .custom)
        leftItemButton.setImage(image, for: .normal)
        leftItemButton.addTarget(self, action: #selector(leftItemButtonAction(target:)), for: .touchUpInside)
        leftItemButtonConstraints(button: leftItemButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftItemButton)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func leftItemButtonConstraints(button: UIButton){
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    @objc
    func leftItemButtonAction(target: UIButton){
        print("Logo touch")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViweTableViewCell.identifier, for: indexPath) as? CollectionViweTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTV { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

extension HomeViewController: CollectionViweTableViewCellDelegate{
    func collectionViweTableViewCellDidTapCell(_ cell: CollectionViweTableViewCell, viewModel: DetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = DetailViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
